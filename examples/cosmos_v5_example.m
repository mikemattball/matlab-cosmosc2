
% TODO

api = CosmosJsonApi('http','localhost',2900,'www');

api.status();

client = CosmosWebSocket('ws','localhost',2900,'/cosmos-api/cable','www');

client.close()