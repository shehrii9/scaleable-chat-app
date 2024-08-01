const Redis = require('ioredis');

const config = {
    host: "",
    port: 0,
    username: "default",
    password: "",
};

const client = new Redis(config);
client.on('connect', () => console.log("Connected to Redis"));
client.on('error', (err) => console.log("Redis error: ", err));

const pub = new Redis(config);
const sub = new Redis(config);

module.exports = { client, pub, sub }