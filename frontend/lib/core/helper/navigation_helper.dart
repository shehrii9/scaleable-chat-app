import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext appContext() => navigatorKey.currentContext!;

pushRoute(Widget page) {
  navigatorKey.currentState!.push(
    MaterialPageRoute(builder: (context) => page),
  );
}

popRoute() {
  navigatorKey.currentState!.pop();
}

pushReplacement(Widget page) {
  navigatorKey.currentState!.pushReplacement(
    MaterialPageRoute(builder: (context) => page),
  );
}
