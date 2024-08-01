import 'package:flutter/material.dart';

import 'application_handler.dart';
import 'network_connectivity_service.dart';

class ApplicationWrapper extends StatefulWidget {
  final Widget child;
  final ApplicationEventHandler eventHandler;

  const ApplicationWrapper({
    super.key,
    required this.child,
    required this.eventHandler,
  });

  @override
  State<ApplicationWrapper> createState() => _ApplicationWrapperState();
}

class _ApplicationWrapperState extends State<ApplicationWrapper> {
  final NetworkConnectivityService _networkConnectivityService = NetworkConnectivityService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(widget.eventHandler);
    _networkConnectivityService.initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(widget.eventHandler);
    _networkConnectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
