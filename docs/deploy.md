# How to deploy your own instance

In this repository you find [scripts](../deploy/) and a reference
[docker compose](../deploy/docker-compose.yaml) file that allows
you to deploy and configure a simple instance of Orchestra Cities.

The scripts also configure some default services in Keycloak and in Gravitee.

Proceed as follows:
1. Launch the deployment

  ```
  $ xxx
  ```

This script will launch the docker-compose and load an example keycloak
configuration. For better understanding how the configuration works,
read [here](keycloak.md).

1. Login in Keycloak at the following url: xxx. Regenerate all client secrets.

  * Default username: xxx and password: xxx 

1. Copy generated Client secrets in [api-key.env](../deploy/api-key.env) file.

1. Update the deployed services to load the new configuration.

  ```
  $
  ```

You can now access the services at this urls:
* Admin Portal: []() 
* Dashboard: []()
* Developer portal: []() 

## Production

For production level deployment we recommend to use [Kubernetes](https://kubernetes.io/).
You can find a set of Helm Charts we use for that [here](https://github.com/orchestracities/charts).
Official charts of services such as PostgresSQL and MongoDB can be found
in their repos).

Deploying production ready services require quite some time and expertise in
using K8S, that are beyond what can be offered by our team to the community.
If you are interested, Martel offers consulting services to help in the process.