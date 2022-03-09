classdef CosmosWebSocket < CosmosWebSocketClient
    %CosmosWebSocket A wrapper for the CosmosWebSocketClient
    %   I have no idea what I am doing writting this.

    properties (SetAccess = private)
        SCOPE % The Cosmos Scope
        AUTH % Cosmos Authorization
        MODE % Used with processing data
        DATA % Used to store data
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
            obj.MODE = 0;
            obj.DATA = cell(1);
        end

        function updateMode(obj)
            % -------------------------------------------------------------
            % Reset MODE for client
            % -------------------------------------------------------------
            %
            % obj.updateMode();
            %
            % Inputs:
            %
            % Outputs:
            %
            % Examples:
            % history_count = 100
            if obj.MODE > 0
                obj.MODE = obj.MODE * -1;
                waitfor(obj,'MODE',0);
            end
            obj.close()
            obj.MODE = 0;
            obj.DATA = cell(1);
        end

        function [messages] = logMessages(obj,history_count)
            % -------------------------------------------------------------
            % Get log messages from Cosmos in real time.
            % -------------------------------------------------------------
            %
            % [messages] = obj.logMessages(start, stop, ItemDefs, Options);
            %
            % Inputs:
            %    history_count - Number of messages in the history
            %
            % Outputs:
            %   messages - 
            %
            % Examples:
            % history_count = 100

            if obj.MODE ~= 0
                error('Invlaid MODE for client.');
            end
            if ~isnumeric(history_count)
                error('Invlaid history_count value must be numeric.');
            end

            messages = cell(1);

            obj.MODE = 1;
            sId = struct('channel','MessagesChannel','scope',obj.SCOPE,'token',obj.AUTH,'history_count',history_count);
            sSubscribe = struct('command','subscribe','identifier',jsonencode(sId));
            disp(jsonencode(sSubscribe));
            % DEBUG obj.send(jsonencode(sSubscribe));

            waitfor(obj,'MODE',-1);

            messages = copy(obj.DATA);
            obj.MODE = 0;
            obj.DATA = cell(1);
        end

        function [tlm, tlm_names] = dataExtractor(obj,start,stop,item_defs,options)
            % -------------------------------------------------------------
            % Get data from cosmos.
            % -------------------------------------------------------------
            %
            % [tlm, tlm_names] = obj.dataExtractor(start, stop, ItemDefs, Options);
            %
            % Inputs:
            %    - start: The start date for the data selection.  In format 'dd/MM/yyyy HH:mm:SS:SS3'
            %    - stop: The end date for the data selection.  In the same format as start.
            %    - item_defs: 1 by X cell array  (Comma separated) of the target.packet.item you want.
            %    + options: Structure of all optional parameters
            %       - itemMode: 'Converted' or 'Raw'.  Default is 'Converted'.
            %       Use 'Raw' to see the data before conversions are applied, as defined in the TLM definition.
            %
            % Outputs:
            %   - tlm: array of cells that contains the resulting columns of
            %   data.  The indexes of these correspond with the tlm_names
            %   array.
            %   - tlm_names: array of the names of each column of data.
            %
            % Examples:
            %   item_defs = {'INST.ADCS.POSX','INST.ADCS.POSY'}
            %   start = '29/2/2022 00:00:00.000'
            %   stop = '31/2/2022 15:51:40.000'

            if obj.MODE ~= 0
                error('Invlaid MODE .');
            end
            if nargin < 5
                options = struct('itemMode', 'Converted');
            end

            startTime = datetime(start,'InputFormat','dd/MM/yyyy HH:mm:ss.SSS');
            startEpoch = convertTo(startTime,'posixtime');
            startValue = startEpoch * 1000000000;

            stopTime = datetime(stop,'InputFormat','dd/MM/yyyy HH:mm:ss.SSS');
            stopEpoch = convertTo(stopTime,'posixtime');
            stopValue = stopEpoch * 1000000000;

            tlm_names = cell(1,length(item_defs));
            tlm = cell(1);

            for i = 1 : numel(item_defs)
                pieces = strsplit(item_defs{i},'.');
                target = pieces{1};
                packet = pieces{2};               
                item = pieces{3};
                arg = strcat(target,'__',packet,'__',item);
                if strcmp(options.itemMode, 'Raw')
                    arg = strcat(arg,'__','RAW');
                else
                    arg = strcat(arg,'__','CONVERTED');
                end
                tlm_names{i} = arg;
            end

            obj.MODE = 2;
            sId = struct('channel','StreamingChannel','scope',obj.SCOPE,'token',obj.AUTH);
            sSubscribe = struct('command','subscribe','identifier',jsonencode(sId));
            obj.send(jsonencode(sSubscribe));
            sData = struct('scope',obj.SCOPE,'mode','DECOM','token',obj.AUTH,'items',tlm_names,'start_time',startValue,'end_time',stopValue,'action','add');
            sCommand = struct('command','message','identifier',jsonencode(sId),'data',jsonencode(sData));
            obj.send(jsonencode(sCommand));

            waitfor(obj,'MODE',-2);

            sUnsubscribe = struct('command','unsubscribe','identifier',jsonencode(sId));
            obj.send(jsonencode(sSubscribe));

            tlm = obj.DATA;
            obj.MODE = 0;
            obj.DATA = cell(1);
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
            mStruct = jsondecode(message);
            if isfield(mStruct, 'type') && isfield(mStruct, 'message')
                messageMode = 0;
            else
                messageMode = obj.MODE;
            end
            switch messageMode
            case 1
                obj.onMessageLogMessage(mStruct);
            case 2
                obj.onMessageDataExtractor(mStruct);
            otherwise
                fprintf('Message received: %s\n', message);
            end
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

    methods (Access = private)
        function onMessageLogMessage(obj,mStruct)
            % -------------------------------------------------------------
            % process log message
            % -------------------------------------------------------------
            %
            % obj.dataExtractor(start, stop, ItemDefs, Options);
            %
            % Inputs:
            %   - mStruct: (struct) message converted from json to struct
            disp(mStruct);
        end

        function onMessageDataExtractor(obj,mStruct)
            % -------------------------------------------------------------
            % process data extractor
            % -------------------------------------------------------------
            %
            % obj.dataExtractor(start, stop, ItemDefs, Options);
            %
            % Inputs:
            %   - mStruct: (struct) message converted from json to struct
            disp(mStruct);
        end
    end
end
