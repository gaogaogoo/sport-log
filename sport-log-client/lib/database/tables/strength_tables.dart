import 'package:fixnum/fixnum.dart';
import 'package:sport_log/database/database.dart';
import 'package:sport_log/database/table.dart';
import 'package:sport_log/database/table_accessor.dart';
import 'package:sport_log/database/tables/movement_table.dart';
import 'package:sport_log/helpers/eorm.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/extensions/iterable_extension.dart';
import 'package:sport_log/models/all.dart';

class StrengthSessionAndMovement {
  StrengthSessionAndMovement({
    required this.session,
    required this.movement,
  });
  StrengthSession session;
  Movement movement;
}

class StrengthSessionTable extends TableAccessor<StrengthSession> {
  @override
  DbSerializer<StrengthSession> get serde => DbStrengthSessionSerializer();

  @override
  final Table table = Table(
    name: Tables.strengthSession,
    columns: [
      Column.int(Columns.id)..primaryKey(),
      Column.bool(Columns.deleted)..withDefault('0'),
      Column.int(Columns.syncStatus)
        ..withDefault('2')
        ..checkIn(<int>[0, 1, 2]),
      Column.int(Columns.userId),
      Column.text(Columns.datetime),
      Column.int(Columns.movementId)
        ..references(Tables.movement, onDelete: OnAction.cascade),
      Column.int(Columns.interval)
        ..nullable()
        ..checkGt(0),
      Column.text(Columns.comments)..nullable(),
    ],
    uniqueColumns: [
      [Columns.datetime, Columns.movementId]
    ],
    rawSql: [
      '''
        create table ${Tables.eorm} (
          ${Columns.eormReps} integer primary key check (${Columns.eormReps} >= 1),
          ${Columns.eormPercentage} real not null check (${Columns.eormPercentage} > 0)
        );
        ''',
      '''
        insert into ${Tables.eorm} (${Columns.eormReps}, ${Columns.eormPercentage}) values $eormValuesSql;
        ''',
    ],
  );
}

class StrengthSetTable extends TableAccessor<StrengthSet> {
  @override
  DbSerializer<StrengthSet> get serde => DbStrengthSetSerializer();

  @override
  final Table table = Table(
    name: Tables.strengthSet,
    columns: [
      Column.int(Columns.id)..primaryKey(),
      Column.bool(Columns.deleted)..withDefault('0'),
      Column.int(Columns.syncStatus)
        ..withDefault('2')
        ..checkIn(<int>[0, 1, 2]),
      Column.int(Columns.strengthSessionId)
        ..references(Tables.strengthSession, onDelete: OnAction.cascade),
      Column.int(Columns.setNumber)..checkGe(0),
      Column.int(Columns.count)..checkGe(1),
      Column.real(Columns.weight)
        ..nullable()
        ..checkGt(0),
    ],
    uniqueColumns: [
      [Columns.strengthSessionId, Columns.setNumber]
    ],
  );

  Future<void> setSynchronizedByStrengthSession(Int64 id) async {
    await database.update(
      tableName,
      TableAccessor.synchronized,
      where: '${Columns.strengthSessionId} = ?',
      whereArgs: [id.toInt()],
    );
  }

  Future<List<StrengthSet>> getByStrengthSession(Int64 id) async {
    final result = await database.query(
      tableName,
      where: TableAccessor.combineFilter([
        notDeleted,
        '${Columns.strengthSessionId} = ?',
      ]),
      whereArgs: [id.toInt()],
      orderBy: Columns.setNumber,
    );
    return result.map(serde.fromDbRecord).toList();
  }
}

class StrengthSessionDescriptionTable {
  static const count = Columns.count;
  static const datetime = Columns.datetime;
  static const deleted = Columns.deleted;
  static const eormPercentage = Columns.eormPercentage;
  static const eormReps = Columns.eormReps;
  static const id = Columns.id;
  static const maxCount = Columns.maxCount;
  static const maxEorm = Columns.maxEorm;
  static const maxWeight = Columns.maxWeight;
  static const minCount = Columns.minCount;
  static const movementId = Columns.movementId;
  static const name = Columns.name;
  static const numSets = Columns.numSets;
  static const setNumber = Columns.setNumber;
  static const strengthSessionId = Columns.strengthSessionId;
  static const sumCount = Columns.sumCount;
  static const sumVolume = Columns.sumVolume;
  static const weight = Columns.weight;

  static const strengthSession = Tables.strengthSession;
  static const strengthSet = Tables.strengthSet;
  static const movement = Tables.movement;
  static const eorm = Tables.eorm;

  static StrengthSessionTable get _strengthSessionTable =>
      AppDatabase.strengthSessions;

  static MovementTable get _movementTable => AppDatabase.movements;
  static StrengthSetTable get _strengthSetTable => AppDatabase.strengthSets;

  Future<StrengthSessionDescription?> getById(Int64 idValue) async {
    final records = await AppDatabase.database!.rawQuery(
      '''
      SELECT
        ${_strengthSessionTable.table.allColumns},
        ${_movementTable.table.allColumns}
      FROM $strengthSession
        JOIN $movement ON $movement.$id = $strengthSession.$movementId
      WHERE $strengthSession.$deleted = 0
        AND $movement.$deleted = 0
        AND $strengthSession.$id = ?;
    ''',
      [idValue.toInt()],
    );
    if (records.isEmpty) {
      return null;
    }
    return StrengthSessionDescription(
      session: _strengthSessionTable.serde.fromDbRecord(
        records.first,
        prefix: _strengthSessionTable.table.prefix,
      ),
      movement: _movementTable.serde
          .fromDbRecord(records.first, prefix: _movementTable.table.prefix),
      sets: await _strengthSetTable.getByStrengthSession(idValue),
    );
  }

  Future<List<StrengthSessionDescription>> getByTimerangeAndMovement({
    Movement? movementValue,
    DateTime? from,
    DateTime? until,
  }) async {
    final records = await AppDatabase.database!.rawQuery(
      '''
      SELECT
        ${_strengthSessionTable.table.allColumns},
        ${_movementTable.table.allColumns}
      FROM $strengthSession
      JOIN $movement ON $movement.$id = $strengthSession.$movementId
      WHERE ${TableAccessor.combineFilter([
            TableAccessor.notDeletedOfTable(movement),
            TableAccessor.notDeletedOfTable(strengthSession),
            TableAccessor.fromFilterOfTable(strengthSession, from),
            TableAccessor.untilFilterOfTable(strengthSession, until),
            TableAccessor.movementIdFilterOfTable(
              strengthSession,
              movementValue,
            ),
          ])}
      GROUP BY ${TableAccessor.groupByIdOfTable(strengthSession)}
      ORDER BY ${TableAccessor.orderByDatetimeOfTable(strengthSession)}
      ;
    ''',
    );
    List<StrengthSessionDescription> strengthSessionDescriptions = [];
    for (final Map<String, Object?> record in records) {
      final session = _strengthSessionTable.serde
          .fromDbRecord(record, prefix: _strengthSessionTable.table.prefix);
      strengthSessionDescriptions.add(
        StrengthSessionDescription(
          session: session,
          sets: await _strengthSetTable.getByStrengthSession(session.id),
          movement: _movementTable.serde
              .fromDbRecord(record, prefix: _movementTable.table.prefix),
        ),
      );
    }
    return strengthSessionDescriptions;
  }

  Future<List<StrengthSet>> getSetsOnDay({
    required DateTime date,
    required Int64 movementIdValue,
  }) async {
    final start = date.beginningOfDay();
    final end = date.endOfDay();
    final records = await AppDatabase.database!.rawQuery(
      '''
      SELECT
        ${_strengthSetTable.table.allColumns}
      FROM $strengthSession
        JOIN $strengthSet ON $strengthSet.$strengthSessionId = $strengthSession.$id
      WHERE $strengthSet.$deleted = 0
        AND $strengthSession.$deleted = 0
        AND $strengthSession.$datetime >= ?
        AND $strengthSession.$datetime < ?
        AND $strengthSession.$movementId = ?
      ORDER BY $strengthSession.$datetime, $strengthSession.$id, $strengthSet.$setNumber;
    ''',
      [start.toString(), end.toString(), movementIdValue.toInt()],
    );
    return records.mapToList(
      (record) => _strengthSetTable.serde
          .fromDbRecord(record, prefix: _strengthSetTable.table.prefix),
    );
  }

  Future<List<StrengthSessionStats>> getStatsAggregationsByDay({
    required Int64 movementIdValue,
    required DateTime from,
    required DateTime until,
  }) async {
    final records = await AppDatabase.database!.rawQuery(
      '''
      SELECT
        $strengthSession.$datetime AS [$datetime],
        date($strengthSession.$datetime) AS [date],
        COUNT($strengthSet.$id) AS $numSets,
        MIN($strengthSet.$count) AS $minCount,
        MAX($strengthSet.$count) AS $maxCount,
        SUM($strengthSet.$count) AS $sumCount,
        MAX($strengthSet.$weight) AS $maxWeight,
        SUM($strengthSet.$count * $strengthSet.$weight) AS $sumVolume,
        MAX($strengthSet.$weight / $eormPercentage) AS $maxEorm
      FROM $strengthSession
        JOIN $strengthSet ON $strengthSet.$strengthSessionId = $strengthSession.$id
        LEFT JOIN $eorm ON $eormReps = $strengthSet.$count
      WHERE $strengthSet.$deleted = 0
        AND $strengthSession.$deleted = 0
        AND $strengthSession.$movementId = ?
        AND $strengthSession.$datetime >= ?
        AND $strengthSession.$datetime < ?
      GROUP BY [date]
      ORDER BY [date];
     ''',
      [movementIdValue.toInt(), from.toString(), until.toString()],
    );
    return records
        .map((record) => StrengthSessionStats.fromDbRecord(record))
        .toList();
  }

  Future<List<StrengthSessionStats>> getStatsAggregationsByWeek({
    required Int64 movementIdValue,
    required DateTime from,
    required DateTime until,
  }) async {
    assert(
      from.year == until.year || from.beginningOfYear().yearLater() == until,
    );
    final records = await AppDatabase.database!.rawQuery(
      '''
      SELECT
        $strengthSession.$datetime AS [$datetime],
        strftime('%W', $strengthSession.$datetime) AS week,
        COUNT($strengthSet.$id) AS $numSets,
        MIN($strengthSet.$count) AS $minCount,
        MAX($strengthSet.$count) AS $maxCount,
        SUM($strengthSet.$count) AS $sumCount,
        MAX($strengthSet.$weight) AS $maxWeight,
        SUM($strengthSet.$count * $strengthSet.$weight) AS $sumVolume,
        MAX($strengthSet.$weight / $eormPercentage) AS $maxEorm
      FROM $strengthSession
        JOIN $strengthSet ON $strengthSet.$strengthSessionId = $strengthSession.$id
        LEFT JOIN $eorm ON $eormReps = $strengthSet.$count
      WHERE $strengthSet.$deleted = 0
        AND $strengthSession.$deleted = 0
        AND $strengthSession.$movementId = ?
        AND $strengthSession.$datetime >= ?
        AND $strengthSession.$datetime < ?
      GROUP BY week
      ORDER BY week;
    ''',
      [movementIdValue.toInt(), from.toString(), until.toString()],
    );
    return records
        .map((record) => StrengthSessionStats.fromDbRecord(record))
        .toList();
  }

  Future<List<StrengthSessionStats>> getStatsAggregationsByMonth({
    required Int64 movementIdValue,
  }) async {
    final records = await AppDatabase.database!.rawQuery(
      '''
      SELECT
        $strengthSession.$datetime AS [$datetime],
        strftime('%Y_%m', $strengthSession.$datetime) AS month,
        COUNT($strengthSet.$id) AS $numSets,
        MIN($strengthSet.$count) AS $minCount,
        MAX($strengthSet.$count) AS $maxCount,
        SUM($strengthSet.$count) AS $sumCount,
        MAX($strengthSet.$weight) AS $maxWeight,
        SUM($strengthSet.$count * $strengthSet.$weight) AS $sumVolume,
        MAX($strengthSet.$weight / $eormPercentage) AS $maxEorm
      FROM $strengthSession
        JOIN $strengthSet ON $strengthSet.$strengthSessionId = $strengthSession.$id
        LEFT JOIN $eorm ON $eormReps = $strengthSet.$count
      WHERE $strengthSet.$deleted = 0
        AND $strengthSession.$deleted = 0
        AND $strengthSession.$movementId = ?
      GROUP BY month
      ORDER BY month;
    ''',
      [movementIdValue.toInt()],
    );
    return records
        .map((record) => StrengthSessionStats.fromDbRecord(record))
        .toList();
  }
}
