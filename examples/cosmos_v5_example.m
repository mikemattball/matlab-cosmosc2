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

item_defs = {'INST.ADCS.POSX','INST.HEALTH_STATUS.TEMP1'};
start = '2022/3/11 10:30:00.000';
stop = '2022/3/11 10:35:00.000';

[tlm, tlm_names] = client.dataExtractor(start, stop, item_defs);

disp(length(tlm));

disp(tlm_names);

client.close()
