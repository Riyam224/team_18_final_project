import 'package:flutter/material.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _activity(Route<dynamic>? route) {
    if (route is PageRoute) {
      AppLockService.updateActivity();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _activity(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _activity(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _activity(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

final appRouteObserver = AppRouteObserver();
