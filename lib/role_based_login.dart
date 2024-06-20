import 'package:flutter/material.dart';

class RoleBasedRoute extends StatefulWidget {
  final String role;
  final Widget adminRoute;
  final Widget userRoute;

  RoleBasedRoute({
    required this.role,
    required this.adminRoute,
    required this.userRoute,
  });

  @override
  _RoleBasedRouteState createState() => _RoleBasedRouteState();
}

class _RoleBasedRouteState extends State<RoleBasedRoute> {
  @override
  Widget build(BuildContext context) {
    if (widget.role == 'admin') {
      return widget.adminRoute;
    } else {
      return widget.userRoute;
    }
  }
}
