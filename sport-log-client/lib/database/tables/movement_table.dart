import 'package:sport_log/database/table_accessor.dart';
import 'package:sport_log/database/table.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/models/all.dart';

class MovementTable extends TableAccessor<Movement> {
  @override
  DbSerializer<Movement> get serde => DbMovementSerializer();

  @override
  List<String> get setupSql => [
        ...super.setupSql,
        '''
      CREATE UNIQUE INDEX unique_movement_idx
      ON $tableName ($name, $dimension, $userId)
      WHERE $deleted = 0;
      '''
      ];

  @override
  final Table table = Table(
    Tables.movement,
    columns: [
      Column.int(Columns.id)..primaryKey(),
      Column.bool(Columns.deleted)..withDefault('0'),
      Column.int(Columns.syncStatus)
        ..withDefault('2')
        ..checkIn(<int>[0, 1, 2]),
      Column.int(Columns.userId)..nullable(),
      Column.text(Columns.name),
      Column.text(Columns.description)..nullable(),
      Column.bool(Columns.cardio),
      Column.int(Columns.dimension),
    ],
  );

  static const cardioSession = Tables.cardioSession;
  static const deleted = Columns.deleted;
  static const id = Columns.id;
  static const metconMovement = Tables.metconMovement;
  static const movementId = Columns.movementId;
  static const name = Columns.name;
  static const strengthSession = Tables.strengthSession;
  static const dimension = Columns.dimension;
  static const userId = Columns.userId;

  final _logger = Logger('MovementTable');

  Future<List<MovementDescription>> getMovementDescriptions() async {
    // TODO: check for references to cardio blueprint, strength blueprint
    final now = DateTime.now();
    const hasReference = 'has_reference';
    final records = await database.rawQuery(
      '''
    SELECT
      ${table.allColumns},
      (
        EXISTS (
          SELECT * FROM $metconMovement
          WHERE $metconMovement.$movementId = $tableName.$id
        ) OR EXISTS (
          SELECT * FROM $cardioSession
          WHERE $cardioSession.$movementId = $tableName.$id
        ) OR EXISTS (
          SELECT * FROM $strengthSession
          WHERE $strengthSession.$movementId = $tableName.$id
        )
      ) AS $hasReference
    FROM $tableName
    WHERE $tableName.$deleted = 0
      AND ($userId IS NOT NULL
        OR NOT EXISTS (
          SELECT * FROM $tableName m2
          WHERE $tableName.$id <> m2.$id
            AND $tableName.$name = m2.$name
            AND $tableName.$dimension = m2.$dimension
            AND m2.$userId IS NOT NULL
        )
      )
    ORDER BY $name COLLATE NOCASE
    ''',
    );
    _logger.d(
      'Select movement descriptions: ' +
          DateTime.now().difference(now).toString(),
    );
    return records
        .map(
          (r) => MovementDescription(
            movement: serde.fromDbRecord(r, prefix: table.prefix),
            hasReference: r[hasReference]! as int == 1,
          ),
        )
        .toList();
  }

  Future<List<Movement>> getMovements({
    String? byName,
    bool cardioOnly = false,
  }) async {
    final nameFilter = byName != null ? 'AND $name LIKE ?' : '';
    final cardioFilter = cardioOnly == true ? 'AND cardio = true' : '';
    final records = await database.rawQuery(
      '''
      SELECT * FROM $tableName m1
      WHERE $deleted = 0
        $nameFilter
        $cardioFilter
        AND ($userId IS NOT NULL
          OR NOT EXISTS (
            SELECT * FROM $tableName m2
            WHERE m1.$id <> m2.$id
              AND m1.$name = m2.$name
              AND m1.$dimension = m2.$dimension
              AND m2.$userId IS NOT NULL
          )
        )
      ORDER BY $name COLLATE NOCASE
    ''',
      [if (byName != null) '%$byName%'],
    );
    return records.map((r) => serde.fromDbRecord(r)).toList();
  }

  Future<bool> exists(String nameValue, MovementDimension dimValue) async {
    final result = await database.rawQuery(
      '''
      SELECT 1 FROM $tableName
      WHERE $deleted = 0
        AND $name = ?
        AND $dimension = ?
    ''',
      [nameValue, dimValue.index],
    );
    return result.isNotEmpty;
  }
}
