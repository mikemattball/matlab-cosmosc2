package io.github.BallAerospace.Cosmos;

// Interface that defines the callbacks in MATLAB.
// Inside MATLAB, they need to be referenced, for example as 'OpenCallback'
public interface CosmosWebSocketListener extends java.util.EventListener {
    void Open( CosmosWebSocketEvent event );
    void TextMessage( CosmosWebSocketEvent event );
    void BinaryMessage( CosmosWebSocketEvent event );
    void Error( CosmosWebSocketEvent event );
    void Close( CosmosWebSocketEvent event );
}
