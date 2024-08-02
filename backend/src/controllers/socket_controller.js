const { pub, sub, client } = require('../core/redis_client');

class SocketController {
    _socket;
    constructor(io) {
        this._io = io;
        sub.subscribe("MESSAGES");
    }

    get io() {
        return this._io;
    }

    get socket() {
        return this._socket;
    }

    init() {
        const io = this.io;
        io.on('connection', this.connect);
        sub.on('message', async (channel, message) => {
            if (channel === 'MESSAGES') {
                const unescapedJsonString = JSON.parse(message);
                try {
                    const { from, to } = JSON.parse(unescapedJsonString);

                    var fromUserData = await client.get(`user:${from}`);
                    var toUserData = await client.get(`user:${to}`);

                    const { socketId } = JSON.parse(toUserData);
                    const isConnected = io.sockets.sockets.has(socketId);
                    const data = {
                        ...JSON.parse(unescapedJsonString),
                        "from": JSON.parse(fromUserData),
                    };
                    console.log(socketId);
                    if (isConnected) {
                        io.to(socketId).emit('message', data);
                    } else {
                        client.lpush(`unread:${to}`, JSON.stringify(data));
                    }
                } catch (error) {
                    console.log(error);
                    io.emit('message', unescapedJsonString);
                }
            }
        });
    }

    connect = async (socket) => {
        this._socket = socket;
        console.log(`a user connected with socket id: ${socket.id}`);
        socket.on('message', (data) => this.onMessage(socket, data));
        socket.on('update', (username) => this.onUpdate(socket, username));
    };

    onUpdate = async (socket, username) => {
        client.get(`user:${username}`, (err, userData) => {
            if (err) {
                console.error('Redis error:', err);
                return;
            }

            const user = JSON.parse(userData);
            client.set(`user:${username}`, JSON.stringify({ ...user, "socketId": socket.id }));

            client.lrange(`unread:${username}`, 0, -1, async (err, list) => {
                if (err) {
                    console.error(err);
                    return;
                }
                client.del(`unread:${username}`);
                this.io.to(socket.id).emit('unread', list);
            });
        });
    };

    onMessage = async (socket, data) => {
        await pub.publish('MESSAGES', JSON.stringify(data));
    };

}

module.exports = SocketController;