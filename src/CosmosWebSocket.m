classdef CosmosWebSocket < CosmosWebSocketClient
    %CosmosWebSocket A wrapper for the CosmosWebSocketClient
    %   I have no idea what I am doing writting this.

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

            if ~exist('SCHEMA','var')
                SCHEMA = getenv('COSMOS_WS_SCHEMA');
                if isempty(SCHEMA)
                    SCHEMA = 'ws';
                end
            end
            if ~exist('HOST','var')
                HOST = getenv('COSMOS_API_HOSTNAME');
                if isempty(HOST)
                    HOST = 'localhost';
                end
            end
            if ~exist('PORT','var')
                PORT = getenv('COSMOS_API_PORT');
                if ischar(PORT) && isempty(HOST)
                    PORT = 2900;
                end
            end
            if exist('PORT','var') && ischar(PORT)
                PORT = str2num(PORT);
            end
            if ~exist('AUTH','var')
                AUTH = getenv('COSMOS_API_PASSWORD');
            end
            if ~exist('SCOPE','var')
                SCOPE = getenv('COSMOS_SCOPE');
                if isempty(SCOPE)
                    SCOPE = 'DEFAULT';
                end
            end
            if ~exist('ENDPOINT','var')
                ENDPOINT = '/cosmos-api/cable';
            end
            if isempty(SCHEMA) || isempty(HOST) || ~isnumeric(PORT) || isempty(AUTH) || isempty(SCOPE) 
                error('Invalid arguments check input or environment.');
            end
            URI = lower(strcat(SCHEMA,'://',HOST,':',int2str(PORT),ENDPOINT));
            obj@CosmosWebSocketClient(URI,varargin{:});
            obj.AUTH = AUTH;
            obj.SCOPE = SCOPE;
        end

        function [tlm, tlm_names] = getData(obj,start,stop,item_defs,options)
            % -------------------------------------------------------------
            % To get any time query items
            % -------------------------------------------------------------
            %
            % [tlm, tlm_names] = db.getData(start, stop, ItemDefs, Options);
            %
            % Inputs:
            %
            %    start - The start date for the data selection.  In format
            %    'MM/DD/YYYY HH24:MI:SS:FF3'
            %
            %    stop- The end date for the data selection.  In the same
            %    format as start.
            %
            %    item_defs - 1 by X cell array  (Comma separated) of the
            %    target.packet.item you want.
            %
            %    options - Structure of all optional parameters
            %
            %       DataType - 'Converted' or 'Raw'.  Default is 'Converted'.
            %       Use 'Raw' to see the data before conversions are
            %       applied, as defined in the CMD/TLM server.
            %
            % Outputs:
            %
            %   tlm - array of cells that contains the resulting columns of
            %   data.  The indexes of these correspond with the tlm_names
            %   array.
            %
            %   tlm_names - array of the names of each column of data.
            %
            % Examples:
            % item_defs = {'INST.ADCS.POSX','INST.ADCS.POSY'}
            % start = '2/29/2022 00:00:00.000'
            % stop = '2/31/2022 15:51:40.000'

            startTime = datetime(start,'InputFormat','mm/dd/yyyy HH:MM:SS.FFF');
            startEpoch = convertTo(startTime,'epochtime');
            startValue = startEpoch * 1000000000;

            stopTime = datetime(stop,'InputFormat','mm/dd/yyyy HH:MM:SS.FFF');
            stopEpoch = convertTo(stopTime,'epochtime');
            stopValue = stopEpoch * 1000000000;

            tlm_names = zeros(1,length(item_defs));
            tlm = zeros(0);

            for i = 1 : numel(item_defs)
                pieces = strsplit(item_defs{i},'.');
                target = pieces{1};
                packet = pieces{2};               
                item = pieces{3};
                arg = strcat(target,'__',packet,'__',item);
                if strcmp(options.DataType, 'Raw')
                    arg = strcat(arg,'__','RAW');
                else
                    arg = strcat(arg,'__','CONVERTED');
                end
                tlm_names(i) = arg;
            end
        end
    end

    methods (Access = protected)
        function onOpen(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end

        function onTextMessage(obj, message)
            % This function simply displays the message received
            fprintf('Message received: %d\n',length(message));
            message_struct = jsondecode(message);
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
