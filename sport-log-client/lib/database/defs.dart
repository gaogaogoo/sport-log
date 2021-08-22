
import 'package:fixnum/fixnum.dart';
import 'package:result_type/result_type.dart';
import 'package:sport_log/helpers/update_validatable.dart';

typedef DbRecord = Map<String, Object?>;

enum DbError {
  unknown,
  validationFailed,
}

abstract class DbObject extends Validatable {
  Int64 get id;
  bool get deleted;
}

abstract class DbSerializer<T> {
  DbRecord toDbRecord(T o);
  T fromDbRecord(DbRecord r);
}

typedef DbResult<T> = Future<Result<T, DbError>>;

abstract class Keys {
  static const id = 'id';
  static const userId = 'user_id';
  static const deleted = 'deleted';
  static const name = 'name';
  static const description = 'description';
  static const password = 'password';
  static const movementId = 'movement_id';
  static const metconId = 'metcon_id';
  static const actionProviderId = 'action_provider_id';
  static const createBefore = 'created_before';
  static const deleteAfter = 'deleted_after';
  static const actionId = 'action_id';
  static const datetime = 'datetime';
  static const enabled = 'enabled';
  static const platformId = 'platform_id';
  static const weekday = 'weekday';
  static const time = 'time';
  static const cardioType = 'cardio_type';
  static const distance = 'distance';
  static const ascent = 'ascent';
  static const descent = 'descent';
  static const calories = 'calories';
  static const track = 'track';
  static const avgCadence = 'avg_cadence';
  static const cadence = 'cadence';
  static const avgHeartRate = 'avg_heart_rate';
  static const heartRate = 'heart_rate';
  static const routeId = 'route_id';
  static const comments = 'comments';
  static const date = 'date';
  static const bodyweight = 'bodyweight';
  static const metconType = 'metcon_type';
  static const rounds = 'rounds';
  static const timecap = 'timecap';
  static const movementNumber = 'movement_number';
  static const weight = 'weight';
  static const count = 'count';
  static const reps = 'reps';
  static const rx = 'rx';
  static const category = 'category';
  static const username = 'username';
  static const movementUnit = 'movement_unit';
  static const interval = 'interval';
  static const strengthSessionId = 'strength_session_id';
  static const setNumber = 'set_number';
  static const isNew = 'is_new';
  static const arguments = 'arguments';
}