classdef CosmosApiClient < handle
    %COSMOSCLIENT CosmosClient is a class that allows MATLAB to start
    %interface with a Cosmos instance and connect to the REST server.
    %
    
    methods
        function obj = CosmosApiClient(URI,varargin)
            % WebSocketClient Constructor
            % Creates an object to call Cosmos.
            % Arguments: URI, [httpHeaders]
            % The URI must be of the form 'http[s]://cosmos.server.org:2900'.
            obj.URI = lower(URI);
            if strfind(obj.URI,'https')
                obj.Secure = true;
            end
            % Parse optional arguments
            if nargin == 2
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
            if ~ischar(endpoint) && ~isa(endpoint,'int8') && ~isa(endpoint,'uint8')
                error('You can only send character arrays or byte arrays!');
            end
            obj.ClientObj.send(endpoint);
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            header = [acceptField contentTypeField];
            method = matlab.net.http.RequestMethod.GET;
            uri = matlab.net.URI(sprintf("%s%s",obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri);
        end
        
        function response = post(obj,endpoint,body)
            % Send a message to the server
            if ~ischar(endpoint) && ~isa(endpoint,'int8') && ~isa(endpoint,'uint8')
                error('You can only send character arrays or byte arrays!');
            end
            obj.ClientObj.send(endpoint);
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            header = [acceptField contentTypeField];
            method = matlab.net.http.RequestMethod.POST;
            uri = matlab.net.URI(sprintf("%s%s",obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri,body);
        end

        function response = put(obj,endpoint,body)
            % Send a message to the server
            if ~ischar(endpoint) && ~isa(endpoint,'int8') && ~isa(endpoint,'uint8')
                error('You can only send character arrays or byte arrays!');
            end
            obj.ClientObj.send(endpoint);
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            header = [acceptField contentTypeField];
            method = matlab.net.http.RequestMethod.PUT;
            uri = matlab.net.URI(sprintf("%s%s",obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri,body);
        end

        function response = delete(obj,endpoint)
            % Send a message to the server
            if ~ischar(endpoint) && ~isa(endpoint,'int8') && ~isa(endpoint,'uint8')
                error('You can only send character arrays or byte arrays!');
            end
            obj.ClientObj.send(endpoint);
            applicationJson = matlab.net.http.MediaType('application/json');
            acceptField = matlab.net.http.field.AcceptField(applicationJson);
            contentTypeField = matlab.net.http.field.ContentTypeField('text/plain');
            header = [acceptField contentTypeField];
            method = matlab.net.http.RequestMethod.DELETE;
            uri = matlab.net.URI(sprintf("%s%s",obj.URI,endpoint));
            request = matlab.net.http.RequestMessage(method,header);
            response = send(request,uri);
        end
 
    end
    
end