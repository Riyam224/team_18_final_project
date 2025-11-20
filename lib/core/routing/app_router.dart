import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_18_final_project/core/routing/routes.dart';

class RouteGenerator {
  static GoRouter mainRoutingInOurApp = GoRouter(
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),
    // todo initial route
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const Scaffold(),
      ),
    ],
  );
}
