// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDAOInstance;

  ChannelDao? _channelDAOInstance;

  MessageDao? _messageDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `user` (`id` TEXT NOT NULL, `socketId` TEXT NOT NULL, `username` TEXT NOT NULL, `password` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `channel` (`channelId` TEXT NOT NULL, `userId` TEXT NOT NULL, `lastMessageId` TEXT NOT NULL, PRIMARY KEY (`channelId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `messages` (`key` TEXT NOT NULL, `message` TEXT NOT NULL, `channelId` TEXT NOT NULL, `reaction` TEXT NOT NULL, `from` TEXT NOT NULL, `to` TEXT NOT NULL, `replyMessageKey` TEXT NOT NULL, `replyMessage` TEXT NOT NULL, `timestamp` INTEGER NOT NULL, `unread` INTEGER NOT NULL, `isReply` INTEGER NOT NULL, `type` INTEGER NOT NULL, PRIMARY KEY (`key`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDAO {
    return _userDAOInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ChannelDao get channelDAO {
    return _channelDAOInstance ??= _$ChannelDao(database, changeListener);
  }

  @override
  MessageDao get messageDAO {
    return _messageDAOInstance ??= _$MessageDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userModelInsertionAdapter = InsertionAdapter(
            database,
            'user',
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'socketId': item.socketId,
                  'username': item.username,
                  'password': item.password
                }),
        _userModelUpdateAdapter = UpdateAdapter(
            database,
            'user',
            ['id'],
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'socketId': item.socketId,
                  'username': item.username,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserModel> _userModelInsertionAdapter;

  final UpdateAdapter<UserModel> _userModelUpdateAdapter;

  @override
  Future<UserModel?> getUser() async {
    return _queryAdapter.query('SELECT * FROM user LIMIT 1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as String,
            socketId: row['socketId'] as String,
            username: row['username'] as String,
            password: row['password'] as String));
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    return _queryAdapter.query('SELECT * FROM user WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as String,
            socketId: row['socketId'] as String,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [id]);
  }

  @override
  Future<UserModel?> getUserByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM user WHERE username = ?1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as String,
            socketId: row['socketId'] as String,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [username]);
  }

  @override
  Future<void> insertUser(UserModel model) async {
    await _userModelInsertionAdapter.insert(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(UserModel model) async {
    await _userModelUpdateAdapter.update(model, OnConflictStrategy.abort);
  }
}

class _$ChannelDao extends ChannelDao {
  _$ChannelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _channelModelInsertionAdapter = InsertionAdapter(
            database,
            'channel',
            (ChannelModel item) => <String, Object?>{
                  'channelId': item.channelId,
                  'userId': item.userId,
                  'lastMessageId': item.lastMessageId
                }),
        _channelModelUpdateAdapter = UpdateAdapter(
            database,
            'channel',
            ['channelId'],
            (ChannelModel item) => <String, Object?>{
                  'channelId': item.channelId,
                  'userId': item.userId,
                  'lastMessageId': item.lastMessageId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChannelModel> _channelModelInsertionAdapter;

  final UpdateAdapter<ChannelModel> _channelModelUpdateAdapter;

  @override
  Future<ChannelModel?> getChannelWithId(String channelId) async {
    return _queryAdapter.query('SELECT * FROM channel WHERE channelId = ?1',
        mapper: (Map<String, Object?> row) => ChannelModel(
            channelId: row['channelId'] as String,
            userId: row['userId'] as String,
            lastMessageId: row['lastMessageId'] as String),
        arguments: [channelId]);
  }

  @override
  Future<List<ChannelModel>> getChannels() async {
    return _queryAdapter.queryList('SELECT * FROM channel',
        mapper: (Map<String, Object?> row) => ChannelModel(
            channelId: row['channelId'] as String,
            userId: row['userId'] as String,
            lastMessageId: row['lastMessageId'] as String));
  }

  @override
  Future<void> insertChannel(ChannelModel model) async {
    await _channelModelInsertionAdapter.insert(model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateChannel(ChannelModel model) async {
    await _channelModelUpdateAdapter.update(model, OnConflictStrategy.abort);
  }
}

class _$MessageDao extends MessageDao {
  _$MessageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _messageModelInsertionAdapter = InsertionAdapter(
            database,
            'messages',
            (MessageModel item) => <String, Object?>{
                  'key': item.key,
                  'message': item.message,
                  'channelId': item.channelId,
                  'reaction': item.reaction,
                  'from': item.from,
                  'to': item.to,
                  'replyMessageKey': item.replyMessageKey,
                  'replyMessage': item.replyMessage,
                  'timestamp': item.timestamp,
                  'unread': item.unread,
                  'isReply': item.isReply ? 1 : 0,
                  'type': item.type.index
                }),
        _messageModelUpdateAdapter = UpdateAdapter(
            database,
            'messages',
            ['key'],
            (MessageModel item) => <String, Object?>{
                  'key': item.key,
                  'message': item.message,
                  'channelId': item.channelId,
                  'reaction': item.reaction,
                  'from': item.from,
                  'to': item.to,
                  'replyMessageKey': item.replyMessageKey,
                  'replyMessage': item.replyMessage,
                  'timestamp': item.timestamp,
                  'unread': item.unread,
                  'isReply': item.isReply ? 1 : 0,
                  'type': item.type.index
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MessageModel> _messageModelInsertionAdapter;

  final UpdateAdapter<MessageModel> _messageModelUpdateAdapter;

  @override
  Future<void> markAllAsReadInChannel(String channelId) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE messages SET unread = 1 WHERE channelId = ?1',
        arguments: [channelId]);
  }

  @override
  Future<void> markAsReadById(String key) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE messages SET unread = 1 WHERE key = ?1',
        arguments: [key]);
  }

  @override
  Future<int?> countUnreadMessagesByChannelId(String channelId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM messages WHERE unread = 0 AND channelId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [channelId]);
  }

  @override
  Future<MessageModel?> getMessageById(String key) async {
    final message =
    await database.query('messages', where: 'key = ?', whereArgs: [key]);
    return message.isNotEmpty ? MessageModel.fromJson(message.first) : null;
    // return _queryAdapter.query('SELECT * FROM messages WHERE key = ?1',
    //     mapper: (Map<String, Object?> row) => MessageModel(
    //         key: row['key'] as String,
    //         message: row['message'] as String,
    //         type: MessageType.values[row['type'] as int],
    //         timestamp: row['timestamp'] as int,
    //         from: row['from'] as String,
    //         to: row['to'] as String,
    //         channelId: row['channelId'] as String,
    //         reaction: row['reaction'] as String,
    //         replyMessageKey: row['replyMessageKey'] as String,
    //         replyMessage: row['replyMessage'] as String,
    //         isReply: (row['isReply'] as int) != 0,
    //         unread: row['unread'] as int),
    //     arguments: [key]);
  }

  @override
  Future<List<MessageModel>> getMessages(
    String channelId,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM messages WHERE channelId = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => MessageModel(
            key: row['key'] as String,
            message: row['message'] as String,
            type: MessageType.values[row['type'] as int],
            timestamp: row['timestamp'] as int,
            from: row['from'] as String,
            to: row['to'] as String,
            channelId: row['channelId'] as String,
            reaction: row['reaction'] as String,
            replyMessageKey: row['replyMessageKey'] as String,
            replyMessage: row['replyMessage'] as String,
            isReply: (row['isReply'] as int) != 0,
            unread: row['unread'] as int),
        arguments: [channelId, limit, offset]);
  }

  @override
  Future<int?> countMessages(String channelId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM messages WHERE channelId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [channelId]);
  }

  @override
  Future<void> insertMessage(MessageModel model) async {
    await _messageModelInsertionAdapter.insert(
        model, OnConflictStrategy.ignore);
  }

  @override
  Future<void> updateMessage(MessageModel model) async {
    await _messageModelUpdateAdapter.update(model, OnConflictStrategy.abort);
  }
}
