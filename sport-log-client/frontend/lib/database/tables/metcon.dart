
import 'package:fixnum/fixnum.dart';
import 'package:sport_log/database/database.dart';
import 'package:sport_log/database/table.dart';
import 'package:sport_log/models/metcon/all.dart';

class MetconTable extends Table<Metcon> {
  @override String get setupSql => '''
create table metcon (
    id integer primary key,
    user_id integer,
    name text check (length(name) <= 80),
    metcon_type integer not null check (metcon_type between 0 and 2),
    rounds integer check (rounds >= 1),
    timecap integer check (timecap > 0), -- seconds
    description text,
    last_change text not null default (datetime('now')),
    deleted integer not null default 0 check (deleted in (0, 1)),
    is_new integer not null check (is_new in (0, 1)),
    unique (user_id, name, deleted)
);
  ''';
  @override DbSerializer<Metcon> get serde => DbMetconSerializer();
  @override String get tableName => 'metcon';

  final metconMovements = AppDatabase.instance!.metconMovements;

  DbResult<void> deleteWithMetconMovements(Int64 id) async {
    return voidRequest((db) async {
      await db.transaction((txn) async {
        txn.update(
          metconMovements.tableName,
          {Keys.deleted: 1},
          where: '${Keys.metconId} = ?',
          whereArgs: [id.toInt()]
        );
        txn.update(
          tableName,
          {Keys.deleted: 1},
          where: '${Keys.id} = ?',
          whereArgs: [id.toInt()]
        );
      });
    });
  }
}

class MetconMovementTable extends Table<MetconMovement> {
  @override DbSerializer<MetconMovement> get serde => DbMetconMovementSerializer();
  @override String get setupSql => '''
create table metcon_movement (
    id integer primary key,
    metcon_id integer not null references metcon(id) on delete cascade,
    movement_id integer not null references movement(id) on delete no action,
    movement_number integer not null check (movement_number >= 1),
    count integer not null check (count >= 1),
    movement_unit integer not null check (movement_unit between 0 and 6),
    weight real check (weight > 0),
    last_change text not null default (datetime('now')),
    deleted integer not null default 0 check (deleted in (0, 1)),
    is_new integer not null check (is_new in (0, 1)),
    unique (metcon_id, movement_number, deleted)
);
  ''';
  @override String get tableName => 'metcon_movement';
}

class MetconSessionTable extends Table<MetconSession> {
  @override DbSerializer<MetconSession> get serde => DbMetconSessionSerializer();
  @override
  String get setupSql => '''
create table metcon_session (
    id integer primary key,
    user_id integer not null,
    metcon_id integer not null references metcon(id) on delete no action,
    datetime text not null default (datetime('now')),
    time integer check (time > 0), -- seconds
    rounds integer check (rounds >= 0),
    reps integer check (reps >= 0),
    rx integer not null default 1 check (rx in (0, 1)),
    comments text,
    last_change text not null default (datetime('now')),
    deleted integer not null default 0 check (deleted in (0, 1)),
    is_new integer not null check (is_new in (0, 1)),
    unique (user_id, metcon_id, datetime, deleted)
);
  ''';
  @override String get tableName => 'metcon_session';
}
