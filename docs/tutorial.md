# Tutorial

## User Management

### Create a user

To create a new user, log into Keycloak's admin UI at
<https://auth.wolfsburg.digital/admin/default/console/#/realms/default>.
Make sure your Keycloak account has admin privileges on Keycloak to allow for
the creation of new users and assigning roles to them.

![](figures/keycloak.png)

From the Keycloak Admin UI, select "Users" on the left sidebar, and from there
click on "Add User". Fill in the new User's details and click on "Save".

Back on the Users page, find the newly created User and click on it to bring up
its details page. Under the groups tab, add the user to at least one tenant
group for the Portal, in this case it should be "Wolfsburg".

### Create Service Groups [Gabriele]

### Create User Groups and Assign User Roles [Gabriele]

### Add users to User Groups or Service Groups [Gabriele]

### User API Authentication [Fede+Tomas]

1. Obtain a token with your email and password:

    ```
    curl --request POST \
      --url https://auth.wolfsburg.digital/realms/default/protocol/openid-connect/token \
      --header 'Content-Type: application/x-www-form-urlencoded' \
      --data 'username=<username>&password=<password>&grant_type=password&client_id=resource_server&client_secret=<client_secret>'
    ```

  Response:

    ```
    {
        "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2l...",
        "expires_in": 36000,
        "refresh_expires_in": 3600,
        "refresh_token": "eyJhbGciOiJSUzI1NiIsInR5cCIg...",
        "token_type": "bearer",
        "not-before-policy": 0,
        "session_state": "849d007b-93b3-4a5d-87e8-653cd774485b"
    }
    ```

1. Validate your token (to see that the token actually works fine):

    ```
    curl --request POST \
      --url https://auth.wolfsburg.digital/realms/default/protocol/openid-connect/token/introspect \
      --header 'Content-Type: application/x-www-form-urlencoded' \
      --data 'client_id=resource_server&client_secret=<client_secret>&token=<access_token>'
    ```

    Response:
    ```
    {
        "jti": "d3304054-30d2-4328-b471-2e6c0410553f",
        "exp": 1550258044,
        "nbf": 0,
        "iat": 1550222044,
        "iss": "https://auth.s.orchestracities.com/auth/realms/default",
        "aud": "resource_server",
        "sub": "f2845018-6218-4b22-83d6-8b26681367e4",
        "typ": "Bearer",
        "azp": "resource_server",
        "auth_time": 0,
        "session_state": "57edaf48-6e72-4860-9c37-cbf29f39d6e1",
        "name": "developer developer",
        "given_name": "developer",
        "family_name": "developer",
        "preferred_username": "developer@orchestracities.com",
        "email": "developer@orchestracities.com",
        "acr": "1",
        "fiware-services": {
            "OrchestraCities": [
                "/WasteManagement",
                "/ParkingManagement",
                "/MobilityManagement",
                "/EnvironmentManagement"
            ],
            "Wolfsburg": [
                "/WasteManagement",
                "/ParkingManagement",
                "/EnvironmentManagement"
            ]
        },
        "scope": [
          ...
        ],
        "client_id": "resource_server",
        "username": "developer@orchestracities.com",
        "active": true
    }
    ```

## Register a device

### Configuring and deploying WebSocket importer

The data importers are responsible for the waste and parking data collection and that data is provided via websockets. So, the importers the main purpose, is to connect and receive information from the websockets and send it to the IoT Agent.

#### 1. Edit variables

The importers main functionality is to collect data from websockets and redirect it to the IoT-Agent. For that, you need to set the websocket and IoT Agent URL's.
The `constans.py` file contains all important variables like the URL's, that you can edit to change the configuration:

```python

# Data Sources
PARKING_URL = "ws://wobcom.thingsos.de:8999/integrations/22"
WASTE_URL = "ws://wobcom.thingsos.de:8999/integrations/21"

# Orion
ORION_URL = "https://orion.wolfsburg.digital/v2/op/update/"
FIWARE_SERVICE = "Wolfsburg"
FIWARE_SERVICE_PATH = "/WasteManagement"

# IoT Agent
IOT_AGENT_URL = "https://iot-agent-ul.wolfsburg.digital/config/iot/"
IOT_AGENT_UPDATES_URL = "https://iot-agent-ul.wolfsburg.digital/iot/ul"
IOT_AGENT_API_KEY_WASTE = "wolfsburg_api_key_waste_management"
IOT_AGENT_API_KEY_PARKING = "wolfsburg_api_key_parking_management"
IOT_AGENT_RESOURCE = "/iot/ul"

SERVICE_GROUPS = [
    {
        "name": "WasteContainer",
        "api_key": IOT_AGENT_API_KEY_WASTE
    },
    {
        "name": "ParkingSpot",
        "api_key": IOT_AGENT_API_KEY_PARKING
    }
]
```

 * **PARKING_URL:** Parking data websocket URL
 * **WASTE_URL:** Waste data websocket URL

 * **IOT_AGENT_URL:** IoT Agent URL. Must follow this format: `https://<insert_dns>/config/iot/`
 * **IOT_AGENT_UPDATES_URL:** IoT Agent URL for devices updates. Must follow this format: `https://<insert_dns>/iot/d`

Besides the Websockets and Iot Agent URL's you can also change the API Key's for parking and waste data. This API Key's, are used for the devices updates. The default values are:

 * **IOT_AGENT_API_KEY_WASTE:** `wolfsburg_api_key_waste_management`
 * **IOT_AGENT_API_KEY_PARKING:** `wolfsburg_api_key_parking_management`

The remain variables define the service and path inside the Orion Context Broker. That means that the data will be saved inside the service and path that you define. The default values are:

 * **FIWARE_SERVICE:** `Wolfsburg`
 * **FIWARE_SERVICE_PATH:** `/WasteManagement`

#### 2. Run locally to test

Before running in production you can test the importers locally. For that you just need to run each importer individually:

**Run the parking importer:**

```promp
python parking_sub.py
```

You should see the following result:

![Run Parking Subscription](images/parking_sub.png)

**Run the waste importer:**

```prompt
python waste_sub.py
```

You should see the following result:

![Run Waste Subscription](images/waste_sub.png)

#### 3. Create docker images

#### 3.1. Docker image for Parking importer

First you need to build the Docker image. To do that, you need to do the following command:

```prompt
docker build -f Dockerfile.parking .
```
As result you should see something like:

![Build Docker Parking Image](images/build_parking_image.png)

After the image being sucessfully built, you must use the resulting Docker image reference to tag the image:

```prompt
docker tag <result_reference> <docker_registry>/<image_name>:<version>
```

Example:
```prompt
docker tag 3dad2e427c9a <somedockerregistry>/parking_importer:1.0
```

Finally, you just need to push the new image to the docker registry:

```prompt
docker push <docker_registry>/<image_name>:<version>
```

Example:
```prompt
docker push <somedockerregistry>/parking_importer:1.0
```

As result you should see something like:

![Push Docker Parking Image](images/push_parking_image.png)

#### 3.2. Docker image for Waste importer

For the waste importer, the process is exactly the same, you just need to use the `Dockerfile.waste` instead `Dockerfile.parking` for the image build.

#### 4. Update deployment files

Before we can update the running services with the new images, we first need to update the deployments files in order to set the Docker image version to deploy.
For that you must update the files `parking_deployment.yaml` and `waste_deployment.yaml` and set the field `image` with the new Docker image generated before. Example:

```YAML
....
    spec:
      containers:
      - name: wolfsburg-parking-importer
        image: orchestracities/wolfsburg-parking-importer:1.3
```

#### 5. Remove old parking and waste importers deployments

Before the deploy of the new image for parking or waste importer it is necessary to remove the (old) ones that are still running. For that you need to run:

```prompt
kubectl delete -f parking_deployment.yaml
```

 and

 ```prompt
kubectl delete -f waste_deployment.yaml
```

#### 6. Deploy the new importers version

After removing the old versions, you need to create the deployment with the new versions:

```prompt
kubectl create -f parking_deployment.yaml
```

 and

 ```prompt
kubectl create -f waste_deployment.yaml
```

### Register a device using APIs

In order to receive and store the data that is dispatched from the importers, first you need to register the device in the IoT Agent. For that, you need to create the service groups and the devices.

#### Service groups Operations

* [TODO] update using protected APIs! [TOMAS]

#### 1. Create

```prompt
curl -X POST \
  https://iot-agent-ul.wolfsburg.digital/config/iot/services \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Fiware-Service: Wolfsburg' \
  -H 'Fiware-ServicePath: /WasteManagement' \
  -d '{
	"services": [
	   {
	     "apikey":      "wolfsburg_api_key_waste_management",
	     "cbroker":     "https://orion.wolfsburg.digital/v2/op/update/",
	     "entity_type": "WasteContainer",
	     "resource":    "/iot/ul"
	   }
	]
}'
```

This request is responsible to create the service group for the Waste devices. For the Parking devices you must change the value for the fields `apiKey` and `entity_type` to `wolfsburg_api_key_parking_management` and `ParkingSpot`.

#### 2. Update

```prompt
curl -iX PUT \
  'https://iot-agent-ul.wolfsburg.digital/config/iot/services?resource=/iot/ul&apikey=wolfsburg_api_key_waste_management' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: Wolfsburg' \
  -H 'fiware-servicepath: /WasteManagement' \
  -d '{
  "entity_type": "WasteContainerUpdate"
}'
```

This request will update the value for the field `entity_type` for the service group with `apiKey=wolfsburg_api_key_waste_management` and resource `resource=/iot/ul` for the specified `fiware-service` and `fiware-servicepath`.

#### 3. Delete

```prompt
curl -X DELETE \
  'https://iot-agent-ul.wolfsburg.digital/config/iot/services/?resource=/iot/ul&apikey=wolfsburg_api_key_waste_management' \
  -H 'Cache-Control: no-cache' \
  -H 'fiware-service: Wolfsburg' \
  -H 'fiware-servicepath: /WasteManagement'
```

This request will delete the service group `apiKey=wolfsburg_api_key_waste_management` and resource `resource=/iot/ul` for for the specified `fiware-service` and `fiware-servicepath`.

More operations (and examples) related with the services groups can be found [here](https://github.com/Fiware/tutorials.IoT-Agent#service-group-crud-actions).

#### Devices Operations

* [TODO] update using protected APIs! [TOMAS]

#### 1. Create

```prompt
curl -X POST \
  'https://iot-agent-ul.wolfsburg.digital/config/iot/devices \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: Wolfsburg' \
  -H 'fiware-servicepath: /WasteManagement' \
  -d '{
	"devices": [
	   {
	     "device_id":   "waste001",
	     "entity_name": "urn:ngsd-ld:Waste:001",
	     "entity_type": "WasteContainer",
	     "timezone":    "Europe/Lisbon",
	     "attributes": [
	       { "object_id": "l", "name": "location", "type": "geo:point" },
         { "object_id": "ld", "name": "locationDescription", "type": "Text" },
         { "object_id": "a", "name": "address", "type": "Text" },
	       { "object_id": "t", "name": "temperature", "type": "Number"},
	       { "object_id": "d", "name": "description", "type": "Text"},
         { "object_id": "si", "name": "site", "type": "Text"},
	       { "object_id": "S", "name": "status", "type": "Text"},
         { "object_id": "swk", "name": "storedWasteKind", "type": "Text"},
         { "object_id": "um", "name": "utm_e", "type": "Text"},
         { "object_id": "swk", "name": "utm_n", "type": "Number"},
	       { "object_id": "m", "name": "dateModified", "type": "DateTime"},
         { "object_id": "dle", "name": "dateLastEmptying", "type": "DateTime"},
	       { "object_id": "g", "name": "simulated", "type": "Boolean"},
	       { "object_id": "p", "name": "proximity", "type": "Number"},
	       { "name": "fillingLevel", "type": "Number", "expression": "${(@deviceHeight - @proximity) / @deviceHeight}"}

	     ],
	     "static_attributes": [
	       { "name":"deviceHeight", "type": "Number", "value": 160}
	     ]
	   }
	 ]
}'
```

#### 2. Update

```prompt
  curl -iX PUT \
  'https://iot-agent-ul.w.orchestracities.com/config/iot/devices/waste001' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: Wolfsburg' \
  -H 'fiware-servicepath: /WasteManagement' \
  -d '{
    "entity_type": "IoT-Device"
  }'
```

#### 3. Delete

```prompt
curl -iX DELETE \
  'https://iot-agent-ul.w.orchestracities.com/config/iot/devices/waste001' \
  -H 'fiware-service: Wolfsburg' \
  -H 'fiware-servicepath: /WasteManagement'
  ```

More operations (and examples) related with the devices can be found [here](https://github.com/Fiware/tutorials.IoT-Agent#device-crud-actions).

### Register a device using UI

To register a new Device, access the Portal at
<https://portal.wolfsburg.digital/dashboard/>, and log in with your Keycloak
credentials.

![](figures/login.png)

![](figures/home.png)

From the top navigation bar select "Device Groups" under "Device Management"

![](figures/device_groups.png)

Next to a Device Group there are 4 icons. From left to right they allow the user
to view more details of the group, see the Devices registered under it, edit the
group, and delete the group. Select the second icon next to the group you want
to create a Device under. Alternatively, you can select "New Device Group" at
the top to create a new Group.

Clicking the second icon will bring up the list of Devices registered under
that particular group.

![](figures/devices.png)

You have the option to register a single new Device, or multiple Devices in bulk
using a configuration file listing them. For now, select
"Register single Device".

![](figures/new_device.png)

In the new Device form fill in the information for the Device you're registering
and click submit. Make sure all required fields are filled in correctly.

Your newly registered Device should now be visible in the Devices list.

## Data Management

The entry point for any data management activity (other options may be possible,
but are not recommended for "live data"), is Orion Context Broker.
A publish subscribe middleware handling data generated by devices.
The data format supported by Orion is NGSI v2.
Each *entity*, i.e. instance of a specific data set, is
described using JSON. The FIWARE Community defined a set of data models for
different tasks (the models are documented
[here](https://fiware-datamodels.readthedocs.io/en/latest/)).
In the following you can find an example for `ParkingSpot` entity.

```
{
    "id": "santander:daoiz_velarde_1_5:3",
    "type": "ParkingSpot",
    "name": "A-13",
    "location": {
        "type": "Point",
        "coordinates": [-3.80356167695194, 43.46296641666926]
    },
    "status": "free",
    "category": ["onstreet"],
    "refParkingSite": "santander:daoiz_velarde_1_5"
}
```

More information about NGSI data models are available as part of the
[NGSI v2](https://fiware.github.io/specifications/ngsiv2/stable/) specification.

It is important to highlight that an NGSI Context Broker supports only
last point in time of a given data. I.e. the current status of
the `ParkingSpot`, if we link to the previous example.

This means that to store the historical records of a given data set (e.g. the
different values in different point in time of the attributes of the entity
`ParkingSpot` with id `santander:daoiz_velarde_1_5:3`), we need
to leverage another component. In this case the feature is provided the
[Quantum Leap Timeseries API](https://quantumleap.readthedocs.io/en/latest/).

The storage of data in Quantum Leap leverages NGSI subscriptions.
By creating a subscriptions in Context Broker, we can record, each time an
entity is updated, its values in Quantum Leap. I.e. store a time series of
entities values.

For example, to record in Quantum Leap all the updates of entities of type
`ParkingSpot`, we would use a subscription as follow:

```
{
    "description": "ParkingSpot subscription",
    "subject": {
        "entities": [
        {
            "idPattern": ".*",
            "type": "ParkingSpot"
        }
        ],
        "condition": {
            "attrs": []
        }
    },
    "notification": {
        "http": {
            "url": "http://quantumleap:8668/v2/notify"
        },
        "attrs": [],
        "metadata": ["dateCreated", "dateModified"]
    },
    "throttling": 5
}
```

Details on the specification of the subscription payload are discussed in
Orion Context Broker [documentation](https://fiware-orion.readthedocs.io/en/master/user/walkthrough_apiv2/index.html#subscriptions)
and in NGSI v2 [spec](https://fiware.github.io/specifications/ngsiv2/stable/).

Similarly, should we wish to "forward" any data received from Context Broker to
another service, we should create a subscription.

**Note:** If you send data to Context Broker before creating a subscription,
data sent before the creation are not persisted in Quantum Leap (or any other
service).

### Alignment with FIWARE Data Models

While in principle it is possible to store any data model in Orion, it is
highly recommended to leverage FIWARE [Data Models](https://fiware-datamodels.readthedocs.io/en/latest/). Leveraging standardised datamodels ensure
that different cities produce easy to re-use data. The benefit of this approach
is that applications and services build on top of such models are easy to
be re-used on different cities.

Of course, your application may need additional models or slight modifications
to existing models. In case we recommend to contribute your additions and
changes and discuss them with the community as discussed in the
[HOW TO USE FIWARE HARMONISED DATA MODELS IN YOUR PROJECTS](https://fiware-datamodels.readthedocs.io/en/latest/howto/index.html) section.

### Querying Context Data

#### Querying Context Data from the UI

Querying entities from the Context Broker can be done from the Portal's UI.
Log in from <https://portal.wolfsburg.digital/dashboard/> with your Keycloak
credentials, and from the navbar on the home page select "Entities" under
"Data Management".

![](figures/entities.png)

From there, you'll be able to see all entities under the currently selected
tenant, and filter by entity types and service paths (used by the device
groups).

#### Querying Context Data from the API [Fede+Tomas]

1. To query context data, you will need to get a token (and api key if you need
   to run many queries).

1. With your `access_token` and your `apiKey`, you can list all entities in a given
    Tenant (fiware-Service) and Service Group (fiware-ServicePath):

    ```
    curl --request GET \
      --url https://api.wolfsburg.digital/context/v2/entities \
      --header 'Authorization: Bearer <access_token>' \
      --header 'Content: application/json' \
      --header 'X-Gravitee-Api-Key: <apiKey>' \
      --header 'fiware-Service: OrchestraCities' \
      --header 'fiware-ServicePath: /ParkingManagement'
    ```

1. Or access a specific entity in a given
    Tenant (fiware-Service) and Service Group (fiware-ServicePath):

    ```
    curl --request GET \
      --url https://api.wolfsburg.digital/context/v2/entities \
      --header 'Authorization: Bearer <access_token>' \
      --header 'Content: application/json' \
      --header 'X-Gravitee-Api-Key: <apiKey>' \
      --header 'fiware-Service: OrchestraCities' \
      --header 'fiware-ServicePath: /ParkingManagement'
    ```

For more information on context broker apis, refer to... [TOMAS]

### Querying Historical Data [Tomas]

## Importing data from external source

As early mentioned, the entry point for any data management activity is
usually the Orion Context Broker.
Importing data from external sources can be done in different ways. It is
important to keep in mind that the platform is currently focus on real time
data from APIs or sensors. This implies that importing "static" data, it is
currently supported via some work around.

### Which approach to use to import different type of data?

The rule of thumb could be the following:

- In case of dynamic data (i.e. data that relates to entities evolving over
  time), it is recommended to inject them via the
  Context Broker. In this way, the latest value will be in the Context Broker,
  and historical values (eventually) in QuantumLeap.

- In case the data to be imported represent sensors, it would be ideal to import
  such data via the IoT Agent framework. This may not necessarily mean to
  develop your own IoT Agent (which is anyhow possible via
  [IoT Agent Node Library](https://github.com/telefonicaid/iotagent-node-lib)).
  An easy alternative would be to perform the integration at the level of
  the IoT Agent payload API (for example using the UL with HTTP transport,
  or the JSON IoT Agent with HTTP transport). The advantages of this solution
  are:
    * ability to describe sensors within the FIWARE framework;
    * ability to change from the IoT Agent API the data mapping between sensor
      data and entities;
    * ability to manage static data related to the sensor as part of the IoT
      Agent configuration;
    * ability to leverage IoT Agent [expression](https://iotagent-node-lib.readthedocs.io/en/latest/expressionLanguage/index.html);

  Data will be then registered by the IoT Agent into Context Broker, and
  eventually, to QuantumLeap.

- In case of static data (i.e. data that relates to entities not evolving over
  time), it is recommended to inject them only in the the Context Broker.
  (May be of use storing them in Quantum Leap if you want to query them in
  Grafana, but other than that, it would not make sense).

- In case of historical data (i.e. data that pertains evolution of an entity
  in the past), it is recommended to inject them directly in Quantum Leap.
  Eventually, only the last point in time should be stored in Context Broker.
  Passing by Context Broker to store multiple time series, may be quite an
  overhead.

As mentioned above, t is highly recommended to leverage FIWARE
[Data Models](https://fiware-datamodels.readthedocs.io/en/latest/).

### Which tools to use to import data?

FIWARE Community, over time, developed different solutions.
You can search for them in GitHub and other FIWARE
community related fora.

Here are the recommendations from Orchestra Cities:

- In case high throughput is required, it is in generally better to develop
  a custom python data manipulation script.

- In case high throughput is not a priority, Apache
  [NIFI](https://nifi.apache.org/) or Stream Sets
  [Data Collector](https://streamsets.com/products/sdc) are good options.

### Example of Data Collector to Import a CSV File from CKAN

Here we shortly explain an example pipeline we created to import data
from a CSV file into Orion. Data imported are mapped to the `PointOfInterest`
data model. You can find the example ready to be customised
in the [Examples](examples/POI_GAS_STATIONS.json) folder.

  ![Example Pipeline](images/pipeline-overview.png "Example Pipeline")

1. The first stage of the pipeline retrieves the data using http and defines the data
  format of the retrieved file. In this case a CSV using `;` as delimiter.
  To do that we use an origin stage of type `HTTP Client`.

    ![Data Retrieval](images/pipeline-1.png "Data Retrieval")

1. The second stage of the pipeline, converts the CSV records to the NGSI data
  structure for the `PointOfInterest` data model. A processor stage of type
  `Expression Evaluator` is performing the task.
  Understanding
  [expressions](https://streamsets.com/documentation/datacollector/3.4.1/help/datacollector/UserGuide/Expression_Language/ExpressionLanguage_title.html)
  and related function of Data Collector is quite important to use this
  processor.
  For example, to create a `StructuredValue` in the JSON, we need first to
  create and empty map (using `${emptyMap()}`) and then map the each attribute
  of the map to its value (e.g. `/location/type` maps to `Point`).
  Similarly for arrays, we need first to create and empty list
  (using `${emptyList()}`) and then map the each array index
  to its value (e.g. `/location/coordinates[0]` maps to `${record:value('/LAT')}`).

    ![Data Mapping to NGSI](images/pipeline-2.png "Data Mapping to NGSI")

    **Note:** unfortunately at this stage there is no way to cast the value to
    a different type from the one derived from the CSV (text). So this has to be
    done using a processor stage of type `Field Type Converter`.

1. The third stage of the pipeline, removes unneeded fields from the CSV
  import. A processor stage of type
  `Field Remover` is performing the task.

    ![Remove unneeded fields](images/pipeline-3.png "Remove unneeded fields")

1. The forth stage of the pipeline, convert types of fields as needed using
   a processor stage of type `Field Type Converter`.

    ![Convert fields data type](images/pipeline-4.png "Convert fields data type")

1. The forth stage of the pipeline, normalise the NGSI representation (this is
  required to use batch operations on Orion) using a processor of type
  `Java Script`. The normalisation is the process to attach fields type to
  the data values.

    ![Normalise](images/pipeline-5.png "Normalise")

1. The last stage of the pipeline, send data to the Orion Context broker
  using a destination of type
  `Http Client`. In here we use the batch operation `/v2/op/update`.
  This approach is recommended to avoid the need
  to differentiate the call to Orion for creating or updating data. With
  this operation we need just to use `append` as `actionType` in the
  communication with the Orion end point.

    ![Send Data](images/pipeline-6.png "Send Data")

#### Tips

1. Use the preview icon and click on the stage to see how data are manipulated.

1. Before testing against the actual APIs, use a mockup service su as
   [WireMock](http://wiremock.org/) to ensure that the send payload are the ones you expect. [MockLab](https://app.mocklab.io/) offers also a cloud instance
   of WireMock.

  ![WireMock](images/wiremock.png "WireMock")


## Getting Access to APIs [Tomas]


## Creating Dashboards

For the dashboards creation you need to follow some steps:

#### 1. Create datasource

The datasource represents the incoming data that will be used to feed the dashboards. To create a new data source you need to:

1. Access the *Data Sources* section present in the *Configuration* panel. It will open a section where you can manages all the data sources and add new ones.

![Data Sources](images/data_sources.png)

2. Click in the *Add data source* button

![Add Data Source](images/add_data_source.png)

3. Fill all the fields with the desired configuration and click *Save & Test*

![Configure Data Source](images/configure_data_source.png)

#### 2. Start new dashboard / Import dashboard

To create a new dashboard you need to access the *Dashboard* under the *Create* section, and after that you will be asked to select a new visualization panel to add to the dashboard.

![Create Dashboard](images/create_dashboard.png)

Select the *Graph* option. After that, a new panel will be created, that you can move and resize as you wish.

![Create Graph](images/create_graph.png)

![Graph](images/graph_created.png)

At the top of the panel click on the down arrow next to *Panel Title* and then select *Edit* to configure the panel.

![Graph Options](images/graph_options.png)

At the configuration panel, you will be presented with severall sections:

**General**

Set static data as name and description of the panel.

![General](images/general.png)

**Metrics**

Section where you choose the data source and query that will feed the chart.

![Mertics](images/metrics.png)

If you use the example of the previous image you will be able to see the filling level for all available waste containers.

![Filling Level](images/filling_level.png)

**Axes**

Section where you can configure the chart axis.

![Axes](images/axes.png)

For the waste container filling level, we need to use the unit `percent (0.0-1.0)` for the Y axel, use `1` for `Decimals` and set `YMin` to `0` and the `YMax` to `1`. After that you will noticed that the Y axel units changed.

![Units](images/units.png)

**Legend**

Here you organize the way that you see the information related with the chart. Fot this case we will set the legend as a table, to the right where we can see the minimum, maximum and current value for each container filling level.

![Legend](images/legend.png)

**Display**

This section allows you to choose the way the data is represented on the chart. For this case the data will be represented with lines.

![Display](images/display.png)

#### 8. Save Dashboard

In order to save all changes regarding the dasboards you must do it manually every time you created/update a dashboard. For that you need to click on `disk` icon positioned at the top right corner of the window.

![SAve](images/save.png)

#### 9. Dashboard time representation

All the panels that are part of dashboard, represent data according to a specific time range. That time range can be defined at the top right corner of the portal.

![Time](images/time.png)

If you click on the time button you will be able to change the time range that you wnat to see.

![Set Time](images/time2.png)

#### 10. Dashboards organization

The dashboards can be organized as you wish. For that you need to access *Manage* under the *Dashboards* section.

![Manage](images/manage.png)

After that you will be able to see and manage all folders and dashboards.

![Manage2](images/manage2.png)
