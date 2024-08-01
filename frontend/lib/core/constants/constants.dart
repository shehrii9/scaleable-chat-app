class Events {
  static const message = "message";
  static const unread = "unread";
  static const login = "login";
  static const update = "update";
  static const reaction = "reaction";
}

class Urls {
  static const baseUrl = "http://10.0.2.2:3000";
  static const getAllUsers = "$baseUrl/api/users/all";
  static const saveUser = "$baseUrl/api/users/create";
  static const updateUser = "$baseUrl/api/users/update";
  static const getUser = "$baseUrl/api/users/";
}

class Constants {
  static const userRef = "user";
}

enum MessageType { text, textReply }
