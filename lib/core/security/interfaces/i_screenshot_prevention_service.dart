import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';

/// Interface for screenshot prevention operations
abstract class IScreenshotPreventionService {
  /// Enables screenshot prevention
  Future<Either<Failure, void>> enable();

  /// Disables screenshot prevention
  Future<Either<Failure, void>> disable();

  /// Checks if screenshot prevention is currently enabled
  Future<Either<Failure, bool>> isEnabled();

  /// Enables screenshot prevention for a specific route
  Future<Either<Failure, void>> enableForRoute(String route);

  /// Disables screenshot prevention for a specific route
  Future<Either<Failure, void>> disableForRoute(String route);

  /// Checks if a route is protected
  Future<Either<Failure, bool>> isRouteProtected(String route);
}
