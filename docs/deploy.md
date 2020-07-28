# 3. Deploy an example instance

## 3.1 Production

For production grade deployments we recommend to use [Kubernetes](https://kubernetes.io/).
You can find a set of Helm Charts we use for that [here](https://github.com/orchestracities/charts).
Official charts of services such as PostgresSQL and MongoDB can be found
in their repos).
You would need around 6 kubernetes worker nodes with 8GB ram and 2 CPUs for
a small HA deployment (excluding analytics services). 
Optimal sizing depends on the 1) volume and 2) frequency of data you need
to inject in the platform; 3) number of side services (e.g. monitoring)
and 4) desired availability.

Deploying production ready services require quite some time and expertise in
using K8S, that are beyond what can be offered by our team to the community.
If you are interested, Martel offers consulting services to help in the process.