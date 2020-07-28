# 4.3 Admin Portal

The purpose of the Admin Portal is to give users a way to manage the resources
from the Context Broker, as well as managing users and groups outside of the
Keycloak Admin Console. This means creating new users and groups, defining the
scopes of the groups and adding/removing users from them, controlling the users'
roles under the various Tenants available.

From Keycloak, the portal needs information about 3 clients, passed as environment
variables at deployment time:

- `KEYCLOAK_FRONTEND_CLIENT_ID`: The name of the client the portal uses to log in
  users. This needs to be public, as it is used by the frontend.
- `KEYCLOAK_OIDC_CLIENT_ID`: The name of the client the portal uses to authorise
  users. This is generally the `resource_server` client, and it's a confidential
  client.
- `KEYCLOAK_OIDC_CLIENT_SECRET`: The secret of the client above
- `KEYCLOAK_ADMIN_CLIENT_ID`: The name of the admin client of the Keycloak realm
  (by default is `admin-cli`). This is how the portal performs operations using
  the Keycloak API, like creating/deleting users and groups.
- `KEYCLOAK_ADMIN_CLIENT_SECRET`: The secret of the client above.
- `KEYCLOAK_ADMIN_USERNAME`: The username of an admin user in the Keycloak realm.
  This user needs to be able to access the Keycloak Admin Console, and manage
  users and groups in the realm. This should be a special admin user set up
  specifically to be used by the portal.
- `KEYCLOAK_ADMIN_PASSWORD`: The password of the above user.
