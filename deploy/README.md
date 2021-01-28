# Deploy example

In order to launch a local deployment of the platform, you can do the following:

## Add Keycloak to the local hosts file

In order for the Portal to connect to Keycloak correctly, they need to be added
to the local hosts file pointing to the local IP.
Open `/etc/hosts` and add them like so:

```
0.0.0.0  keycloak
0.0.0.0  portal
```

## Start the containers

All the containers can be started and configured using the script included

```
 ./deploy.sh
```

and for stopping the containers, there's another script for that as well

```
 ./clean.sh
```

## Set up Keycloak from the Admin UI

There's a few necessary steps to setup Keycloak to work with the Portal:

1. Access the Admin UI from http://localhost:8080
2. Login with the default admin user (USERNAME: admin, PASSWORD: password)
3. Under clients, find the admin-cli client. Under Service Account Roles, add
   all the available unassigned roles to the client.
4. Under users, create a new user. Give it a username and email at least, and
   set a password for it. Ensure to tick the box for verified email, and untick
   the box for temporary password. Add the user to the groups
   /EnvironmentManagement/Demo and Admin under the Town group.

## Log into the Portal

You can now log into the portal at http://localhost:8000 using the newly created
user. An example Device and Group has been created and filled with a basic
temperature attribute.

## Send some data to the UL IoT Agent

With the script send_payload_to_agent.sh you can send an air quality reading to
a device called Device. The script can be invoked as:

```
 ./send_payload_to_agent.sh 51
```

Where 51 is the air quality reading to send for example. You can see the changes
reflect onto the map in Grafana.

## Log into Grafana

The Grafana dashboards can be found at http://localhost:3000 . Login with the
default admin user (USERNAME: admin, PASSWORD: admin). An example dashboard
can be found under the general group showing a map with the example device for
air quality. It should appear as an icon in Switzerland.

# Todo (next)
- Use newer keycloak and load scripts
- Use newer grafana
