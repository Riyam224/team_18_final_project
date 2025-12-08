import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';

/// Interface for app blur/privacy screen operations
abstract class IBlurService {
  /// Enables blur overlay when app goes to background
  /// This prevents sensitive information from appearing in app switcher
  Future<Either<Failure, void>> enableBlur();

  /// Disables blur overlay
  Future<Either<Failure, void>> disableBlur();

  /// Checks if blur is currently enabled
  Future<Either<Failure, bool>> isBlurEnabled();

  /// Shows blur overlay immediately
  Future<Either<Failure, void>> showBlur();

  /// Hides blur overlay
  Future<Either<Failure, void>> hideBlur();

  /// Stream of blur state changes
  Stream<bool> get blurStateStream;
}
