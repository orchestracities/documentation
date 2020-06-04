# Keycloak Configuration

Users are registered on Keycloak, and thanks to it are authenticated and authorized
to perform actions against the APIs provided by Orchestra Cities. The following
section describes how Keycloak is configured and utilised to accomplish this,
alongside the Portal.

## Security Configuration

![Keycloak and Portal diagram](rsrc/keycloak/portal_keycloak_diagram.png)

Keycloak is used to both authenticate and authorise users who wish to access the
Orchestra Cities resources through the APIs. With the Portal for instance, we have
two clients used: the resource-server client, and the portal client.
The portal is deployed as a backend (providing its own API), and a frontend that users
can access through a web browser. The frontend authenticates users via the portal
client, and the backend authorises users via the resource-server client.

## Keycloak Clients

The portal client in Keycloak is set up as a public client, meaning it doesn't
require a secret to access. This client is used by the portal to authenticate users,
like those logging into the Portal's frontend. Being public, it does not give
control over client scopes and roles.

The resource-server client is a confidential client, meaning that its client-secret
is needed in order to authenticate against it. The portal's backend uses this client
to authorise actions, like creating or deleting resources through the APIs.
This is done by creating a list of roles for the resource-server client, which are
then assigned to groups the users can belong to, which in term define the actions
the users are allowed to perform.

To perform actions that involve altering Keycloak Users and Groups from
the Keycloak API, the Portal does have access to the default admin client within
a Keycloak realm (by default named admin-cli).

## Client Scopes

The following roles are created in the resource-server client, and are assigned
as optional client scopes:

- entity:read
- entity:write
- entity:create
- entity:delete
- subscription:read
- subscription:write
- subscription:create
- subscription:delete
- device:read
- device:write
- device:create
- device:delete
- devicegroup:read
- devicegroup:write
- devicegroup:create
- devicegroup:delete
- endpoint:read
- endpoint:write
- endpoint:create
- endpoint:delete
- group:read
- group:write
- group:create
- group:delete
- user:read
- user:write
- user:create
- user:delete

These represent both the resource being acted upon, and the action being
taken: reading, writing, creating and deleting. In order for a user to be authorised
to perform a certain action, they need to belong to a Keycloak Group that has the
corresponding role, where said Group is subgroup of the relevant Tenant.

The default client scopes roles and tenants are also assigned to both resource_server
and the portal client, the latter containing script mappers described in the
Keycloak Mappers section below.

## Tenants and Groups in Keycloak

Tenants in Keycloak are represented as Groups. Subgroups of these Tenant Groups
represent both the Service Paths used by the Orchestra Cities APIs, and the
larger "roles" that users can have within Tenants (Admin, Developer, User, Device).

![Keycloak and Portal diagram](rsrc/keycloak/tenant_groups.png)

Tenant Groups are marked are such with the attributes "tenant" and "service"
within Keycloak, whilst Service Path groups are marked with the attribute "servicePath".

## Keycloak mappers

In order to integrate other Orchestra Cities services, such as the Portal, a series
of Script Mappers were created as part of Client Scopes. This was done in order
to include in the tokens given out by Keycloak the necessary information on
Services/Tenants and Service Paths.

The client scope **Tenant** was created with the following scripts:

**Service**:

```javascript
var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var services = new HashMap();

groups.forEach(scanTenant);
groups.forEach(scanServicePath);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        if ( services.get(group.getName()) === null ) {
            var servicePath = new HashSet();
            services.put(group.getName(), servicePath);
        }
    } else if( group !== null && group.getParent() !== null ) {
        scanTenant(group.getParent());
    }
}

function scanServicePath(group){
    if ( isServicePath(group)===true ) {
        if ( services.get(getRoot(group).getName()) ){
            var servicePath = Java.type('java.util.HashSet');
            servicePath = services.get(getRoot(group).getName()) ;
            var fullServicePath = ModelToRepresentation.buildGroupPath(group).substring(("/"+getRoot(group).getName()).length);
            servicePath.add(fullServicePath);
        }
    }
    if( group.getParent() !== null ) {
        scanServicePath(group.getParent());
    }
}

function getRoot(group){
    if(group.getParent() !== null)
        return getRoot(group.getParent());
    return group;
}


function isServicePath(group){
    if (group.getFirstAttribute("servicePath") == "true")  
        return true;
    return false;
}

function isTenant(group){
    if (group.getParent()===null &&
        group.getFirstAttribute("tenant") == "true"){
        if (services.get(group.getName()) === null) {
            var servicePath = new HashSet();
            services.put(group.getName(), servicePath);
        }
        return true;
    }
    return false;
}

token.setOtherClaims("fiware-services", services);
```

**Client_check**

```javascript
var clientId = keycloakSession.getContext().getClient().getClientId();
token.setOtherClaims("client_check", clientId);
```

**Tenant-groups-roles**

```javascript
var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ArrayList = Java.type('java.util.ArrayList');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var tenants = new ArrayList();

groups.forEach(scanTenant);
groups.forEach(scanGroups);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        found = getTenant(group.getName());
        if ( !found ) {
            var groups = new ArrayList();
            var tenant = new HashMap();
            tenant.put("id",group.getId());
            tenant.put("name",group.getName());
            tenant.put("groups",groups);
            tenants.add(tenant);
        }
    } else if( group !== null && group.getParent() !== null ) {
        scanTenant(group.getParent());
    }
}

function scanGroups(group){
    if ( isTenant(group)===false )  {
        found = getTenant(getRoot(group).getName());
        if ( found ) {
            groups = found.get("groups");
            current = getGroup(groups, group.getName());
            if (! current ){
                var newGroup = new HashMap();
                newGroup.put("name", group.getName());
                newGroup.put("is_servicepath", isServicePath(group));
                newGroup.put("parent", group.getParent().getName());
                var rep = ModelToRepresentation.toRepresentation(group, true);
                if (rep.getRealmRoles())
                    newGroup.put("realmRoles",rep.getRealmRoles());
                if( keycloakSession.getContext().getClient()){
                    var clientId = "resource_server";
                    //var clientId = keycloakSession.getContext().getClient().getClientId();
                    if(rep.getClientRoles().get(clientId)) newGroup.put("clientRoles",rep.getClientRoles().get(clientId));
                } else {
                    var clients = realm.getClients();
                     for (i= 0; i<clients.size(); i++){
                        item = clients.get(i);
                        var clientId = item.getClientId();
                        if(rep.getClientRoles().get(clientId)) newGroup.put(clientId,rep.getClientRoles().get(clientId));
                    }
                }
                groups.add(newGroup);
            }
        }
    }
    if( group.getParent() !== null ) {
        scanGroups(group.getParent());
    }
}

function getTenant(name){
    for (i= 0; i<tenants.size(); i++){
        item = tenants.get(i);
        if (item.get("name")===name)
            return item;
    }
    return null;
}

function getGroup(groups, name){
    for (i= 0; i<groups.size(); i++){
        item = groups.get(i);
        if (item.get("name")===name)
            return item;
    }
    return null;
}

function getRoot(group){
    if(group.getParent() !== null)
        return getRoot(group.getParent());
    return group;
}


function isServicePath(group){
    if (group.getFirstAttribute("servicePath") == "true" || group.getFirstAttribute("servicepath") == "true")  
        return true;
    return false;
}

function isTenant(group){
    if (group.getParent()===null &&
        group.getFirstAttribute("tenant") == "true"){
        return true;
    }
    return false;
}

token.setOtherClaims("tenants", tenants);
```

In addition, under the scope **Tenant-names** the script **Only-tenant-names**
was created:

```javascript
var HashMap = Java.type('java.util.HashMap');
var HashSet = Java.type('java.util.HashSet');
var ArrayList = Java.type('java.util.ArrayList');
var ModelToRepresentation = Java.type('org.keycloak.models.utils.ModelToRepresentation');
var groups = user.getGroups();
var tenants = new ArrayList();

groups.forEach(scanTenant);

function scanTenant(group){
    if ( isTenant(group)===true ) {
        found = getTenant(group.getName());
        if ( !found ) {
            tenants.add(group.getName());
        }
    } else if( group !== null && group.getParent() !== null ) {
        scanTenant(group.getParent());
    }
}

function getTenant(name){
    for (i= 0; i<tenants.size(); i++){
        item = tenants.get(i);
        if (item===name)
            return item;
    }
    return null;
}

function getRoot(group){
    if(group.getParent() !== null)
        return getRoot(group.getParent());
    return group;
}


function isTenant(group){
    if (group.getParent()===null &&
        group.getFirstAttribute("tenant") == "true"){
        return true;
    }
    return false;
}

token.setOtherClaims("tenants", tenants);
```

## Authentication Flows

![Authentication Flows](rsrc/keycloak/authentication_flows.png)

The authentication flows within Keycloak need to be configured with the following
auth types:

- **Required Admin Role Flow Forms** as an alternative
- A **Script** for a data-admin check, set as required.

The script is as follows:

```javascript
AuthenticationFlowError = Java.type("org.keycloak.authentication.AuthenticationFlowError");
function authenticate(context) {

    if(user.hasRole(realm.getRole("data-admin"))){
        context.success();
        return;
    }

    context.failure(AuthenticationFlowError.INVALID_USER);
}
```
