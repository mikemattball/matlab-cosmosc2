package io.github.BallAerospace.Cosmos;

import java.net.URI;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.handshake.ServerHandshake;

public class JavaWebSocketClient extends WebSocketClient {
    // This open a websocket connection as specified by RFC6455
    public JavaWebSocketClient( URI serverURI, Map<String,String> httpHeaders ) {
        super( serverURI, httpHeaders );
    }

    // This function gets executed when the connection is opened
    @Override
    public void onOpen( ServerHandshake handshakedata ) {
        String openMessage = "Connected to server at " + getURI();
        JavaWebSocketEvent matlab_event = new JavaWebSocketEvent( this, openMessage );
        for (JavaWebSocketListener _listener : _listeners) {
            (_listener).Open(matlab_event);
        }
    }

    // This function gets executed on text message receipt
    @Override
    public void onMessage( String message ) {
        JavaWebSocketEvent matlab_event = new JavaWebSocketEvent( this, message );
        for (JavaWebSocketListener _listener : _listeners) {
            (_listener).TextMessage(matlab_event);
        }
    }

    // Method handler when a byte message has been received by the client
    @Override
    public void onMessage( ByteBuffer blob ) {
        JavaWebSocketEvent matlab_event = new JavaWebSocketEvent( this, blob );
        for (JavaWebSocketListener _listener : _listeners) {
            (_listener).BinaryMessage(matlab_event);
        }
    }

    // This method gets executed on error
    @Override
    public void onError( Exception ex ) {
        JavaWebSocketEvent matlab_event = new JavaWebSocketEvent( this, ex.getMessage() );
        for (JavaWebSocketListener _listener : _listeners) {
            (_listener).Error(matlab_event);
        }
        // If the error is fatal, onClose will be called automatically
    }

    // This function gets executed when the websocket connection is closed,
    // close codes are documented in org.java_websocket.framing.CloseFrame
    @Override
    public void onClose( int code, String reason, boolean remote ) {
        String closeMessage = "Disconnected from server at " + getURI();
        JavaWebSocketEvent matlab_event = new JavaWebSocketEvent( this, closeMessage );
        for (JavaWebSocketListener _listener : _listeners) {
            (_listener).Close(matlab_event);
        }
    }

    // Methods for handling MATLAB as a listener, automatically managed.
    private final List<JavaWebSocketListener> _listeners = new ArrayList<JavaWebSocketListener>();
    public synchronized void addJavaWebSocketListener( JavaWebSocketListener lis ) {
        _listeners.add( lis );
    }
    public synchronized void removeJavaWebSocketListener( JavaWebSocketListener lis ) {
        _listeners.remove( lis );
    }
}
