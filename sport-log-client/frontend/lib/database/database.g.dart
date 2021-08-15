// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class MetconsCompanion extends UpdateCompanion<Metcon> {
  final Value<Int64> id;
  final Value<Int64?> userId;
  final Value<String?> name;
  final Value<MetconType> metconType;
  final Value<int?> rounds;
  final Value<int?> timecap;
  final Value<String?> description;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const MetconsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.metconType = const Value.absent(),
    this.rounds = const Value.absent(),
    this.timecap = const Value.absent(),
    this.description = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  MetconsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    required MetconType metconType,
    this.rounds = const Value.absent(),
    this.timecap = const Value.absent(),
    this.description = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  }) : metconType = Value(metconType);
  static Insertable<Metcon> custom({
    Expression<Int64>? id,
    Expression<Int64?>? userId,
    Expression<String?>? name,
    Expression<MetconType>? metconType,
    Expression<int?>? rounds,
    Expression<int?>? timecap,
    Expression<String?>? description,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (metconType != null) 'metcon_type': metconType,
      if (rounds != null) 'rounds': rounds,
      if (timecap != null) 'timecap': timecap,
      if (description != null) 'description': description,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  MetconsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64?>? userId,
      Value<String?>? name,
      Value<MetconType>? metconType,
      Value<int?>? rounds,
      Value<int?>? timecap,
      Value<String?>? description,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return MetconsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      metconType: metconType ?? this.metconType,
      rounds: rounds ?? this.rounds,
      timecap: timecap ?? this.timecap,
      description: description ?? this.description,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $MetconsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $MetconsTable.$converter1;
      map['user_id'] = Variable<int?>(converter.mapToSql(userId.value));
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (metconType.present) {
      final converter = $MetconsTable.$converter2;
      map['metcon_type'] = Variable<int>(converter.mapToSql(metconType.value)!);
    }
    if (rounds.present) {
      map['rounds'] = Variable<int?>(rounds.value);
    }
    if (timecap.present) {
      map['timecap'] = Variable<int?>(timecap.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetconsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('metconType: $metconType, ')
          ..write('rounds: $rounds, ')
          ..write('timecap: $timecap, ')
          ..write('description: $description, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $MetconsTable extends Metcons with TableInfo<$MetconsTable, Metcon> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MetconsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($MetconsTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, true,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($MetconsTable.$converter1);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _metconTypeMeta = const VerificationMeta('metconType');
  late final GeneratedColumnWithTypeConverter<MetconType, int?> metconType =
      GeneratedColumn<int?>('metcon_type', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<MetconType>($MetconsTable.$converter2);
  final VerificationMeta _roundsMeta = const VerificationMeta('rounds');
  late final GeneratedColumn<int?> rounds = GeneratedColumn<int?>(
      'rounds', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _timecapMeta = const VerificationMeta('timecap');
  late final GeneratedColumn<int?> timecap = GeneratedColumn<int?>(
      'timecap', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        name,
        metconType,
        rounds,
        timecap,
        description,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'metcons';
  @override
  String get actualTableName => 'metcons';
  @override
  VerificationContext validateIntegrity(Insertable<Metcon> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    context.handle(_metconTypeMeta, const VerificationResult.success());
    if (data.containsKey('rounds')) {
      context.handle(_roundsMeta,
          rounds.isAcceptableOrUnknown(data['rounds']!, _roundsMeta));
    }
    if (data.containsKey('timecap')) {
      context.handle(_timecapMeta,
          timecap.isAcceptableOrUnknown(data['timecap']!, _timecapMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Metcon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Metcon(
      id: $MetconsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $MetconsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      metconType: $MetconsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}metcon_type']))!,
      rounds: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rounds']),
      timecap: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}timecap']),
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $MetconsTable createAlias(String alias) {
    return $MetconsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<MetconType, int> $converter2 =
      const EnumIndexConverter<MetconType>(MetconType.values);
}

class MetconMovementsCompanion extends UpdateCompanion<MetconMovement> {
  final Value<Int64> id;
  final Value<Int64> metconId;
  final Value<Int64> movementId;
  final Value<int> movementNumber;
  final Value<int> count;
  final Value<MovementUnit> unit;
  final Value<double?> weight;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const MetconMovementsCompanion({
    this.id = const Value.absent(),
    this.metconId = const Value.absent(),
    this.movementId = const Value.absent(),
    this.movementNumber = const Value.absent(),
    this.count = const Value.absent(),
    this.unit = const Value.absent(),
    this.weight = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  MetconMovementsCompanion.insert({
    this.id = const Value.absent(),
    required Int64 metconId,
    required Int64 movementId,
    required int movementNumber,
    required int count,
    required MovementUnit unit,
    this.weight = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : metconId = Value(metconId),
        movementId = Value(movementId),
        movementNumber = Value(movementNumber),
        count = Value(count),
        unit = Value(unit);
  static Insertable<MetconMovement> custom({
    Expression<Int64>? id,
    Expression<Int64>? metconId,
    Expression<Int64>? movementId,
    Expression<int>? movementNumber,
    Expression<int>? count,
    Expression<MovementUnit>? unit,
    Expression<double?>? weight,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (metconId != null) 'metcon_id': metconId,
      if (movementId != null) 'movement_id': movementId,
      if (movementNumber != null) 'movement_number': movementNumber,
      if (count != null) 'count': count,
      if (unit != null) 'unit': unit,
      if (weight != null) 'weight': weight,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  MetconMovementsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? metconId,
      Value<Int64>? movementId,
      Value<int>? movementNumber,
      Value<int>? count,
      Value<MovementUnit>? unit,
      Value<double?>? weight,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return MetconMovementsCompanion(
      id: id ?? this.id,
      metconId: metconId ?? this.metconId,
      movementId: movementId ?? this.movementId,
      movementNumber: movementNumber ?? this.movementNumber,
      count: count ?? this.count,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $MetconMovementsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (metconId.present) {
      final converter = $MetconMovementsTable.$converter1;
      map['metcon_id'] = Variable<int>(converter.mapToSql(metconId.value)!);
    }
    if (movementId.present) {
      final converter = $MetconMovementsTable.$converter2;
      map['movement_id'] = Variable<int>(converter.mapToSql(movementId.value)!);
    }
    if (movementNumber.present) {
      map['movement_number'] = Variable<int>(movementNumber.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (unit.present) {
      final converter = $MetconMovementsTable.$converter3;
      map['unit'] = Variable<int>(converter.mapToSql(unit.value)!);
    }
    if (weight.present) {
      map['weight'] = Variable<double?>(weight.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetconMovementsCompanion(')
          ..write('id: $id, ')
          ..write('metconId: $metconId, ')
          ..write('movementId: $movementId, ')
          ..write('movementNumber: $movementNumber, ')
          ..write('count: $count, ')
          ..write('unit: $unit, ')
          ..write('weight: $weight, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $MetconMovementsTable extends MetconMovements
    with TableInfo<$MetconMovementsTable, MetconMovement> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MetconMovementsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($MetconMovementsTable.$converter0);
  final VerificationMeta _metconIdMeta = const VerificationMeta('metconId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> metconId =
      GeneratedColumn<int?>('metcon_id', aliasedName, false,
              typeName: 'INTEGER',
              requiredDuringInsert: true,
              $customConstraints: 'NOT NULL REFERENCES metcons(id)')
          .withConverter<Int64>($MetconMovementsTable.$converter1);
  final VerificationMeta _movementIdMeta = const VerificationMeta('movementId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> movementId =
      GeneratedColumn<int?>('movement_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($MetconMovementsTable.$converter2);
  final VerificationMeta _movementNumberMeta =
      const VerificationMeta('movementNumber');
  late final GeneratedColumn<int?> movementNumber = GeneratedColumn<int?>(
      'movement_number', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _countMeta = const VerificationMeta('count');
  late final GeneratedColumn<int?> count = GeneratedColumn<int?>(
      'count', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _unitMeta = const VerificationMeta('unit');
  late final GeneratedColumnWithTypeConverter<MovementUnit, int?> unit =
      GeneratedColumn<int?>('unit', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<MovementUnit>($MetconMovementsTable.$converter3);
  final VerificationMeta _weightMeta = const VerificationMeta('weight');
  late final GeneratedColumn<double?> weight = GeneratedColumn<double?>(
      'weight', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        metconId,
        movementId,
        movementNumber,
        count,
        unit,
        weight,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'metcon_movements';
  @override
  String get actualTableName => 'metcon_movements';
  @override
  VerificationContext validateIntegrity(Insertable<MetconMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_metconIdMeta, const VerificationResult.success());
    context.handle(_movementIdMeta, const VerificationResult.success());
    if (data.containsKey('movement_number')) {
      context.handle(
          _movementNumberMeta,
          movementNumber.isAcceptableOrUnknown(
              data['movement_number']!, _movementNumberMeta));
    } else if (isInserting) {
      context.missing(_movementNumberMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    context.handle(_unitMeta, const VerificationResult.success());
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetconMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetconMovement(
      id: $MetconMovementsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      metconId: $MetconMovementsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}metcon_id']))!,
      movementId: $MetconMovementsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_id']))!,
      movementNumber: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_number'])!,
      count: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}count'])!,
      unit: $MetconMovementsTable.$converter3.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unit']))!,
      weight: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}weight']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $MetconMovementsTable createAlias(String alias) {
    return $MetconMovementsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter2 = const DbIdConverter();
  static TypeConverter<MovementUnit, int> $converter3 =
      const EnumIndexConverter<MovementUnit>(MovementUnit.values);
}

class MetconSessionsCompanion extends UpdateCompanion<MetconSession> {
  final Value<Int64> id;
  final Value<Int64> userId;
  final Value<Int64> metconId;
  final Value<DateTime> datetime;
  final Value<int?> time;
  final Value<int?> rounds;
  final Value<int?> reps;
  final Value<bool> rx;
  final Value<String?> comments;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const MetconSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.metconId = const Value.absent(),
    this.datetime = const Value.absent(),
    this.time = const Value.absent(),
    this.rounds = const Value.absent(),
    this.reps = const Value.absent(),
    this.rx = const Value.absent(),
    this.comments = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  MetconSessionsCompanion.insert({
    this.id = const Value.absent(),
    required Int64 userId,
    required Int64 metconId,
    required DateTime datetime,
    this.time = const Value.absent(),
    this.rounds = const Value.absent(),
    this.reps = const Value.absent(),
    required bool rx,
    this.comments = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : userId = Value(userId),
        metconId = Value(metconId),
        datetime = Value(datetime),
        rx = Value(rx);
  static Insertable<MetconSession> custom({
    Expression<Int64>? id,
    Expression<Int64>? userId,
    Expression<Int64>? metconId,
    Expression<DateTime>? datetime,
    Expression<int?>? time,
    Expression<int?>? rounds,
    Expression<int?>? reps,
    Expression<bool>? rx,
    Expression<String?>? comments,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (metconId != null) 'metcon_id': metconId,
      if (datetime != null) 'datetime': datetime,
      if (time != null) 'time': time,
      if (rounds != null) 'rounds': rounds,
      if (reps != null) 'reps': reps,
      if (rx != null) 'rx': rx,
      if (comments != null) 'comments': comments,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  MetconSessionsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? userId,
      Value<Int64>? metconId,
      Value<DateTime>? datetime,
      Value<int?>? time,
      Value<int?>? rounds,
      Value<int?>? reps,
      Value<bool>? rx,
      Value<String?>? comments,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return MetconSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      metconId: metconId ?? this.metconId,
      datetime: datetime ?? this.datetime,
      time: time ?? this.time,
      rounds: rounds ?? this.rounds,
      reps: reps ?? this.reps,
      rx: rx ?? this.rx,
      comments: comments ?? this.comments,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $MetconSessionsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $MetconSessionsTable.$converter1;
      map['user_id'] = Variable<int>(converter.mapToSql(userId.value)!);
    }
    if (metconId.present) {
      final converter = $MetconSessionsTable.$converter2;
      map['metcon_id'] = Variable<int>(converter.mapToSql(metconId.value)!);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (time.present) {
      map['time'] = Variable<int?>(time.value);
    }
    if (rounds.present) {
      map['rounds'] = Variable<int?>(rounds.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int?>(reps.value);
    }
    if (rx.present) {
      map['rx'] = Variable<bool>(rx.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String?>(comments.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetconSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('metconId: $metconId, ')
          ..write('datetime: $datetime, ')
          ..write('time: $time, ')
          ..write('rounds: $rounds, ')
          ..write('reps: $reps, ')
          ..write('rx: $rx, ')
          ..write('comments: $comments, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $MetconSessionsTable extends MetconSessions
    with TableInfo<$MetconSessionsTable, MetconSession> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MetconSessionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($MetconSessionsTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($MetconSessionsTable.$converter1);
  final VerificationMeta _metconIdMeta = const VerificationMeta('metconId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> metconId =
      GeneratedColumn<int?>('metcon_id', aliasedName, false,
              typeName: 'INTEGER',
              requiredDuringInsert: true,
              $customConstraints: 'NOT NULL REFERENCES metcons(id)')
          .withConverter<Int64>($MetconSessionsTable.$converter2);
  final VerificationMeta _datetimeMeta = const VerificationMeta('datetime');
  late final GeneratedColumn<DateTime?> datetime = GeneratedColumn<DateTime?>(
      'datetime', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _roundsMeta = const VerificationMeta('rounds');
  late final GeneratedColumn<int?> rounds = GeneratedColumn<int?>(
      'rounds', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _repsMeta = const VerificationMeta('reps');
  late final GeneratedColumn<int?> reps = GeneratedColumn<int?>(
      'reps', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _rxMeta = const VerificationMeta('rx');
  late final GeneratedColumn<bool?> rx = GeneratedColumn<bool?>(
      'rx', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (rx IN (0, 1))');
  final VerificationMeta _commentsMeta = const VerificationMeta('comments');
  late final GeneratedColumn<String?> comments = GeneratedColumn<String?>(
      'comments', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        metconId,
        datetime,
        time,
        rounds,
        reps,
        rx,
        comments,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'metcon_sessions';
  @override
  String get actualTableName => 'metcon_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<MetconSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    context.handle(_metconIdMeta, const VerificationResult.success());
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('rounds')) {
      context.handle(_roundsMeta,
          rounds.isAcceptableOrUnknown(data['rounds']!, _roundsMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    }
    if (data.containsKey('rx')) {
      context.handle(_rxMeta, rx.isAcceptableOrUnknown(data['rx']!, _rxMeta));
    } else if (isInserting) {
      context.missing(_rxMeta);
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetconSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetconSession(
      id: $MetconSessionsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $MetconSessionsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']))!,
      metconId: $MetconSessionsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}metcon_id']))!,
      datetime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}datetime'])!,
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time']),
      rounds: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rounds']),
      reps: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}reps']),
      rx: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}rx'])!,
      comments: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comments']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $MetconSessionsTable createAlias(String alias) {
    return $MetconSessionsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter2 = const DbIdConverter();
}

class MovementsCompanion extends UpdateCompanion<Movement> {
  final Value<Int64> id;
  final Value<Int64?> userId;
  final Value<String> name;
  final Value<String?> description;
  final Value<MovementCategory> category;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const MovementsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  MovementsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required MovementCategory category,
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : name = Value(name),
        category = Value(category);
  static Insertable<Movement> custom({
    Expression<Int64>? id,
    Expression<Int64?>? userId,
    Expression<String>? name,
    Expression<String?>? description,
    Expression<MovementCategory>? category,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  MovementsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64?>? userId,
      Value<String>? name,
      Value<String?>? description,
      Value<MovementCategory>? category,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return MovementsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $MovementsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $MovementsTable.$converter1;
      map['user_id'] = Variable<int?>(converter.mapToSql(userId.value));
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (category.present) {
      final converter = $MovementsTable.$converter2;
      map['category'] = Variable<int>(converter.mapToSql(category.value)!);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovementsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $MovementsTable extends Movements
    with TableInfo<$MovementsTable, Movement> {
  final GeneratedDatabase _db;
  final String? _alias;
  $MovementsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($MovementsTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, true,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($MovementsTable.$converter1);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  late final GeneratedColumnWithTypeConverter<MovementCategory, int?> category =
      GeneratedColumn<int?>('category', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<MovementCategory>($MovementsTable.$converter2);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, name, description, category, deleted, lastModified, isNew];
  @override
  String get aliasedName => _alias ?? 'movements';
  @override
  String get actualTableName => 'movements';
  @override
  VerificationContext validateIntegrity(Insertable<Movement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    context.handle(_categoryMeta, const VerificationResult.success());
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movement(
      id: $MovementsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $MovementsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      category: $MovementsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category']))!,
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $MovementsTable createAlias(String alias) {
    return $MovementsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<MovementCategory, int> $converter2 =
      const EnumIndexConverter<MovementCategory>(MovementCategory.values);
}

class StrengthSessionsCompanion extends UpdateCompanion<StrengthSession> {
  final Value<Int64> id;
  final Value<Int64> userId;
  final Value<DateTime> datetime;
  final Value<Int64> movementId;
  final Value<MovementUnit> movementUnit;
  final Value<int?> interval;
  final Value<String?> comments;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const StrengthSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.datetime = const Value.absent(),
    this.movementId = const Value.absent(),
    this.movementUnit = const Value.absent(),
    this.interval = const Value.absent(),
    this.comments = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  StrengthSessionsCompanion.insert({
    this.id = const Value.absent(),
    required Int64 userId,
    required DateTime datetime,
    required Int64 movementId,
    required MovementUnit movementUnit,
    this.interval = const Value.absent(),
    this.comments = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : userId = Value(userId),
        datetime = Value(datetime),
        movementId = Value(movementId),
        movementUnit = Value(movementUnit);
  static Insertable<StrengthSession> custom({
    Expression<Int64>? id,
    Expression<Int64>? userId,
    Expression<DateTime>? datetime,
    Expression<Int64>? movementId,
    Expression<MovementUnit>? movementUnit,
    Expression<int?>? interval,
    Expression<String?>? comments,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (datetime != null) 'datetime': datetime,
      if (movementId != null) 'movement_id': movementId,
      if (movementUnit != null) 'movement_unit': movementUnit,
      if (interval != null) 'interval': interval,
      if (comments != null) 'comments': comments,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  StrengthSessionsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? userId,
      Value<DateTime>? datetime,
      Value<Int64>? movementId,
      Value<MovementUnit>? movementUnit,
      Value<int?>? interval,
      Value<String?>? comments,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return StrengthSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      datetime: datetime ?? this.datetime,
      movementId: movementId ?? this.movementId,
      movementUnit: movementUnit ?? this.movementUnit,
      interval: interval ?? this.interval,
      comments: comments ?? this.comments,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $StrengthSessionsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $StrengthSessionsTable.$converter1;
      map['user_id'] = Variable<int>(converter.mapToSql(userId.value)!);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (movementId.present) {
      final converter = $StrengthSessionsTable.$converter2;
      map['movement_id'] = Variable<int>(converter.mapToSql(movementId.value)!);
    }
    if (movementUnit.present) {
      final converter = $StrengthSessionsTable.$converter3;
      map['movement_unit'] =
          Variable<int>(converter.mapToSql(movementUnit.value)!);
    }
    if (interval.present) {
      map['interval'] = Variable<int?>(interval.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String?>(comments.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('datetime: $datetime, ')
          ..write('movementId: $movementId, ')
          ..write('movementUnit: $movementUnit, ')
          ..write('interval: $interval, ')
          ..write('comments: $comments, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $StrengthSessionsTable extends StrengthSessions
    with TableInfo<$StrengthSessionsTable, StrengthSession> {
  final GeneratedDatabase _db;
  final String? _alias;
  $StrengthSessionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($StrengthSessionsTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($StrengthSessionsTable.$converter1);
  final VerificationMeta _datetimeMeta = const VerificationMeta('datetime');
  late final GeneratedColumn<DateTime?> datetime = GeneratedColumn<DateTime?>(
      'datetime', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _movementIdMeta = const VerificationMeta('movementId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> movementId =
      GeneratedColumn<int?>('movement_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($StrengthSessionsTable.$converter2);
  final VerificationMeta _movementUnitMeta =
      const VerificationMeta('movementUnit');
  late final GeneratedColumnWithTypeConverter<MovementUnit, int?> movementUnit =
      GeneratedColumn<int?>('movement_unit', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<MovementUnit>($StrengthSessionsTable.$converter3);
  final VerificationMeta _intervalMeta = const VerificationMeta('interval');
  late final GeneratedColumn<int?> interval = GeneratedColumn<int?>(
      'interval', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _commentsMeta = const VerificationMeta('comments');
  late final GeneratedColumn<String?> comments = GeneratedColumn<String?>(
      'comments', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        datetime,
        movementId,
        movementUnit,
        interval,
        comments,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'strength_sessions';
  @override
  String get actualTableName => 'strength_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<StrengthSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    context.handle(_movementIdMeta, const VerificationResult.success());
    context.handle(_movementUnitMeta, const VerificationResult.success());
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthSession(
      id: $StrengthSessionsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $StrengthSessionsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']))!,
      datetime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}datetime'])!,
      movementId: $StrengthSessionsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_id']))!,
      movementUnit: $StrengthSessionsTable.$converter3.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_unit']))!,
      interval: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}interval']),
      comments: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comments']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $StrengthSessionsTable createAlias(String alias) {
    return $StrengthSessionsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter2 = const DbIdConverter();
  static TypeConverter<MovementUnit, int> $converter3 =
      const EnumIndexConverter<MovementUnit>(MovementUnit.values);
}

class StrengthSetsCompanion extends UpdateCompanion<StrengthSet> {
  final Value<Int64> id;
  final Value<Int64> strengthSessionId;
  final Value<int> setNumber;
  final Value<int> count;
  final Value<double?> weight;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const StrengthSetsCompanion({
    this.id = const Value.absent(),
    this.strengthSessionId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.count = const Value.absent(),
    this.weight = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  StrengthSetsCompanion.insert({
    this.id = const Value.absent(),
    required Int64 strengthSessionId,
    required int setNumber,
    required int count,
    this.weight = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : strengthSessionId = Value(strengthSessionId),
        setNumber = Value(setNumber),
        count = Value(count);
  static Insertable<StrengthSet> custom({
    Expression<Int64>? id,
    Expression<Int64>? strengthSessionId,
    Expression<int>? setNumber,
    Expression<int>? count,
    Expression<double?>? weight,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (strengthSessionId != null) 'strength_session_id': strengthSessionId,
      if (setNumber != null) 'set_number': setNumber,
      if (count != null) 'count': count,
      if (weight != null) 'weight': weight,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  StrengthSetsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? strengthSessionId,
      Value<int>? setNumber,
      Value<int>? count,
      Value<double?>? weight,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return StrengthSetsCompanion(
      id: id ?? this.id,
      strengthSessionId: strengthSessionId ?? this.strengthSessionId,
      setNumber: setNumber ?? this.setNumber,
      count: count ?? this.count,
      weight: weight ?? this.weight,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $StrengthSetsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (strengthSessionId.present) {
      final converter = $StrengthSetsTable.$converter1;
      map['strength_session_id'] =
          Variable<int>(converter.mapToSql(strengthSessionId.value)!);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double?>(weight.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSetsCompanion(')
          ..write('id: $id, ')
          ..write('strengthSessionId: $strengthSessionId, ')
          ..write('setNumber: $setNumber, ')
          ..write('count: $count, ')
          ..write('weight: $weight, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $StrengthSetsTable extends StrengthSets
    with TableInfo<$StrengthSetsTable, StrengthSet> {
  final GeneratedDatabase _db;
  final String? _alias;
  $StrengthSetsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($StrengthSetsTable.$converter0);
  final VerificationMeta _strengthSessionIdMeta =
      const VerificationMeta('strengthSessionId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> strengthSessionId =
      GeneratedColumn<int?>('strength_session_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($StrengthSetsTable.$converter1);
  final VerificationMeta _setNumberMeta = const VerificationMeta('setNumber');
  late final GeneratedColumn<int?> setNumber = GeneratedColumn<int?>(
      'set_number', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _countMeta = const VerificationMeta('count');
  late final GeneratedColumn<int?> count = GeneratedColumn<int?>(
      'count', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _weightMeta = const VerificationMeta('weight');
  late final GeneratedColumn<double?> weight = GeneratedColumn<double?>(
      'weight', aliasedName, true,
      typeName: 'REAL', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        strengthSessionId,
        setNumber,
        count,
        weight,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'strength_sets';
  @override
  String get actualTableName => 'strength_sets';
  @override
  VerificationContext validateIntegrity(Insertable<StrengthSet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_strengthSessionIdMeta, const VerificationResult.success());
    if (data.containsKey('set_number')) {
      context.handle(_setNumberMeta,
          setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta));
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthSet(
      id: $StrengthSetsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      strengthSessionId: $StrengthSetsTable.$converter1.mapToDart(
          const IntType().mapFromDatabaseResponse(
              data['${effectivePrefix}strength_session_id']))!,
      setNumber: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}set_number'])!,
      count: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}count'])!,
      weight: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}weight']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $StrengthSetsTable createAlias(String alias) {
    return $StrengthSetsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
}

class CardioSessionsCompanion extends UpdateCompanion<CardioSession> {
  final Value<Int64> id;
  final Value<Int64> userId;
  final Value<Int64> movementId;
  final Value<CardioType> cardioType;
  final Value<DateTime> datetime;
  final Value<int?> distance;
  final Value<int?> ascent;
  final Value<int?> descent;
  final Value<int?> time;
  final Value<int?> calories;
  final Value<List<Position>?> track;
  final Value<int?> avgCycles;
  final Value<List<double>?> cycles;
  final Value<int?> avgHeartRate;
  final Value<List<double>?> heartRate;
  final Value<Int64?> routeId;
  final Value<String?> comments;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const CardioSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.movementId = const Value.absent(),
    this.cardioType = const Value.absent(),
    this.datetime = const Value.absent(),
    this.distance = const Value.absent(),
    this.ascent = const Value.absent(),
    this.descent = const Value.absent(),
    this.time = const Value.absent(),
    this.calories = const Value.absent(),
    this.track = const Value.absent(),
    this.avgCycles = const Value.absent(),
    this.cycles = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.routeId = const Value.absent(),
    this.comments = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  CardioSessionsCompanion.insert({
    this.id = const Value.absent(),
    required Int64 userId,
    required Int64 movementId,
    required CardioType cardioType,
    required DateTime datetime,
    this.distance = const Value.absent(),
    this.ascent = const Value.absent(),
    this.descent = const Value.absent(),
    this.time = const Value.absent(),
    this.calories = const Value.absent(),
    this.track = const Value.absent(),
    this.avgCycles = const Value.absent(),
    this.cycles = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.routeId = const Value.absent(),
    this.comments = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : userId = Value(userId),
        movementId = Value(movementId),
        cardioType = Value(cardioType),
        datetime = Value(datetime);
  static Insertable<CardioSession> custom({
    Expression<Int64>? id,
    Expression<Int64>? userId,
    Expression<Int64>? movementId,
    Expression<CardioType>? cardioType,
    Expression<DateTime>? datetime,
    Expression<int?>? distance,
    Expression<int?>? ascent,
    Expression<int?>? descent,
    Expression<int?>? time,
    Expression<int?>? calories,
    Expression<List<Position>?>? track,
    Expression<int?>? avgCycles,
    Expression<List<double>?>? cycles,
    Expression<int?>? avgHeartRate,
    Expression<List<double>?>? heartRate,
    Expression<Int64?>? routeId,
    Expression<String?>? comments,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (movementId != null) 'movement_id': movementId,
      if (cardioType != null) 'cardio_type': cardioType,
      if (datetime != null) 'datetime': datetime,
      if (distance != null) 'distance': distance,
      if (ascent != null) 'ascent': ascent,
      if (descent != null) 'descent': descent,
      if (time != null) 'time': time,
      if (calories != null) 'calories': calories,
      if (track != null) 'track': track,
      if (avgCycles != null) 'avg_cycles': avgCycles,
      if (cycles != null) 'cycles': cycles,
      if (avgHeartRate != null) 'avg_heart_rate': avgHeartRate,
      if (heartRate != null) 'heart_rate': heartRate,
      if (routeId != null) 'route_id': routeId,
      if (comments != null) 'comments': comments,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  CardioSessionsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? userId,
      Value<Int64>? movementId,
      Value<CardioType>? cardioType,
      Value<DateTime>? datetime,
      Value<int?>? distance,
      Value<int?>? ascent,
      Value<int?>? descent,
      Value<int?>? time,
      Value<int?>? calories,
      Value<List<Position>?>? track,
      Value<int?>? avgCycles,
      Value<List<double>?>? cycles,
      Value<int?>? avgHeartRate,
      Value<List<double>?>? heartRate,
      Value<Int64?>? routeId,
      Value<String?>? comments,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return CardioSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      movementId: movementId ?? this.movementId,
      cardioType: cardioType ?? this.cardioType,
      datetime: datetime ?? this.datetime,
      distance: distance ?? this.distance,
      ascent: ascent ?? this.ascent,
      descent: descent ?? this.descent,
      time: time ?? this.time,
      calories: calories ?? this.calories,
      track: track ?? this.track,
      avgCycles: avgCycles ?? this.avgCycles,
      cycles: cycles ?? this.cycles,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      heartRate: heartRate ?? this.heartRate,
      routeId: routeId ?? this.routeId,
      comments: comments ?? this.comments,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $CardioSessionsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $CardioSessionsTable.$converter1;
      map['user_id'] = Variable<int>(converter.mapToSql(userId.value)!);
    }
    if (movementId.present) {
      final converter = $CardioSessionsTable.$converter2;
      map['movement_id'] = Variable<int>(converter.mapToSql(movementId.value)!);
    }
    if (cardioType.present) {
      final converter = $CardioSessionsTable.$converter3;
      map['cardio_type'] = Variable<int>(converter.mapToSql(cardioType.value)!);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (distance.present) {
      map['distance'] = Variable<int?>(distance.value);
    }
    if (ascent.present) {
      map['ascent'] = Variable<int?>(ascent.value);
    }
    if (descent.present) {
      map['descent'] = Variable<int?>(descent.value);
    }
    if (time.present) {
      map['time'] = Variable<int?>(time.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int?>(calories.value);
    }
    if (track.present) {
      final converter = $CardioSessionsTable.$converter4;
      map['track'] = Variable<Uint8List?>(converter.mapToSql(track.value));
    }
    if (avgCycles.present) {
      map['avg_cycles'] = Variable<int?>(avgCycles.value);
    }
    if (cycles.present) {
      final converter = $CardioSessionsTable.$converter5;
      map['cycles'] = Variable<Uint8List?>(converter.mapToSql(cycles.value));
    }
    if (avgHeartRate.present) {
      map['avg_heart_rate'] = Variable<int?>(avgHeartRate.value);
    }
    if (heartRate.present) {
      final converter = $CardioSessionsTable.$converter6;
      map['heart_rate'] =
          Variable<Uint8List?>(converter.mapToSql(heartRate.value));
    }
    if (routeId.present) {
      final converter = $CardioSessionsTable.$converter7;
      map['route_id'] = Variable<int?>(converter.mapToSql(routeId.value));
    }
    if (comments.present) {
      map['comments'] = Variable<String?>(comments.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardioSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('movementId: $movementId, ')
          ..write('cardioType: $cardioType, ')
          ..write('datetime: $datetime, ')
          ..write('distance: $distance, ')
          ..write('ascent: $ascent, ')
          ..write('descent: $descent, ')
          ..write('time: $time, ')
          ..write('calories: $calories, ')
          ..write('track: $track, ')
          ..write('avgCycles: $avgCycles, ')
          ..write('cycles: $cycles, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('heartRate: $heartRate, ')
          ..write('routeId: $routeId, ')
          ..write('comments: $comments, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $CardioSessionsTable extends CardioSessions
    with TableInfo<$CardioSessionsTable, CardioSession> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CardioSessionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($CardioSessionsTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($CardioSessionsTable.$converter1);
  final VerificationMeta _movementIdMeta = const VerificationMeta('movementId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> movementId =
      GeneratedColumn<int?>('movement_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($CardioSessionsTable.$converter2);
  final VerificationMeta _cardioTypeMeta = const VerificationMeta('cardioType');
  late final GeneratedColumnWithTypeConverter<CardioType, int?> cardioType =
      GeneratedColumn<int?>('cardio_type', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<CardioType>($CardioSessionsTable.$converter3);
  final VerificationMeta _datetimeMeta = const VerificationMeta('datetime');
  late final GeneratedColumn<DateTime?> datetime = GeneratedColumn<DateTime?>(
      'datetime', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _distanceMeta = const VerificationMeta('distance');
  late final GeneratedColumn<int?> distance = GeneratedColumn<int?>(
      'distance', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _ascentMeta = const VerificationMeta('ascent');
  late final GeneratedColumn<int?> ascent = GeneratedColumn<int?>(
      'ascent', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descentMeta = const VerificationMeta('descent');
  late final GeneratedColumn<int?> descent = GeneratedColumn<int?>(
      'descent', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  late final GeneratedColumn<int?> time = GeneratedColumn<int?>(
      'time', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _caloriesMeta = const VerificationMeta('calories');
  late final GeneratedColumn<int?> calories = GeneratedColumn<int?>(
      'calories', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _trackMeta = const VerificationMeta('track');
  late final GeneratedColumnWithTypeConverter<List<Position>, Uint8List?>
      track = GeneratedColumn<Uint8List?>('track', aliasedName, true,
              typeName: 'BLOB', requiredDuringInsert: false)
          .withConverter<List<Position>>($CardioSessionsTable.$converter4);
  final VerificationMeta _avgCyclesMeta = const VerificationMeta('avgCycles');
  late final GeneratedColumn<int?> avgCycles = GeneratedColumn<int?>(
      'avg_cycles', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _cyclesMeta = const VerificationMeta('cycles');
  late final GeneratedColumnWithTypeConverter<List<double>, Uint8List?> cycles =
      GeneratedColumn<Uint8List?>('cycles', aliasedName, true,
              typeName: 'BLOB', requiredDuringInsert: false)
          .withConverter<List<double>>($CardioSessionsTable.$converter5);
  final VerificationMeta _avgHeartRateMeta =
      const VerificationMeta('avgHeartRate');
  late final GeneratedColumn<int?> avgHeartRate = GeneratedColumn<int?>(
      'avg_heart_rate', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _heartRateMeta = const VerificationMeta('heartRate');
  late final GeneratedColumnWithTypeConverter<List<double>, Uint8List?>
      heartRate = GeneratedColumn<Uint8List?>('heart_rate', aliasedName, true,
              typeName: 'BLOB', requiredDuringInsert: false)
          .withConverter<List<double>>($CardioSessionsTable.$converter6);
  final VerificationMeta _routeIdMeta = const VerificationMeta('routeId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> routeId =
      GeneratedColumn<int?>('route_id', aliasedName, true,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($CardioSessionsTable.$converter7);
  final VerificationMeta _commentsMeta = const VerificationMeta('comments');
  late final GeneratedColumn<String?> comments = GeneratedColumn<String?>(
      'comments', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        movementId,
        cardioType,
        datetime,
        distance,
        ascent,
        descent,
        time,
        calories,
        track,
        avgCycles,
        cycles,
        avgHeartRate,
        heartRate,
        routeId,
        comments,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'cardio_sessions';
  @override
  String get actualTableName => 'cardio_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<CardioSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    context.handle(_movementIdMeta, const VerificationResult.success());
    context.handle(_cardioTypeMeta, const VerificationResult.success());
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    }
    if (data.containsKey('ascent')) {
      context.handle(_ascentMeta,
          ascent.isAcceptableOrUnknown(data['ascent']!, _ascentMeta));
    }
    if (data.containsKey('descent')) {
      context.handle(_descentMeta,
          descent.isAcceptableOrUnknown(data['descent']!, _descentMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    context.handle(_trackMeta, const VerificationResult.success());
    if (data.containsKey('avg_cycles')) {
      context.handle(_avgCyclesMeta,
          avgCycles.isAcceptableOrUnknown(data['avg_cycles']!, _avgCyclesMeta));
    }
    context.handle(_cyclesMeta, const VerificationResult.success());
    if (data.containsKey('avg_heart_rate')) {
      context.handle(
          _avgHeartRateMeta,
          avgHeartRate.isAcceptableOrUnknown(
              data['avg_heart_rate']!, _avgHeartRateMeta));
    }
    context.handle(_heartRateMeta, const VerificationResult.success());
    context.handle(_routeIdMeta, const VerificationResult.success());
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardioSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardioSession(
      id: $CardioSessionsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $CardioSessionsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']))!,
      movementId: $CardioSessionsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_id']))!,
      cardioType: $CardioSessionsTable.$converter3.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cardio_type']))!,
      datetime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}datetime'])!,
      distance: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}distance']),
      ascent: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ascent']),
      descent: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descent']),
      time: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}time']),
      calories: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}calories']),
      track: $CardioSessionsTable.$converter4.mapToDart(const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}track'])),
      avgCycles: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}avg_cycles']),
      cycles: $CardioSessionsTable.$converter5.mapToDart(const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cycles'])),
      avgHeartRate: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}avg_heart_rate']),
      heartRate: $CardioSessionsTable.$converter6.mapToDart(const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}heart_rate'])),
      routeId: $CardioSessionsTable.$converter7.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}route_id'])),
      comments: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comments']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $CardioSessionsTable createAlias(String alias) {
    return $CardioSessionsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter2 = const DbIdConverter();
  static TypeConverter<CardioType, int> $converter3 =
      const EnumIndexConverter<CardioType>(CardioType.values);
  static TypeConverter<List<Position>, Uint8List> $converter4 =
      const DbPositionListConverter();
  static TypeConverter<List<double>, Uint8List> $converter5 =
      const DbDoubleListConverter();
  static TypeConverter<List<double>, Uint8List> $converter6 =
      const DbDoubleListConverter();
  static TypeConverter<Int64, int> $converter7 = const DbIdConverter();
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<Int64> id;
  final Value<Int64> userId;
  final Value<String> name;
  final Value<int> distance;
  final Value<int?> ascent;
  final Value<int?> descent;
  final Value<List<Position>?> track;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.distance = const Value.absent(),
    this.ascent = const Value.absent(),
    this.descent = const Value.absent(),
    this.track = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  RoutesCompanion.insert({
    this.id = const Value.absent(),
    required Int64 userId,
    required String name,
    required int distance,
    this.ascent = const Value.absent(),
    this.descent = const Value.absent(),
    this.track = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : userId = Value(userId),
        name = Value(name),
        distance = Value(distance);
  static Insertable<Route> custom({
    Expression<Int64>? id,
    Expression<Int64>? userId,
    Expression<String>? name,
    Expression<int>? distance,
    Expression<int?>? ascent,
    Expression<int?>? descent,
    Expression<List<Position>?>? track,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (distance != null) 'distance': distance,
      if (ascent != null) 'ascent': ascent,
      if (descent != null) 'descent': descent,
      if (track != null) 'track': track,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  RoutesCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? userId,
      Value<String>? name,
      Value<int>? distance,
      Value<int?>? ascent,
      Value<int?>? descent,
      Value<List<Position>?>? track,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return RoutesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      distance: distance ?? this.distance,
      ascent: ascent ?? this.ascent,
      descent: descent ?? this.descent,
      track: track ?? this.track,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $RoutesTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $RoutesTable.$converter1;
      map['user_id'] = Variable<int>(converter.mapToSql(userId.value)!);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (distance.present) {
      map['distance'] = Variable<int>(distance.value);
    }
    if (ascent.present) {
      map['ascent'] = Variable<int?>(ascent.value);
    }
    if (descent.present) {
      map['descent'] = Variable<int?>(descent.value);
    }
    if (track.present) {
      final converter = $RoutesTable.$converter2;
      map['track'] = Variable<Uint8List?>(converter.mapToSql(track.value));
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('distance: $distance, ')
          ..write('ascent: $ascent, ')
          ..write('descent: $descent, ')
          ..write('track: $track, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  final GeneratedDatabase _db;
  final String? _alias;
  $RoutesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($RoutesTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($RoutesTable.$converter1);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _distanceMeta = const VerificationMeta('distance');
  late final GeneratedColumn<int?> distance = GeneratedColumn<int?>(
      'distance', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _ascentMeta = const VerificationMeta('ascent');
  late final GeneratedColumn<int?> ascent = GeneratedColumn<int?>(
      'ascent', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _descentMeta = const VerificationMeta('descent');
  late final GeneratedColumn<int?> descent = GeneratedColumn<int?>(
      'descent', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  final VerificationMeta _trackMeta = const VerificationMeta('track');
  late final GeneratedColumnWithTypeConverter<List<Position>, Uint8List?>
      track = GeneratedColumn<Uint8List?>('track', aliasedName, true,
              typeName: 'BLOB', requiredDuringInsert: false)
          .withConverter<List<Position>>($RoutesTable.$converter2);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        name,
        distance,
        ascent,
        descent,
        track,
        deleted,
        lastModified,
        isNew
      ];
  @override
  String get aliasedName => _alias ?? 'routes';
  @override
  String get actualTableName => 'routes';
  @override
  VerificationContext validateIntegrity(Insertable<Route> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    } else if (isInserting) {
      context.missing(_distanceMeta);
    }
    if (data.containsKey('ascent')) {
      context.handle(_ascentMeta,
          ascent.isAcceptableOrUnknown(data['ascent']!, _ascentMeta));
    }
    if (data.containsKey('descent')) {
      context.handle(_descentMeta,
          descent.isAcceptableOrUnknown(data['descent']!, _descentMeta));
    }
    context.handle(_trackMeta, const VerificationResult.success());
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      id: $RoutesTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $RoutesTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']))!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      distance: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}distance'])!,
      ascent: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ascent']),
      descent: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}descent']),
      track: $RoutesTable.$converter2.mapToDart(const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}track'])),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
  static TypeConverter<List<Position>, Uint8List> $converter2 =
      const DbPositionListConverter();
}

class WodsCompanion extends UpdateCompanion<Wod> {
  final Value<Int64> id;
  final Value<Int64> userId;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<bool> deleted;
  final Value<DateTime> lastModified;
  final Value<bool> isNew;
  const WodsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  });
  WodsCompanion.insert({
    this.id = const Value.absent(),
    required Int64 userId,
    required DateTime date,
    this.description = const Value.absent(),
    this.deleted = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isNew = const Value.absent(),
  })  : userId = Value(userId),
        date = Value(date);
  static Insertable<Wod> custom({
    Expression<Int64>? id,
    Expression<Int64>? userId,
    Expression<DateTime>? date,
    Expression<String?>? description,
    Expression<bool>? deleted,
    Expression<DateTime>? lastModified,
    Expression<bool>? isNew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (deleted != null) 'deleted': deleted,
      if (lastModified != null) 'last_modified': lastModified,
      if (isNew != null) 'is_new': isNew,
    });
  }

  WodsCompanion copyWith(
      {Value<Int64>? id,
      Value<Int64>? userId,
      Value<DateTime>? date,
      Value<String?>? description,
      Value<bool>? deleted,
      Value<DateTime>? lastModified,
      Value<bool>? isNew}) {
    return WodsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      description: description ?? this.description,
      deleted: deleted ?? this.deleted,
      lastModified: lastModified ?? this.lastModified,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $WodsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (userId.present) {
      final converter = $WodsTable.$converter1;
      map['user_id'] = Variable<int>(converter.mapToSql(userId.value)!);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WodsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('deleted: $deleted, ')
          ..write('lastModified: $lastModified, ')
          ..write('isNew: $isNew')
          ..write(')'))
        .toString();
  }
}

class $WodsTable extends Wods with TableInfo<$WodsTable, Wod> {
  final GeneratedDatabase _db;
  final String? _alias;
  $WodsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumnWithTypeConverter<Int64, int?> id =
      GeneratedColumn<int?>('id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: false)
          .withConverter<Int64>($WodsTable.$converter0);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumnWithTypeConverter<Int64, int?> userId =
      GeneratedColumn<int?>('user_id', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Int64>($WodsTable.$converter1);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  late final GeneratedColumn<bool?> deleted = GeneratedColumn<bool?>(
      'deleted', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (deleted IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  late final GeneratedColumn<DateTime?> lastModified =
      GeneratedColumn<DateTime?>('last_modified', aliasedName, false,
          typeName: 'INTEGER',
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  final VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  late final GeneratedColumn<bool?> isNew = GeneratedColumn<bool?>(
      'is_new', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_new IN (0, 1))',
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, date, description, deleted, lastModified, isNew];
  @override
  String get aliasedName => _alias ?? 'wods';
  @override
  String get actualTableName => 'wods';
  @override
  VerificationContext validateIntegrity(Insertable<Wod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    context.handle(_userIdMeta, const VerificationResult.success());
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Wod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wod(
      id: $WodsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      userId: $WodsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id']))!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      deleted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted'])!,
    );
  }

  @override
  $WodsTable createAlias(String alias) {
    return $WodsTable(_db, alias);
  }

  static TypeConverter<Int64, int> $converter0 = const DbIdConverter();
  static TypeConverter<Int64, int> $converter1 = const DbIdConverter();
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $MetconsTable metcons = $MetconsTable(this);
  late final $MetconMovementsTable metconMovements =
      $MetconMovementsTable(this);
  late final $MetconSessionsTable metconSessions = $MetconSessionsTable(this);
  late final $MovementsTable movements = $MovementsTable(this);
  late final $StrengthSessionsTable strengthSessions =
      $StrengthSessionsTable(this);
  late final $StrengthSetsTable strengthSets = $StrengthSetsTable(this);
  late final $CardioSessionsTable cardioSessions = $CardioSessionsTable(this);
  late final $RoutesTable routes = $RoutesTable(this);
  late final $WodsTable wods = $WodsTable(this);
  late final MetconsDao metconsDao = MetconsDao(this as Database);
  late final MovementsDao movementsDao = MovementsDao(this as Database);
  late final StrengthDao strengthDao = StrengthDao(this as Database);
  late final CardioDao cardioDao = CardioDao(this as Database);
  late final WodDao wodDao = WodDao(this as Database);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        metcons,
        metconMovements,
        metconSessions,
        movements,
        strengthSessions,
        strengthSets,
        cardioSessions,
        routes,
        wods
      ];
}
