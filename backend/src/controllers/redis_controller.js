const { client } = require("../core/redis_client");
const bcrypt = require("bcryptjs");
const { generateRandomToken } = require("../core/helper");


const saveUser = async (req, res) => {
    const user = req.body;
    const { username, password } = user;

    const socketId = req.socketId;

    client.exists(`user:${username}`, async (err, reply) => {
        if (err) {
            console.error('Redis error:', err);
            res.status(500).json({ error: 'Server error' });
            return;
        }

        if (reply === 1) {
            await getUserByUsername(req, res);
        } else {
            try {
                const userId = generateRandomToken(8);
                const hashedPassword = await bcrypt.hash(password, 10);

                const userData = { username, password: hashedPassword, userId, socketId };

                client.set(`user:${username}`, JSON.stringify(userData), (err, reply) => {
                    if (err) {
                        console.error('Redis error:', err);
                        res.status(500).json({ error: 'Server error' });
                        return;
                    }

                    res.json(userData);
                });
            } catch (error) {
                console.error('Error hashing password:', error);
                res.status(500).json({ error: 'Error hashing password' });
            }
        }
    });
};

const updateUser = async (req, res) => {
    const { username } = req.body;
    const socketId = req.socketId;

    try {
        client.get(`user:${username}`, (err, userData) => {
            if (err) {
                console.error('Redis error:', err);
                res.status(500).json({ error: 'Server error' });
                return;
            }

            const user = JSON.parse(userData);
            client.set(`user:${username}`, JSON.stringify({ ...user, socketId }), (err, reply) => {
                if (err) {
                    console.error('Redis error:', err);
                    res.status(500).json({ error: 'Server error' });
                    return;
                }

                res.json({ ...user, socketId });
            });
        });
    } catch (err) {
        res.status(500).send('Error updating user');
    }
};

const getUserByUsername = async (req, res) => {
    const user = req.body;
    const { username } = user;
    const socketId = req.socketId;

    client.get(`user:${username}`, (err, userData) => {
        if (err) {
            console.error('Redis error:', err);
            res.status(500).json({ error: 'Server error' });
            return;
        }

        const user = JSON.parse(userData);
        client.set(`user:${username}`, JSON.stringify({ ...user, "socketId": socketId }), (err, reply) => {
            if (err) {
                console.error('Redis error:', err);
                res.status(500).json({ error: 'Server error' });
                return;
            }

            res.json(user);
        });

    });
}

const getAllUsers = async (req, res) => {
    client.keys('user:*', (err, keys) => {
        if (err) {
            console.error('Redis error:', err);
            res.status(500).json({ error: 'Server error' });
            return;
        }

        if (keys.length === 0) {
            res.json([]);
            return;
        }

        client.mget(keys, (err, usersData) => {
            if (err) {
                console.error('Redis error:', err);
                res.status(500).json({ error: 'Server error' });
                return;
            }

            const users = usersData.map(userData => JSON.parse(userData));
            res.json(users);
        });
    });
};

module.exports = { saveUser, updateUser, getAllUsers, getUserByUsername };