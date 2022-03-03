classdef CosmosApi < CosmosApiClient
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here

    properties
    end

    methods
        function obj = CosmosApi(varargin)
            %Constructor
            obj@CosmosApiClient(varargin{:});
        end

        function status(obj)
            % This function simply displays the message received
            resp = obj.get('/status');
            resp.Body;
        end

        function healthcheck(obj)
            % This function simply displays the message received
            resp = obj.get('/healthcheck');
            resp.Body;
        end

        function healthcheck(obj)
            % This function simply displays the message received
            resp = obj.get('/healthcheck');
            resp.Body;
        end
    end
end

