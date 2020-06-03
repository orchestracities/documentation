# The Portal and Keycloak

Users can access the resources of Orchestra Cities through the Portal, and through
Keycloak the Portal authenticates them, and authorise the actions they perform.
The following section details how the Portal and Keycloak are set up to accomplish this.

## Security Configuration

![Keycloak and Portal diagram](rsrc/keycloak/portal_keycloak_diagram.png)

Keycloak is used to both authenticate and authorize users who wish to access the
Orchestra Cities resources through their APIs. Two clients are set up in keycloak
for this: the resource-server client, and the portal client.
The portal is deployed as a backend (providing its own API), and a frontend that users
can access.

## Keycloak Clients

The portal client in Keycloak is set up as a public client, meaning it doesn't
require a secret to access. This client is used by the portal to authenticate users,
like those logging into the Portal's frontend.

The resource-server client is a confidential client, meaning that its client-secret
is needed in order to authenticate against it. The portal's backend uses this client
to authorize user actions, like creating or deleting resources through the APIs.
This is done by creating a list of roles for the resource-server client, which are
then assigned to groups the users can belong to, which in term define the actions
the users are allowed to peform.

Lastly, to perform actions that involve altering Keycloak Users and Groups from
the Keycloak API, the Portal does have access to the default admin client within
a Keycloak realm (by default named admin-cli).

## Client Scopes

The following roles are created in the resource-server client, and are assigned
as client scopes:

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

## Tenants and Groups in Keycloak

Tenants in Keycloak are represented as Groups. Subgroups of these Tenant Groups
represent both the Service Paths used by the Orchestra Cities APIs, and the
larger "roles" that users can have within Tenants (Admin, Developer, User, Device).

![Keycloak and Portal diagram](rsrc/keycloak/tenant_groups.png)

Tenant Groups are marked are such with the attributes "tenant" and "service"
within Keycloak, whilst Service Path groups are marked with the attribute "servicePath".
