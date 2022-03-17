classdef CosmosJsonApi < CosmosApiClient
    %COSMOSAPI allows the user to interact with Cosmos v5 
    %   Detailed explanation goes here
    % https://www.mathworks.com/help/matlab/ref/datestr.html
    % https://www.mathworks.com/help/matlab/json-format.html?s_tid=CRUX_lftnav

    properties
    end

    methods
        function obj = CosmosJsonApi(varargin)
            % -------------------------------------------------------------
            % CosmosJsonApi
            % -------------------------------------------------------------
            %
            % Inputs:
            %   SCHEMA - (String) The SCHEMA must be of the form 'http[s]'.
            %   HOST   - (String) The HOST must be String 'localhost'.
            %   PORT   - (Number) The PORT must be positive number: 2900.
            %   AUTH   - (String) Cosmos Authorization
            %   SCOPE  - (String) The Cosmos Scope defaults to 'DEFAULT'

            obj@CosmosApiClient(varargin{:});
        end

        function resp = status(obj)
            % -------------------------------------------------------------
            % status
            % -------------------------------------------------------------
            %
            % response = api.status();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            resp = obj.get('/cosmos-api/internal/status');
        end

        function resp = health(obj)
            % -------------------------------------------------------------
            % health
            % -------------------------------------------------------------
            %
            % response = api.health();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            resp = obj.get('/cosmos-api/internal/health');
        end

        function resp = metadata(obj)
            % -------------------------------------------------------------
            % metadata
            % -------------------------------------------------------------
            %
            % response = api.metadata();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            resp = obj.get('/cosmos-api/metadata');
        end

        function resp = show_metadata(obj,metadataId)
            % -------------------------------------------------------------
            % show_metadata
            % -------------------------------------------------------------
            %
            % response = api.show_metadata('12345');
            %
            % Inputs:
            %   metadataId - (String) metadata id / start
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            if ~ischar(metadataId)
                error('metadataId must be character arrays or byte arrays!');
            end 
            resp = obj.get(strcat('/cosmos-api/metadata/',metadataId));
        end

        function resp = search_metadata(obj,key,value)
            % -------------------------------------------------------------
            % show_metadata
            % -------------------------------------------------------------
            %
            % response = api.show_metadata('version','12345');
            %
            % Inputs:
            %   key - (String) metadata key
            %   value - (String) metadata value
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            qStruct = struct('key',key,'value',value);
            resp = obj.get('/cosmos-api/metadata/_search',qStruct);
        end

        function resp = get_metadata(obj,name)
            % -------------------------------------------------------------
            % get_metadata
            % -------------------------------------------------------------
            %
            % response = api.get_metadata('INST');
            %
            % Inputs:
            %   key - (String) metadata key
            %   value - (String) metadata value
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            if ~ischar(name)
                error('name must be character arrays or byte arrays!');
            end 
            resp = obj.get(strcat('/cosmos-api/metadata/_get/',name));
        end

        function resp = narrative(obj)
            % -------------------------------------------------------------
            % narrative
            % -------------------------------------------------------------
            %
            % response = api.narrative();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            resp = obj.get('/cosmos-api/narrative');
        end

        function resp = show_narrative(obj,narrativeId)
            % -------------------------------------------------------------
            % show_narrative
            % -------------------------------------------------------------
            %
            % response = api.show_narrative('12345');
            %
            % Inputs:
            %   narrativeId - (String) narrative id / start
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            if ~ischar(narrativeId)
                error('narrativeId must be character arrays or byte arrays!');
            end 
            resp = obj.get(strcat('/cosmos-api/narrative/',narrativeId));
        end

        function resp = search_narrative(obj,q)
            % -------------------------------------------------------------
            % search_narrative
            % -------------------------------------------------------------
            %
            % response = api.search_narrative('12345');
            %
            % Inputs:
            %   q - (String) narrative query string
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %

            if ~ischar(q)
                error('q must be character arrays or byte arrays!');
            end 
            qStruct = struct('q',q);
            resp = obj.get('/cosmos-api/narrative/_search',qStruct);
        end

    end
end

