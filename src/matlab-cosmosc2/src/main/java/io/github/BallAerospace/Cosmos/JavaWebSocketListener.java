package io.github.BallAerospace.Cosmos;

// Interface that defines the callbacks in MATLAB.
// Inside MATLAB, they need to be referenced, for example as 'OpenCallback'
public interface JavaWebSocketListener extends java.util.EventListener {
    void Open( JavaWebSocketEvent event );
    void TextMessage( JavaWebSocketEvent event );
    void BinaryMessage( JavaWebSocketEvent event );
    void Error( JavaWebSocketEvent event );
    void Close( JavaWebSocketEvent event );
}
