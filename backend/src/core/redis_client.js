const Redis = require('ioredis');

const config = {
    host: "redis-17781.c289.us-west-1-2.ec2.redns.redis-cloud.com",
    port: 17781,
    username: "default",
    password: "IUNFqRvqlN9Vy2kh9byR28frAhyCYeCb",
};

const client = new Redis(config);
client.on('connect', () => console.log("Connected to Redis"));
client.on('error', (err) => console.log("Redis error: ", err));

const pub = new Redis(config);
const sub = new Redis(config);

module.exports = { client, pub, sub }