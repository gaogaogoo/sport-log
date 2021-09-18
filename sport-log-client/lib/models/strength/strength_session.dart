import 'package:fixnum/fixnum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sport_log/database/defs.dart';
import 'package:sport_log/database/keys.dart';
import 'package:sport_log/helpers/serialization/json_serialization.dart';
import 'package:sport_log/models/movement/movement.dart';

part 'strength_session.g.dart';

@JsonSerializable()
class StrengthSession implements DbObjectWithDateTime {
  StrengthSession({
    required this.id,
    required this.userId,
    required this.datetime,
    required this.movementId,
    required this.movementUnit,
    required this.interval,
    required this.comments,
    required this.deleted,
  });

  @override
  @IdConverter()
  Int64 id;
  @IdConverter()
  Int64 userId;
  @override
  @DateTimeConverter()
  DateTime datetime;
  @IdConverter()
  Int64 movementId;
  MovementUnit movementUnit;
  int? interval;
  String? comments;
  @override
  bool deleted;

  factory StrengthSession.fromJson(Map<String, dynamic> json) =>
      _$StrengthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$StrengthSessionToJson(this);

  @override
  bool isValid() {
    return validate(!deleted, 'StrengthSession: deleted is true') &&
        validate(interval == null || interval! > 0,
            'StrengthSession: interval <= 0');
  }
}

class DbStrengthSessionSerializer implements DbSerializer<StrengthSession> {
  @override
  StrengthSession fromDbRecord(DbRecord r, {String prefix = ''}) {
    return StrengthSession(
      id: Int64(r[prefix + Keys.id]! as int),
      userId: Int64(r[prefix + Keys.userId]! as int),
      datetime: DateTime.parse(r[prefix + Keys.datetime]! as String),
      movementId: Int64(r[prefix + Keys.movementId]! as int),
      movementUnit: MovementUnit.values[r[prefix + Keys.movementUnit]! as int],
      interval: r[prefix + Keys.interval] as int?,
      comments: r[prefix + Keys.comments] as String?,
      deleted: r[prefix + Keys.deleted]! as int == 1,
    );
  }

  @override
  DbRecord toDbRecord(StrengthSession o) {
    return {
      Keys.id: o.id.toInt(),
      Keys.userId: o.userId.toInt(),
      Keys.datetime: o.datetime.toString(),
      Keys.movementId: o.movementId.toInt(),
      Keys.movementUnit: o.movementUnit.index,
      Keys.interval: o.interval,
      Keys.comments: o.comments,
      Keys.deleted: o.deleted ? 1 : 0,
    };
  }
}
