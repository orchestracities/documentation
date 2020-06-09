# Security Management

The security is managed using the following services:
* Keycloak (OIDC Provider) provides Authentication, Authorisation and Accounting for User and ODIC/OAuth Clients
* Gravitee (API Manager) provides - in combination with Keycloak - Authentication, Authorisation and Accounting for APIs
* Admin Portal () provides ways to manage Tenants (Service in FIWARE terminology), Users within a Tenants, Groups within a Tenants and ServicePaths (specific to FIWARE APIs)


Things to be discussed
* **TO DO** Figure with the arch of above components (APIs)
* **TO DO** Figure with the arch of above components (UIs)
* **TO DO** Introduction on Multitenancy Management (why not using Keycloak Realms)

For details on security configuration:
* Default Keycloak configuration
  * **TODO** list of default roles
  * **TODO** list of default clients
  * **TODO** how to create a new tenant
  * **TODO** list of default groups x tenant
* General Gravitee configuration
* Admin Portal configuration
  * **TODO** what is needed to be sure the portal can connect to keycloak and
    do things