% BallAerospace matlab-cosmosc2
% This would be used in the directory with Matlab files contained in src.

setenv('COSMOS_API_SCHEMA', 'http')
setenv('COSMOS_API_HOST', 'localhost')
setenv('COSMOS_API_PORT', '2900')
setenv('COSMOS_API_PASSWORD', 'password')

api = CosmosJsonApi();

status = api.status();

disp(status);

client = CosmosWebSocket();

item_defs = {'INST.ADCS.POSX','INST.ADCS.POSY'};
start = '3/9/2022 14:00:00.000';
stop = '3/9/2022 14:01:40.000';

[tlm, tlm_names] = client.dataExtractor(start, stop, item_defs);

disp(tlm);

disp(tlm_names);

client.close()
