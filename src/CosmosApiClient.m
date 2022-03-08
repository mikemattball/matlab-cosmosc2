classdef CosmosApiClient < handle
    %COSMOSCLIENT CosmosClient is a class that allows MATLAB to start
    %interface with a Cosmos instance and connect to the REST server.
    %
    % https://www.mathworks.com/help/matlab/ref/matlab.net.uri-class.html
    % https://www.mathworks.com/help/matlab/ref/matlab.net.queryparameter-class.html

    properties (SetAccess = private)
        ID % The request ID
        URI % The URI of the server
        SCOPE % The Cosmos Scope
        AUTH % Cosmos Authorization
    end

    methods
        function obj = CosmosApiClient(SCHEMA,HOST,PORT,AUTH,SCOPE,varargin)
            % -------------------------------------------------------------
            % CosmosApiClient Constructor - Api object to call Cosmos.
            % -------------------------------------------------------------
            %
            % Inputs:
            %   SCHEMA - (String) The SCHEMA must be of the form 'http[s]'.
            %   HOST   - (String) The HOST must be String 'localhost'.
            %   PORT   - (Number) The PORT must be positive number: 2900.
            %   AUTH   - (String) Cosmos Authorization
            %   SCOPE  - (String) The Cosmos Scope defaults to 'DEFAULT'

            if ~ischar(SCHEMA) || ~ischar(HOST) || ~isnumeric(PORT)
                error('incorrect input check SCHEMA, HOST, and PORT input');
            end
            obj.AUTH = AUTH;
            obj.ID = 0;
            obj.URI = lower(strcat(SCHEMA,'://',HOST,':',int2str(PORT)));
            if ~exist('SCOPE','var') || ~ischar(SCOPE)
                obj.SCOPE = 'DEFAULT';
            else
                obj.SCOPE = SCOPE;
            end
        end

        function response = json_rpc_post(obj,sBody)
            % -------------------------------------------------------------
            % Send a HTTP POST request to the server for json-rpc
            % -------------------------------------------------------------
            %
            % response = api.json_rpc_post(sBody);
            %
            % Inputs:
            %   sBody - The struct to convert to json and send to Cosmos.
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Example:
            %   sBody = struct('cat', 'meow')
            %   api.json_rpc_post(sBody)

            % check the input is a struct
            if ~exist('sBody','var') && ~isstruct(qStruct)
                error('incorrect input sBody must be a struct!');
            end
            body = jsonencode(sBody)
            applicationJson = matlab.net.http.MediaType('application/json-rpc');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('application/json-rpc');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', obj.AUTH);
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.POST;
            consumer = matlab.net.http.io.JSONConsumer;
            uri = matlab.net.URI(strcat(obj.URI,'/cosmos-api/api'));
            request = matlab.net.http.RequestMessage(method,header,body);
            response = send(request,uri,[],consumer);
            obj.ID = obj.ID + 1;
        end
        
        function response = get(obj,endpoint,qStruct)
            % -------------------------------------------------------------
            % Send a HTTP GET request to Cosmos v5 at any endpoint
            % -------------------------------------------------------------
            % response = api.get(obj,endpoint,qStruct)
            %
            % Inputs:
            %   endpoint - (String) The url endpoint '/cosmos-api/taco'
            %   qStruct  - (struct) query params '?target=taco'
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Example:
            %   qStruct = struct('target', 'taco')
            %   api.get('/cosmos-api/timeline', qStruct)

            if ~ischar(endpoint)
                error('You can only send character arrays or byte arrays!');
            end
            if ~exist('qStruct','var')
                query_params = matlab.net.QueryParameter()
            elseif ~isstruct(qStruct)
                error('incorrect input qStruct must be a struct!');
            else
                query_params = matlab.net.QueryParameter(qStruct)
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', obj.AUTH);
            header = [acceptField authorizationField];
            method = matlab.net.http.RequestMethod.GET;
            consumer = matlab.net.http.io.JSONConsumer;
            uri = matlab.net.URI(strcat(obj.URI,endpoint),query_params);
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri,[],consumer);
        end
        
        function response = post(obj,endpoint,body)
            % -------------------------------------------------------------
            % Send a HTTP POST request to the server
            % -------------------------------------------------------------
            %
            % Inputs:
            %   endpoint - The url endpoint '/cosmos-api/taco'
            %   body - The json body of the request '{"a": "b"}'
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Example:
            %   js = '{"a": "b"}'
            %   api.post('/cosmos-api/timeline', js)

            if ~ischar(endpoint) && ~ischar(body)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('application/json');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', obj.AUTH);
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.POST;
            consumer = matlab.net.http.io.JSONConsumer;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header,body);
            response = send(request,uri,[],consumer);
        end

        function response = put(obj,endpoint,body)
            % -------------------------------------------------------------
            % Send a HTTP PUT request to the server
            % -------------------------------------------------------------
            %
            % Inputs:
            %   endpoint - The url endpoint '/cosmos-api/taco'
            %   body - The json body of the request '{"a": "c"}'
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Example:
            %   js = '{"a": "b"}'
            %   api.put('/cosmos-api/timeline/1234', js)

            if ~ischar(endpoint) && ~ischar(body)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('application/json');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', obj.AUTH);
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.PUT;
            consumer = matlab.net.http.io.JSONConsumer;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header,body);
            response = send(request,uri,[],consumer);
        end

        function response = delete(obj,endpoint)
            % -------------------------------------------------------------
            % Send a HTTP DELETE request to the server
            % -------------------------------------------------------------
            %
            % Inputs:
            %   endpoint - The url endpoint '/cosmos-api/taco'
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Example:
            %   api.delete('/cosmos-api/timeline/1234')

            if ~ischar(endpoint)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', obj.AUTH);
            header = [acceptField authorizationField];
            method = matlab.net.http.RequestMethod.DELETE;
            consumer = matlab.net.http.io.JSONConsumer;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri,[],consumer);
        end
    end
end