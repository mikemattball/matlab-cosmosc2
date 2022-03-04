classdef CosmosWebSocket < CosmosWebSocketClient
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here

    properties
    end

    methods
        function obj = CosmosWebSocket(varargin)
            %Constructor
            obj@CosmosWebSocketClient(varargin{:});
        end     

        function message = onTextMessage(obj, message)
            % This function simply displays the message received
            fprintf('Message received: %d\n',length(message));
            struct message_struct = jsondecode(message);
            message = message_struct;
        end

        function onBinaryMessage(obj, bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n',length(bytearray));
        end

        function onError(obj, message)
            % This function simply displays the message received
            fprintf('Error: %s\n',message);
        end

        function onClose(obj, message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
    end
end

