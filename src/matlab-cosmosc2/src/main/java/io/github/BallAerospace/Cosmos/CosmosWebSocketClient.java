package io.github.BallAerospace.Cosmos;

import java.net.URI;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

public class CosmosWebSocketClient extends WebSocketClient {
    // This open a websocket connection as specified by RFC6455
    public CosmosWebSocketClient( URI serverURI, Map<String,String> httpHeaders ) {
        super( serverURI, httpHeaders );
    }

    // This function gets executed when the connection is opened
    @Override
    public void onOpen( ServerHandshake handshakedata ) {
        String openMessage = "Connected to server at " + getURI();
        CosmosWebSocketEvent matlab_event = new CosmosWebSocketEvent( this, openMessage );
        for (CosmosWebSocketListener _listener : _listeners) {
            (_listener).Open(matlab_event);
        }
    }

    // This function gets executed on text message receipt
    @Override
    public void onMessage( String message ) {
        CosmosWebSocketEvent matlab_event = new CosmosWebSocketEvent( this, message );
        for (CosmosWebSocketListener _listener : _listeners) {
            (_listener).TextMessage(matlab_event);
        }
    }

    // Method handler when a byte message has been received by the client
    @Override
    public void onMessage( ByteBuffer blob ) {
        CosmosWebSocketEvent matlab_event = new CosmosWebSocketEvent( this, blob );
        for (CosmosWebSocketListener _listener : _listeners) {
            (_listener).BinaryMessage(matlab_event);
        }
    }

    // This method gets executed on error
    @Override
    public void onError( Exception ex ) {
        CosmosWebSocketEvent matlab_event = new CosmosWebSocketEvent( this, ex.getMessage() );
        for (CosmosWebSocketListener _listener : _listeners) {
            (_listener).Error(matlab_event);
        }
        // If the error is fatal, onClose will be called automatically
    }

    // This function gets executed when the websocket connection is closed,
    // close codes are documented in org.java_websocket.framing.CloseFrame
    @Override
    public void onClose( int code, String reason, boolean remote ) {
        String closeMessage = "Disconnected from server at " + getURI();
        CosmosWebSocketEvent matlab_event = new CosmosWebSocketEvent( this, closeMessage );
        for (CosmosWebSocketListener _listener : _listeners) {
            (_listener).Close(matlab_event);
        }
    }

    // Methods for handling MATLAB as a listener, automatically managed.
    private final List<CosmosWebSocketListener> _listeners = new ArrayList<CosmosWebSocketListener>();
    public synchronized void addMatlabListener( CosmosWebSocketListener lis ) {
        _listeners.add( lis );
    }
    public synchronized void removeMatlabListener( CosmosWebSocketListener lis ) {
        _listeners.remove( lis );
    }
}
