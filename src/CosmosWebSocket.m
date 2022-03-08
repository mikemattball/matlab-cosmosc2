classdef CosmosWebSocket < CosmosWebSocketClient
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here

    properties (SetAccess = private)
        SCOPE % The Cosmos Scope
        AUTH % Cosmos Authorization
    end

    methods
        function obj = CosmosWebSocket(SCHEMA,HOST,PORT,ENDPOINT,AUTH,SCOPE,varargin)
            % -------------------------------------------------------------
            % CosmosWebSocket Constructor - WebSocket object to call Cosmos
            % -------------------------------------------------------------
            %
            % Inputs:
            %   SCHEMA   - (String) The SCHEMA must be of the form 'ws[s]'.
            %   HOST     - (String) The HOST must be String 'localhost'.
            %   PORT     - (Number) The PORT must be positive number: 2900.
            %   ENDPOINT - (String) The endpoint of the web socket: '/cosmos-api/cable'
            %   AUTH     - (String) Cosmos Authorization
            %   SCOPE    - (String) Cosmos Scope

            if ~ischar(SCHEMA) || ~ischar(HOST) || ~isnumeric(PORT) || ~ischar(ENDPOINT)
                error('incorrect input check SCHEMA, HOST, PORT, and ENDPOINT input');
            end
            obj.AUTH = AUTH;
            obj.SCOPE = SCOPE;
            URI = lower(strcat(SCHEMA,'://',HOST,':',int2str(PORT),ENDPOINT));
            obj@CosmosWebSocketClient(URI,varargin{:});
        end     

        function message = onTextMessage(obj, message)
            % This function simply displays the message received
            fprintf('Message received: %d\n',length(message));
            struct message_struct = jsondecode(message);
            message = message_struct;
        end

        function onBinaryMessage(obj, bytearray)
            % This function simply displays the message received
            fprintf('Binary message received: %d\n',length(bytearray));
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

