import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sport_log/database/db_interfaces.dart';
import 'package:sport_log/helpers/id_generation.dart';
import 'package:sport_log/database/table.dart';
import 'package:sport_log/helpers/serialization/json_serialization.dart';
import 'package:sport_log/widgets/app_icons.dart';

part 'metcon.g.dart';

enum MetconType {
  @JsonValue("Amrap")
  amrap,
  @JsonValue("Emom")
  emom,
  @JsonValue("ForTime")
  forTime
}

extension ToIcon on MetconType {
  IconData get icon {
    switch (this) {
      case MetconType.amrap:
        return AppIcons.timeInterval;
      case MetconType.emom:
        return AppIcons.repeat;
      case MetconType.forTime:
        return AppIcons.timer;
    }
  }
}

extension ToDisplayName on MetconType {
  String get displayName {
    switch (this) {
      case MetconType.amrap:
        return "AMRAP";
      case MetconType.emom:
        return "EMOM";
      case MetconType.forTime:
        return "FOR TIME";
    }
  }
}

@JsonSerializable()
class Metcon extends AtomicEntity {
  Metcon({
    required this.id,
    required this.userId,
    required this.name,
    required this.metconType,
    required this.rounds,
    required this.timecap,
    required this.description,
    required this.deleted,
  });

  @override
  @IdConverter()
  Int64 id;
  @OptionalIdConverter()
  Int64? userId;
  String? name;
  MetconType metconType;
  int? rounds;
  @DurationConverter()
  Duration? timecap;
  String? description;
  @override
  bool deleted;

  static const Duration timecapDefaultValue = Duration(minutes: 30);
  static const int roundsDefaultValue = 3;

  Metcon.defaultValue(this.userId)
      : id = randomId(),
        name = "",
        metconType = MetconType.amrap,
        rounds = null,
        timecap = timecapDefaultValue,
        description = null,
        deleted = false;

  factory Metcon.fromJson(Map<String, dynamic> json) => _$MetconFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MetconToJson(this);

  bool validateMetconType() {
    switch (metconType) {
      case MetconType.amrap:
        return validate(rounds == null, 'Metcon: amrap: rounds != null') &&
            validate(timecap != null, 'Metcon: amrap: timecap == null');
      case MetconType.emom:
        return validate(rounds != null, 'Metcon: emom: rounds == null') &&
            validate(timecap != null, 'Metcon: emom: timecap == null');
      case MetconType.forTime:
        return validate(rounds != null, 'Metcon: forTime: rounds == null');
    }
  }

  @override
  bool isValid() {
    return validate(userId != null, 'Metcon: userId == null') &&
        validate(name != null, 'Metcon: name == null') &&
        validate(name!.isNotEmpty, 'Metcon: name is empty') &&
        validate(deleted != true, 'Metcon: deleted == true') &&
        validate(rounds == null || rounds! >= 1, 'Metcon: rounds < 1') &&
        validate(
          timecap == null || timecap! >= const Duration(seconds: 1),
          'Metcon: timecap < 1s',
        ) &&
        validate(validateMetconType(), 'Metcon: metcon type validation failed');
  }
}

class DbMetconSerializer extends DbSerializer<Metcon> {
  @override
  Metcon fromDbRecord(DbRecord r, {String prefix = ''}) {
    return Metcon(
      id: Int64(r[prefix + Columns.id]! as int),
      userId: r[prefix + Columns.userId] == null
          ? null
          : Int64(r[prefix + Columns.userId]! as int),
      name: r[prefix + Columns.name] as String?,
      metconType: MetconType.values[r[prefix + Columns.metconType]! as int],
      rounds: r[prefix + Columns.rounds] as int?,
      timecap: r[prefix + Columns.timecap] == null
          ? null
          : Duration(seconds: r[prefix + Columns.timecap]! as int),
      description: r[prefix + Columns.description] as String?,
      deleted: r[prefix + Columns.deleted]! as int == 1,
    );
  }

  @override
  DbRecord toDbRecord(Metcon o) {
    return {
      Columns.id: o.id.toInt(),
      Columns.userId: o.userId?.toInt(),
      Columns.name: o.name,
      Columns.metconType: o.metconType.index,
      Columns.rounds: o.rounds,
      Columns.timecap: o.timecap?.inSeconds,
      Columns.description: o.description,
      Columns.deleted: o.deleted ? 1 : 0,
    };
  }
}
