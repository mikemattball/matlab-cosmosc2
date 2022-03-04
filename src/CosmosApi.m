classdef CosmosApi < CosmosApiClient
    %COSMOSAPI allows the user to interact with Cosmos v5 
    %   Detailed explanation goes here
    % https://www.mathworks.com/help/matlab/ref/datestr.html
    % https://www.mathworks.com/help/matlab/json-format.html?s_tid=CRUX_lftnav

    properties
    end

    methods
        function obj = CosmosApi(varargin)
            %Constructor
            obj@CosmosApiClient(varargin{:});
        end

        function resp = status(obj)
            % {
            %   "status": "UP",
            % }
            resp = obj.get('/cosmos-api/internal/status');
        end

        function resp = health(obj)
            % TODO
            resp = obj.get('/cosmos-api/internal/health');
        end

        function s = convertBody(resp)
            % 
            s = jsondecode(convertCharsToStrings(char(resp.Body.Data)));
        end

        function resp = tlm(obj,args)
            % {
            %   "jsonrpc": "2.0",
            %   "method": "tlm",
            %   "params": [args...],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('tlm');
            body.params = args;
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_target(obj,target)
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_target",
            %   "params": ["target"],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_target');
            body.params = {target};
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_target_list(obj)
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_target_list",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body_struct = obj.json_rpc_struct('get_target_list');
            resp = obj.post('/cosmos-api/api',jsonencode(body_struct));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_tlm_packet(obj,target,packet)
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_tlm_packet",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_tlm_packet');
            body.params = {target, packet};
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_tlm_values(obj,items)
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_tlm_values",
            %   "params": [[target_name, packet_name, item_name], ...],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_tlm_values');
            body.params = items;
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_all_commands(obj,target)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_all_commands",
            %   "params": ["target"],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_all_commands');
            body.params = {target};
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_command(obj,target,command)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_command",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_command');
            body.params = {target, command};
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_interface_names(obj)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_interface_names",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_interface_names');
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_all_interface_info(obj)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_all_interface_info",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_all_interface_info');
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = list_configs(obj,tool)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "list_configs",
            %   "params": ["tool"],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('list_configs');
            body.params = {tool};
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = load_config(obj,tool,name)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "load_config",
            %   "params": ["tool", "name"],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            % TODO OR NOT TODO
        end

        function resp = save_config(obj,tool,name,data)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "save_config",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            % TODO OR NOT TODO
        end

        function resp = delete_config(obj,tool,name)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "delete_config",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            % TODO OR NOT TODO
        end

        function resp = get_out_of_limits(obj)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_out_of_limits",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_out_of_limits');
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_overall_limits_state(obj,ignored)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_overall_limits_state",
            %   "params": [ignored...],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_overall_limits_state');
            body.params = ignored;
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = list_settings(obj)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "list_settings",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('list_settings');
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_all_settings(obj) 
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_all_settings",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_all_settings');
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_setting(obj,name)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_setting",
            %   "params": ["name"],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_setting');
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = get_settings(obj,array)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_settings",
            %   "params": [array...],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            body = obj.json_rpc_struct('get_settings');
            body.params = array;
            resp = obj.post('/cosmos-api/api',jsonencode(body));
            if (resp.StatusCode == 200)
                resp.Body.Data = convertCharsToStrings(char(resp.Body.Data));
            end
        end

        function resp = save_setting(obj,name,data)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "save_setting",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            % TODO OR NOT TODO
        end
    end
    
    % Private methods triggered by the callbacks defined above.
    methods (Access = private)
        function s = json_rpc_struct(obj,method,~)
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "method",
            %   "params": [],
            %   "id": 0,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }
            s = struct( ...
                'jsonrpc', '2.0', ...
                'method', method, ...
                'params', [], ...
                'id', obj.ID, ...
                'keyword_params', struct('scope', obj.SCOPE));
        end
    end
end

