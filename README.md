Matlab-CosmosC2
===============

WebApi
---

CosmosJsonApi and CosmosJsonRpcApi are both interfaces that make it easier to get data from Cosmos v5 to Matlab. 


WebSockets
---

matlab-cosmosc2 is a simple library consisting of a client for MATLAB built on [Java-WebSocket](https://github.com/TooTallNate/Java-WebSocket), a java implementation of the websocket protocol. Encryption is supported with self-signed certificates made with the java keytool.

Installation and Uninstallation
---

*IMPORTANT*: you must make sure to install the java library to the static class path by following the instructions below. matlab-cosmosc2 will not work otherwise!

First, download the latest release on GitHub and extract the contents where you want.

The required java library is a `jar` file located in the `/jar/` folder. It must be placed on the static java class path in MATLAB. For example, if the location of the jar file is `C:\git\matlab-cosmosc2\jar\matlab-cosmosc2-*.*.jar`, then open the static class path file with the following command:
```matlab
edit(fullfile(prefdir,'javaclasspath.txt'))
```
and add the path to where you stored the jar `C:\git\matlab-cosmosc2\jar\matlab-cosmosc2-*.*.jar` to it. Make sure that there are no other lines with a `matlab-cosmosc2-*` entry.

Make sure to replace the stars `matlab-cosmosc2-*.*.jar` with the correct version number that you downloaded.

After having done this, restart MATLAB and check that the line was read by MATLAB properly by running the `javaclasspath` command. The line should appear at the bottom of the list, before the `DYNAMIC JAVA PATH` entries. Note that seeing the entry here does not mean that MATLAB necessarily found the jar file properly. You must make sure that the actual `jar` file is indeed at this location.

You must now add the `/src/` folder to the MATLAB  path. If you want to run the examples, add the `/examples/` folder as well.

Simply undo these operations to uninstall MatlabWebSocket.

See the [MATLAB  Documentation](http://www.mathworks.com/help/matlab/matlab_external/static-path.html) for more information on the static java class path.

Usage
---

To implement a WebSocket server or client, a subclass of either `WebSocketServer` or `WebSocketClient` must be defined. For more details (see the [object-oriented programming documentation of MATLAB](http://www.mathworks.com/help/matlab/object-oriented-programming.html)).

The `CosmosWebSocketClient.m` file is an abstract MATLAB class. The behavior of the server must therefore be defined by creating a subclass that implements the following methods:

```matlab
onOpen(obj,conn,message)
onTextMessage(obj,conn,message)
onBinaryMessage(obj,conn,message)
onError(obj,conn,message)
onClose(obj,conn,message)
```

 * `obj` is the object instance of the subclass, it is implicitly passed by MATLAB (see the [object-oriented programming documentation of MATLAB](http://www.mathworks.com/help/matlab/object-oriented-programming.html)).
 * `message` is the message received by the server. It will usually be a character array, except for the `onBinaryMessage` method, in which case it will be an `int8` array

These methods will be automatically called when the corresponding event (connection is opened, message received, etc...) occurs. In this way, a reactive behavior can be defined.

See the `test.m` files in the `examples` folder for an implementation example. A good resource on classes is the [MATLAB object-oriented documentation](http://www.mathworks.com/help/matlab/object-oriented-programming.html).

Example
---

Connecting to Cosmos v5 with the CosmosClient:

```matlab
SCHEMA = 'wss';
HOST = 'localhost';
PORT = 2900;
ENDPOINT = '/cosmos-api/cable';
client = CosmosWebSocket(SCHEMA,HOST,PORT,ENDPOINT);
```


SSL / WebSocket Secure (wss)
---

To enable SSL, you must first have a certificate. A self-signed key store can be generated with the java `keytool`, but you should always use a valid certificate in production. From there, open the server by passing the location of the store, the store password, and the key password. With the EchoServer, for example:

The client can then connect to it:
```matlab
SCHEMA = 'wss';
HOST = 'localhost';
PORT = 2900;
ENDPOINT = '/cosmos-api/cable';
c = CosmosWebSocket(SCHEMA,HOST,PORT,ENDPOINT,STORE,STOREPASSWORD,KEYPASSWORD);
```

Building the Java JAR
---

To build the `jar` file yourself, it is recommended to use Apache Maven. Maven will automatically take care of downloading Java-WebSocket and neatly package everything into a single file (an "uber jar"). 

If you are running on a network behind a firewall intercepting SSL certificates use these...

```
-Djavax.net.ssl.trustStore=
-Dmaven.wagon.http.ssl.insecure=true
-Dmaven.wagon.http.ssl.allowall=true
-Dmaven.wagon.http.ssl.ignore.validity.dates=true
```

Once the `mvn` command is on your path, simply `cd` to the `matlab-cosmosc2` folder and execute `mvn package`.

Acknowledgments
---

This work was based on a MATLAB websocket implementation:  [MatlabWebSockets](https://github.com/jebej/MatlabWebSocket).

This work was inspired by a websocket client MATLAB implementation:  [matlab-websockets](https://github.com/mingot/matlab-websockets).

It relies on the [Java-WebSocket](https://github.com/TooTallNate/Java-WebSocket) library.

License
---

The code in this repository is licensed under the MIT license. See the `LICENSE` file for details.
