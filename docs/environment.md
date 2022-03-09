
> Ball Aerospace & Technologies Corp.

# Environment Variables

## COSMOS_API_SCHEMA

---

> BASE, ENTERPRISE

Set the schema for Cosmos. The schema can now be set via an environment variable `COSMOS_API_SCHEMA` to the network schema that Cosmos is running with. Normal options are `http` or `https`. The default is `http`

Example:

```
COSMOS_API_SCHEMA=http
```

## COSMOS_WS_SCHEMA

---

> BASE, ENTERPRISE

Set the web socket schema for Cosmos. The schema for web sockets can now be set via an environment variable `COSMOS_WS_SCHEMA` to the network schema that Cosmos is running with. Normal options are `ws` or `wss`. The default is `ws`

Example:

```
COSMOS_WS_SCHEMA=ws
```

## COSMOS_API_HOSTNAME

---

> BASE, ENTERPRISE

Set the hostname for all Cosmosc2 scripts. In v0 of cosmosc2 it would default to 127.0.0.1. The hostname can now be set via an environment variable `COSMOS_API_HOSTNAME` to network address of the computer running Cosmos. Note the default hostname is localhost

Example:

```
COSMOS_API_HOSTNAME=127.0.0.1
```

## COSMOS_API_PORT

> BASE, ENTERPRISE

Set the port for all cosmosc2 scripts. The port can be set via an environment variable `COSMOS_API_PORT` to the network port of the computer running Cosmos. Note the default port for Cosmos v5 is 2900

Example:

```
COSMOS_API_PORT=7777
```

## COSMOS_SCOPE

---

> BASE, ENTERPRISE

Set the scope for all cosmosc2 scripts. To set the environment variable `COSMOS_SCOPE` to the client_secret in you Cosmos v5 Keycloak. If this is not set the scope will default to `DEFAULT`.

Example:

```
COSMOS_SCOPE=sanDeigo
```

## COSMOS_API_PASSWORD

---

> BASE, ENTERPRISE

Set the password for all cosmosc2 scripts. To use a password you can set the environment variable `COSMOS_API_PASSWORD` to the password on your Cosmos v5 instance or user.

Example:

```
COSMOS_API_PASSWORD=iLoveLamp
```
