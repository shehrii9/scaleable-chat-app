import 'dart:math';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'constants.dart';

class Functions {
  static String generateUniqueKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomValue = Random().nextInt(999999);
    return '$timestamp-$randomValue';
  }

  static String getCorrectedTimeIndex(int time) {
    return time > 9 ? "$time" : "0$time";
  }

  static String generateChannelId(String str1, String str2) {
    if (str1.compareTo(str2) <= 0) {
      return str1 + str2;
    } else {
      return str2 + str1;
    }
  }

  static IO.Socket getSocketClient() {
    return IO.io(
      Urls.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
  }

  static String getInitials(String name) {
    List<String> parts = name.trim().split(' ');

    if (parts.length > 1) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    } else {
      String firstTwoChars = parts[0].substring(0, 2).toUpperCase();
      return firstTwoChars;
    }
  }

  static Color getColorFromName(String name) {
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }

    // Constrain RGB values to the blue and purple range
    final int r = ((hash & 0xFF0000) >> 16) %
        129; // Range [0, 128] for red (higher values will add purple shades)
    final int g = ((hash & 0x00FF00) >> 8) %
        129; // Range [0, 128] for green (higher values will add lighter blue shades)
    final int b = (hash & 0x0000FF) % 128 +
        128; // Range [128, 255] for blue (ensures strong blue component)

    return Color.fromARGB(255, r, g, b);
  }

  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
