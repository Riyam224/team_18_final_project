import 'package:team_18_final_project/core/error/failures.dart';

/// Base class for storage-related failures
abstract class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Storage read failure
class StorageReadFailure extends StorageFailure {
  const StorageReadFailure({
    super.message = 'Failed to read from secure storage.',
    super.code = 'storage-read-failed',
    super.details,
  });
}

/// Storage write failure
class StorageWriteFailure extends StorageFailure {
  const StorageWriteFailure({
    super.message = 'Failed to write to secure storage.',
    super.code = 'storage-write-failed',
    super.details,
  });
}

/// Storage delete failure
class StorageDeleteFailure extends StorageFailure {
  const StorageDeleteFailure({
    super.message = 'Failed to delete from secure storage.',
    super.code = 'storage-delete-failed',
    super.details,
  });
}

/// Storage not available failure
class StorageNotAvailableFailure extends StorageFailure {
  const StorageNotAvailableFailure({
    super.message = 'Secure storage is not available.',
    super.code = 'storage-not-available',
    super.details,
  });
}

/// Data not found in storage failure
class DataNotFoundFailure extends StorageFailure {
  const DataNotFoundFailure({
    super.message = 'Data not found in storage.',
    super.code = 'data-not-found',
    super.details,
  });
}
