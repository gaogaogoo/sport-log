import 'package:result_type/result_type.dart';
import 'package:sport_log/helpers/interfaces.dart';

export 'package:sport_log/helpers/validation.dart';

typedef DbRecord = Map<String, Object?>;

enum DbError {
  unknown,
  validationFailed,
}

enum SyncStatus {
  synchronized,
  updated,
  created,
}

abstract class DbObject implements Validatable, HasId {
  bool get deleted;
  set deleted(bool deleted);
}

abstract class DbObjectWithDateTime implements DbObject, HasDateTime {}

abstract class DbSerializer<T> {
  DbRecord toDbRecord(T o);
  T fromDbRecord(DbRecord r);
}

typedef DbResult<T> = Future<Result<T, DbError>>;

abstract class Keys {
  static const actionId = 'action_id';
  static const actionProviderId = 'action_provider_id';
  static const arguments = 'arguments';
  static const ascent = 'ascent';
  static const avgCadence = 'avg_cadence';
  static const avgHeartRate = 'avg_heart_rate';
  static const bodyweight = 'bodyweight';
  static const cadence = 'cadence';
  static const calories = 'calories';
  static const cardio = 'cardio';
  static const cardioType = 'cardio_type';
  static const comments = 'comments';
  static const count = 'count';
  static const createBefore = 'create_before';
  static const date = 'date';
  static const datetime = 'datetime';
  static const deleteAfter = 'delete_after';
  static const deleted = 'deleted';
  static const descent = 'descent';
  static const description = 'description';
  static const distance = 'distance';
  static const enabled = 'enabled';
  static const heartRate = 'heart_rate';
  static const id = 'id';
  static const interval = 'interval';
  static const lastSync = 'last_sync';
  static const metconId = 'metcon_id';
  static const metconType = 'metcon_type';
  static const movementId = 'movement_id';
  static const movementNumber = 'movement_number';
  static const movementUnit = 'movement_unit';
  static const name = 'name';
  static const password = 'password';
  static const platformId = 'platform_id';
  static const reps = 'reps';
  static const rounds = 'rounds';
  static const routeId = 'route_id';
  static const rx = 'rx';
  static const setNumber = 'set_number';
  static const strengthSessionId = 'strength_session_id';
  static const syncNeeded = 'sync_needed';
  static const syncStatus = 'sync_status';
  static const time = 'time';
  static const timecap = 'timecap';
  static const track = 'track';
  static const userId = 'user_id';
  static const username = 'username';
  static const weekday = 'weekday';
  static const weight = 'weight';
}
