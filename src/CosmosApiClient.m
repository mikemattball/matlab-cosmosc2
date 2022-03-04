classdef CosmosApiClient < handle
    %COSMOSCLIENT CosmosClient is a class that allows MATLAB to start
    %interface with a Cosmos instance and connect to the REST server.
    %

    properties (SetAccess = private)
        ID % The request ID
        URI % The URI of the server
        SCOPE % The Cosmos Scope
        AUTH % Cosmos Authorization
        Secure = false % True if the connection is using WebSocketSecure
    end

    properties (Access = private)
        HttpHeaders = {} % Cell array of additional headers {'key1', 'value1',...}
    end

    methods
        function obj = CosmosApiClient(URI,SCOPE,AUTH,varargin)
            % WebSocketClient Constructor
            % Creates an object to call Cosmos.
            % Arguments: URI, [httpHeaders]
            % The URI must be of the form 'http[s]://cosmos.server.org:2900'.
            obj.ID = 0;
            obj.URI = lower(URI);
            if strfind(obj.URI,'https')
                obj.Secure = true;
            end
            obj.SCOPE = SCOPE;
            obj.AUTH = AUTH;
            % Parse optional arguments
            if nargin == 4
                obj.HttpHeaders = varargin{1};
            end
            % Check headers are valid
            if ~iscellstr(obj.HttpHeaders) || logical(mod(length(obj.HttpHeaders),2))
                error(['Invalid HTTP header format! You must pass a cell array'...
                    'of key/value pairs: {''key1'', ''value1'',...}']);
            end
        end
        
        function response = get(obj,endpoint)
            % Send a message to the server
            if ~ischar(endpoint)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', 'ww');
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.GET;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri);
            obj.ID = obj.ID + 1;
        end
        
        function response = post(obj,endpoint,body)
            % Send a message to the server
            if ~ischar(endpoint)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', 'ww');
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.POST;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header,body);
            response = send(request,uri);
            obj.ID = obj.ID + 1;
        end

        function response = put(obj,endpoint,body)
            % Send a message to the server
            if ~ischar(endpoint)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', 'ww');
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.PUT;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header,body);
            response = send(request,uri);
            obj.ID = obj.ID + 1;
        end

        function response = delete(obj,endpoint)
            % Send a message to the server
            if ~ischar(endpoint)
                error('You can only send character arrays or byte arrays!');
            end
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            authorizationField = matlab.net.http.field.AuthorizationField('Authorization', 'ww');
            header = [acceptField contentTypeField authorizationField];
            method = matlab.net.http.RequestMethod.DELETE;
            uri = matlab.net.URI(strcat(obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri);
            obj.ID = obj.ID + 1;
        end
    end
end