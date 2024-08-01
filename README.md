# **Chat Application**

Welcome to the **Chat Application**! This project is a real-time chat application featuring a Flutter frontend and a Node.js backend using Socket.IO and Redis. It supports real-time messaging, offline functionality, message replies, and reactions.

## Features

- **Real-Time Messaging:** Communicate instantly with other users.
- **Offline Support:** Messages are queued and delivered when the recipient is online.
- **Message Replies:** Reply directly to specific messages.
- **Message Reactions:** React to messages with emojis.

## Getting Started

### Backend Setup

1. **Install Dependencies:**
   - Ensure you have [Node.js](https://nodejs.org/) installed.

2. **Setup Redis:**
   - Sign up at [Redis Labs](https://app.redislabs.com/) and create a Redis instance.
   - Obtain your Redis credentials (host, port, password).

3. **Configure Redis Client:**
   - Go to `backend/src/core/redis_client.js`.
   - Update the `config` object with your Redis credentials:

     ```javascript
     const config = {
       host: 'your_redis_host',
       port: 'your_redis_port',
       password: 'your_redis_password',
     };
     ```

4. **Run the Backend:**
   - Navigate to the `backend` directory in your terminal.
   - Start the backend server with:

     ```bash
     node index.js
     ```

### Frontend Setup

1. **Install Dependencies:**
   - Ensure you have [Flutter](https://flutter.dev/docs/get-started/install) installed.

2. **Configure API Base URL:**
   - Open the project in [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio).
   - Modify `lib/core/constants.dart` to set the base URL. Replace `HTTP://ipv4:3000` with your machine's IPv4 address (find it using `ipconfig`):

     ```dart
     const String baseUrl = 'http://your_ipv4:3000';
     ```

3. **Run the Flutter App:**
   - Connect a device or start an emulator.
   - Navigate to the project root directory in your terminal.
   - Run the app with:

     ```bash
     flutter run apk
     ```

## Contributing

We welcome contributions! To contribute, please submit a pull request or open an issue for suggestions or bug reports.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For questions or feedback, please reach out to [shaharyarahmad393@gmail.com](mailto:shaharyarahmad393@gmail.com).
