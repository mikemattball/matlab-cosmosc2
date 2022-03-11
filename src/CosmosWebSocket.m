classdef CosmosWebSocket < CosmosWebSocketClient
    %CosmosWebSocket A wrapper for the CosmosWebSocketClient
    %   I have no idea what I am doing writting this.
    %   MODES
    %     0 - checkStatus
    %     1 - connectionWelcome
    %     2 - logMessages
    %     3 - subscribeDataExtractor
    %     4 - activeDataExtractor

    properties
        TimeZone % The TimeZone to convert
    end

    properties (SetAccess = private)
        MODE % Used with processing data
    end

    properties (Access = private)
        SCOPE % The Cosmos Scope
        AUTH % Cosmos Authorization
        DATA % Used to store data
        META % Used to store metadata
        STOP_COUNT % Used to catch empty data
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
            obj.TimeZone = 'local';
            obj.AUTH = AUTH;
            obj.SCOPE = SCOPE;
            obj.MODE = 1;
            obj.DATA = {};
            obj.META = struct;
            obj.STOP_COUNT = 0;
        end

        function shutdown(obj)
            % -------------------------------------------------------------
            % Reset MODE for client
            % -------------------------------------------------------------
            %
            % obj.shutdown();
            %
            % Inputs:
            %
            % Outputs:
            %

            obj.close()
            obj.MODE = 0;
            obj.DATA = {};
            obj.META = struct;
            obj.STOP_COUNT = 0;
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

            if ~obj.Status
                error('WebSocket is disconnected.');
            end
            if ~isnumeric(history_count)
                error('Invlaid history_count value must be numeric.');
            end

            fprintf('Checking MODE %d\n',obj.MODE);
            waitfor(obj,'MODE',1);

            messages = {};

            obj.MODE = 2;
            sId = struct('channel','MessagesChannel','scope',obj.SCOPE,'token',obj.AUTH,'history_count',history_count);
            sSubscribe = struct('command','subscribe','identifier',jsonencode(sId));
            disp(jsonencode(sSubscribe));
            % DEBUG obj.send(jsonencode(sSubscribe));

            waitfor(obj,'MODE',-2);

            messages = obj.DATA;
            obj.MODE = 1;
            obj.DATA = {};
            obj.META = struct;
        end

        function [tlm, tlm_names] = dataExtractor(obj,start,stop,item_defs,options)
            % -------------------------------------------------------------
            % Get data from cosmos.
            % -------------------------------------------------------------
            %
            % [tlm, tlm_names] = obj.dataExtractor(start, stop, ItemDefs, Options);
            %
            % Inputs:
            %    - start: The start date for the data selection.  In format 'yyyy/MM/dd HH:mm:SS:SS3'
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

            if ~obj.Status
                error('WebSocket is disconnected.');
            end
            if nargin < 5
                options = struct('itemMode', 'Converted');
            end

            startTime = datetime(start,'InputFormat','yyyy/MM/dd HH:mm:ss.SSS','TimeZone',obj.TimeZone);
            startEpoch = convertTo(startTime,'posixtime');
            startValue = startEpoch * 1000000000;

            stopTime = datetime(stop,'InputFormat','yyyy/MM/dd HH:mm:ss.SSS','TimeZone',obj.TimeZone);
            stopEpoch = convertTo(stopTime,'posixtime');
            stopValue = stopEpoch * 1000000000;

            tlm_names = cell(1,length(item_defs));
            tlm_items = cell(length(item_defs),1);

            for i = 1 : numel(item_defs)
                pieces = strsplit(item_defs{i},'.');
                target = pieces{1};
                packet = pieces{2};               
                item = pieces{3};
                arg = strcat('TLM__',target,'__',packet,'__',item);
                if strcmp(options.itemMode, 'Raw')
                    arg = strcat(arg,'__','RAW');
                else
                    arg = strcat(arg,'__','CONVERTED');
                end
                tlm_items{i} = arg;
                tlm_names{1,i} = item_defs{i};
                obj.META.(arg) = struct('row',1,'col',i);
                obj.STOP_COUNT = obj.STOP_COUNT + 1;
            end

            fprintf('Checking MODE %d\n',obj.MODE);
            waitfor(obj,'MODE',1);

            obj.MODE = 3;
            sId = struct('channel','StreamingChannel','scope',obj.SCOPE,'token',obj.AUTH);
            sSubscribe = struct('command','subscribe','identifier',jsonencode(sId));
            obj.send(jsonencode(sSubscribe));

            waitfor(obj,'MODE',-3);

            fprintf('Requesting %d items\n',length(tlm_names));
            obj.MODE = 4;
            sData = struct('scope',obj.SCOPE,'mode','DECOM','token',obj.AUTH,'action','add');
            sData.items = tlm_items;
            sData.start_time = uint64(startValue);
            sData.end_time = uint64(stopValue);
            sCommand = struct('command','message','identifier',jsonencode(sId),'data',jsonencode(sData));
            obj.send(jsonencode(sCommand));

            fprintf('Waiting on data...\n');
            waitfor(obj,'MODE',-4);

            sUnsubscribe = struct('command','unsubscribe','identifier',jsonencode(sId));
            obj.send(jsonencode(sSubscribe));

            tlm = obj.DATA;
            obj.MODE = 1;
            obj.DATA = {};
            obj.META = struct;
        end
    end

    methods (Access = protected)
        function onOpen(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end

        function onTextMessage(obj, message)
            % This function simply displays the message received
            % fprintf('Message received: %d\n',length(message));
            % fprintf('%s\n',message);
            messageMode = obj.MODE;
            mStruct = jsondecode(message);
            if isfield(mStruct, 'type') && isfield(mStruct, 'message')
                messageMode = 0;
            end
            switch messageMode
            case 2
                obj.onMessageLogMessage(message,mStruct);
            case 3
                obj.onSubscribeDataExtractor(message,mStruct);
            case 4
                obj.onMessageDataExtractor(message,mStruct);
            otherwise
                obj.onMessageOther(message,mStruct);
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
    end % methods

    methods (Access = private)
        function dt = convertPosix64(obj,time)
            % -------------------------------------------------------------
            % convert 64bit time into datetime
            % -------------------------------------------------------------
            %
            % obj.convertPosix64(time);
            %
            % Inputs:
            %   - time: (int) posic time value 64bit ie: 1647019802041785856
            %
            % Outputs:
            %   - dt: (datetime) Matlab datetime object

            t_ne = uint64(time);
            NS = 1e9;
            right_over = mod(t_ne, NS);
            left_over = t_ne - right_over;
            dt = datetime( double(left_over)/NS, 'convertfrom', 'posixtime', 'Format', 'dd-MMM-uuuu HH:mm:ss.SSSSSSSSS') + seconds(double(right_over)/NS);
        end

        function onMessageOther(obj,message,mStruct)
            % -------------------------------------------------------------
            % process welcome message MODE 0
            % -------------------------------------------------------------
            %
            % obj.onMessageOther(message,mStruct);
            %
            % Inputs:
            %   - message: (string) json message
            %   - mStruct: (struct) message converted from json to struct

            if isfield(mStruct, 'type') && strcmp(mStruct.type,'welcome')
                obj.MODE = 1;
                % fprintf('Updated MODE: %d\n',obj.MODE);
            end
            fprintf('Message received: %s\n', message);
        end

        function onMessageLogMessage(obj,message,mStruct)
            % -------------------------------------------------------------
            % process log message MODE 2
            % -------------------------------------------------------------
            %
            % obj.onMessageLogMessage(message,mStruct);
            %
            % Inputs:
            %   - message: (string) json message
            %   - mStruct: (struct) message converted from json to struct

            disp(mStruct);
        end

        function onSubscribeDataExtractor(obj,message,mStruct)
            % -------------------------------------------------------------
            % process data extractor subscribe message MODE 3
            % -------------------------------------------------------------
            %
            % obj.onSubscribeDataExtractor(message,mStruct);
            %
            % Inputs:
            %   - message: (string) json message
            %   - mStruct: (struct) message converted from json to struct

            if isfield(mStruct, 'type') && strcmp(mStruct.type,'confirm_subscription')
                obj.MODE = -3;
                % fprintf('Updated MODE: %d\n',obj.MODE);
            end
        end

        function onMessageDataExtractor(obj,message,mStruct)
            % -------------------------------------------------------------
            % process data extractor MODE 4
            % -------------------------------------------------------------
            %
            % obj.onMessageDataExtractor(message,mStruct);
            %
            % Inputs:
            %   - message: (string) json message
            %   - mStruct: (struct) message converted from json to struct

            sMessage = jsondecode(mStruct.message);
            if isempty(sMessage)
                obj.STOP_COUNT = obj.STOP_COUNT - 1;
                if obj.STOP_COUNT == 0
                    obj.MODE = -4;
                    % fprintf('Updated MODE: %d COUNT: %d\n',obj.MODE,length(obj.DATA));
                end
                return
            end
            for i = 1 : numel(sMessage)
                packet_info = sMessage(i);
                dt = obj.convertPosix64(packet_info.time);
                packet_info = rmfield(packet_info,'time');
                values = fieldnames(packet_info);
                for i=1: numel(values)
                    rowIndex = obj.META.(values{i}).row;
                    colIndex = obj.META.(values{i}).col;
                    obj.DATA{rowIndex,colIndex} = struct('time',dt,'value',packet_info.(values{i}));
                    obj.META.(values{i}).row = obj.META.(values{i}).row + 1;
                end
            end
        end
    end % methods
end
