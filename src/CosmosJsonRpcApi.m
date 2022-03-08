classdef CosmosJsonRpcApi < CosmosApiClient
    %COSMOSJSONRPCAPI allows the user to interact with Cosmos v5 
    %   /api uses json_rpc to send data from the 
    % https://www.mathworks.com/help/matlab/ref/datestr.html
    % https://www.mathworks.com/help/matlab/json-format.html?s_tid=CRUX_lftnav

    properties
    end

    methods
        function obj = CosmosJsonRpcApi(varargin)
            % -------------------------------------------------------------
            % CosmosJsonRpcApi
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

        function response = tlm(obj,args)
            % -------------------------------------------------------------
            % tlm
            % -------------------------------------------------------------
            %
            % response = api.tlm(args);
            %
            % Inputs:
            %   args - (Array) tlm arguments
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0",
            %   "method": "tlm",
            %   "params": [args...],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('tlm');
            body.params = args;
            response = obj.json_rpc_post(body);
        end

        function response = get_target(obj,target)
            % -------------------------------------------------------------
            % get_target
            % -------------------------------------------------------------
            %
            % response = api.get_target('INST');
            %
            % Inputs:
            %   target - (String) Target Name
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_target",
            %   "params": ["target"],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_target');
            body.params = {target};
            response = obj.json_rpc_post(body);
        end

        function response = get_target_list(obj)
            % -------------------------------------------------------------
            % get_target_list
            % -------------------------------------------------------------
            %
            % response = api.get_target_list();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_target_list",
            %   "params": [],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body_struct = obj.json_rpc_struct('get_target_list');
            response = obj.json_rpc_post(jsonencode(body_struct));
        end

        function response = get_tlm_packet(obj,target,packet)
            % -------------------------------------------------------------
            % get_tlm_packet
            % -------------------------------------------------------------
            %
            % response = api.get_tlm_packet('INST','ADCS');
            %
            % Inputs:
            %   target - (String) Target Name
            %   packet - (String) Packet Name
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_tlm_packet",
            %   "params": ["target","packet"],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_tlm_packet');
            body.params = {target, packet};
            response = obj.json_rpc_post(body);
        end

        function response = get_tlm_values(obj,items)
            % -------------------------------------------------------------
            % get_tlm_values
            % -------------------------------------------------------------
            %
            % response = api.get_tlm_values({{'INST' 'ADCS' 'POSX'}});
            %
            % Inputs:
            %   items - (Array) tlm values array. {{'target' 'pakcet' 'item'}, ...}
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0",
            %   "method": "get_tlm_values",
            %   "params": [[target_name, packet_name, item_name], ...],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_tlm_values');
            body.params = items;
            response = obj.json_rpc_post(body);
        end

        function response = get_all_commands(obj,target)
            % -------------------------------------------------------------
            % get_all_commands
            % -------------------------------------------------------------
            %
            % response = api.get_tlm_values('INST');
            %
            % Inputs:
            %   items - (Array) tlm values array. {{'target' 'pakcet' 'item'}, ...}
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_all_commands",
            %   "params": ["target"],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_all_commands');
            body.params = {target};
            response = obj.json_rpc_post(body);
        end

        function response = get_command(obj,target,command)
            % -------------------------------------------------------------
            % get_command
            % -------------------------------------------------------------
            %
            % response = api.get_command('INST','CLEAR');
            %
            % Inputs:
            %   target - (String) Target Name
            %   command - (String) Command Name
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_command",
            %   "params": ["target","command"],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_command');
            body.params = {target, command};
            response = obj.json_rpc_post(body);
        end

        function response = get_interface_names(obj)
            % -------------------------------------------------------------
            % get_interface_names
            % -------------------------------------------------------------
            %
            % response = api.get_interface_names();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_interface_names",
            %   "params": [],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_interface_names');
            response = obj.json_rpc_post(body);
        end

        function response = get_all_interface_info(obj)
            % -------------------------------------------------------------
            % get_all_interface_info
            % -------------------------------------------------------------
            %
            % response = api.get_all_interface_info();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            %
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_all_interface_info",
            %   "params": [],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_all_interface_info');
            response = obj.json_rpc_post(body);
        end

        function response = list_configs(obj,tool)
            % -------------------------------------------------------------
            % list_configs
            % -------------------------------------------------------------
            %
            % response = api.list_configs('');
            %
            % Inputs:
            %   tool - (String) Tool Name
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "list_configs",
            %   "params": ["tool"],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('list_configs');
            body.params = {tool};
            response = obj.json_rpc_post(body);
        end

        function response = get_out_of_limits(obj)
            % -------------------------------------------------------------
            % get_out_of_limits
            % -------------------------------------------------------------
            %
            % response = api.get_out_of_limits();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_out_of_limits",
            %   "params": [],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_out_of_limits');
            response = obj.json_rpc_post(body);
        end

        function response = get_overall_limits_state(obj,ignored)
            % -------------------------------------------------------------
            % get_overall_limits_state
            % -------------------------------------------------------------
            %
            % response = api.get_overall_limits_state(ignored);
            %
            % Inputs:
            %   ignored - (Array) ignored values.
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_overall_limits_state",
            %   "params": [ignored...],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_overall_limits_state');
            body.params = ignored;
            response = obj.json_rpc_post(body);
        end

        function response = list_settings(obj)
            % -------------------------------------------------------------
            % list_settings
            % -------------------------------------------------------------
            %
            % response = api.list_settings();
            %
            % Inputs:
            %   ignored - (Array) ignored values.
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "list_settings",
            %   "params": [],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('list_settings');
            response = obj.json_rpc_post(body);
        end

        function response = get_all_settings(obj) 
            % -------------------------------------------------------------
            % get_all_settings
            % -------------------------------------------------------------
            %
            % response = api.get_all_settings();
            %
            % Inputs:
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_all_settings",
            %   "params": [],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_all_settings');
            response = obj.json_rpc_post(body);
        end

        function response = get_setting(obj,name)
            % -------------------------------------------------------------
            % get_setting
            % -------------------------------------------------------------
            %
            % response = api.get_setting('version');
            %
            % Inputs:
            %   name - (String) settings name
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_setting",
            %   "params": ["name"],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_setting');
            response = obj.json_rpc_post(body);
        end

        function response = get_settings(obj,array)
            % -------------------------------------------------------------
            % get_settings
            % -------------------------------------------------------------
            %
            % response = api.get_settings({'version'});
            %
            % Inputs:
            %   array - (Array) settings names.
            %
            % Outputs:
            %   response - HTTP response message matlab.net.http.ResponseMessage
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "get_settings",
            %   "params": [array...],
            %   "id": obj.ID,
            %   "keyword_params": {"scope": "DEFAULT"}
            % }

            body = obj.json_rpc_struct('get_settings');
            body.params = array;
            response = obj.json_rpc_post(body);
        end
    end
    
    % Private methods triggered by the callbacks defined above.
    methods (Access = private)
        function s = json_rpc_struct(obj,method,~)
            % -------------------------------------------------------------
            % json_rpc_struct
            % -------------------------------------------------------------
            %
            % body = obj.json_rpc_struct('method');
            %
            % Inputs:
            %   method - (String) method name.
            %
            % Outputs:
            %   response - (struct) json_rpc
            %
            % Request:
            % {
            %   "jsonrpc": "2.0", 
            %   "method": "method",
            %   "params": [],
            %   "id": obj.ID,
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

