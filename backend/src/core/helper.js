const crypto = require('crypto');

function generateRandomToken(length) {
    return crypto.randomBytes(length).toString('hex');
}

module.exports = { generateRandomToken };