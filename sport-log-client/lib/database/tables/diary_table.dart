import 'package:sport_log/database/table.dart';
import 'package:sport_log/database/table_accessor.dart';
import 'package:sport_log/helpers/formatting.dart';
import 'package:sport_log/models/diary/all.dart';

class DiaryTable extends TableAccessor<Diary> {
  @override
  DbSerializer<Diary> get serde => DbDiarySerializer();

  @override
  final Table table = Table(
    name: Tables.diary,
    columns: [
      Column.int(Columns.id)..primaryKey(),
      Column.bool(Columns.deleted)..withDefault('0'),
      Column.int(Columns.syncStatus)
        ..withDefault('2')
        ..checkIn(<int>[0, 1, 2]),
      Column.int(Columns.userId),
      Column.text(Columns.date)..withDefault("datetime('now')"),
      Column.real(Columns.bodyweight)
        ..nullable()
        ..checkGt(0),
      Column.text(Columns.comments)..nullable()
    ],
    uniqueColumns: [
      [Columns.date]
    ],
  );

  Future<List<Diary>> getByTimerange(
    DateTime? from,
    DateTime? until,
  ) async {
    final records = await database.query(
      Tables.diary,
      where: [
        notDeleted,
        if (from != null) " AND $tableName.${Columns.date} >= ?",
        if (until != null) " AND $tableName.${Columns.date} < ?"
      ].join(),
      whereArgs: [
        if (from != null) from.yyyyMMdd,
        if (until != null) until.yyyyMMdd
      ],
      orderBy: "$tableName.${Columns.date} DESC",
    );
    return records.map(serde.fromDbRecord).toList();
  }
}
