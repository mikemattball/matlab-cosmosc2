
% TODO
setenv('COSMOS_API_SCHEMA', 'http')
setenv('COSMOS_API_HOST', 'localhost')
setenv('COSMOS_API_PORT', '2900')
setenv('COSMOS_API_PASSWORD', 'www')

api = CosmosJsonApi();

status = api.status();

disp(status);

client = CosmosWebSocket();

client.close()
