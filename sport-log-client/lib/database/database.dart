import 'dart:io';

import 'package:sport_log/config.dart';
import 'package:sport_log/database/table.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/models/account_data/account_data.dart';
import 'package:sqflite/sqflite.dart';

import 'tables/all.dart';

final _logger = Logger('DB');

class AppDatabase {
  static final AppDatabase? instance =
      Config.isAndroid || Config.isIOS ? AppDatabase._() : null;

  AppDatabase._();

  Future<void> init() async {
    const fileName = Config.databaseName;
    if (Config.deleteDatabase) {
      final File databaseFile = File(await getDatabasesPath() + '/' + fileName);
      if (await databaseFile.exists()) {
        _logger.i('Clean start on: deleting existing database...');
        await databaseFile.delete();
      }
    }
    String version = '';
    await openDatabase(fileName,
        version: 1,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON;'),
        onCreate: (db, version) async {
          List<String> sql = [];
          for (final table in allTables) {
            sql += table.setupSql;
          }
          for (final statement in sql) {
            _logger.d(statement);
            db.execute(statement);
          }
        },
        onOpen: (db) async {
          for (final table in allTables) {
            table.setDatabase(db);
          }
          version = (await db.rawQuery('select sqlite_version() AS version'))
                  .first['version'] as String;
        });
    _logger.d("Database initialization done (sqlite version $version).");
  }

  Future<void> upsertAccountData(AccountData data) async {
    diaries.upsertMultiple(data.diaries);
    wods.upsertMultiple(data.wods);
    movements.upsertMultiple(data.movements);
    metcons.upsertMultiple(data.metcons);
    metconMovements.upsertMultiple(data.metconMovements);
    metconSessions.upsertMultiple(data.metconSessions);
    routes.upsertMultiple(data.routes);
    cardioSessions.upsertMultiple(data.cardioSessions);
    platforms.upsertMultiple(data.platforms);
    platformCredentials.upsertMultiple(data.platformCredentials);
    actionProviders.upsertMultiple(data.actionProviders);
    actions.upsertMultiple(data.actions);
    actionRules.upsertMultiple(data.actionRules);
    actionEvents.upsertMultiple(data.actionEvents);
  }

  final movements = MovementTable();
  final metcons = MetconTable();
  final metconMovements = MetconMovementTable();
  final metconSessions = MetconSessionTable();
  final routes = RouteTable();
  final cardioSessions = CardioSessionTable();
  final strengthSets = StrengthSetTable();
  final strengthSessions = StrengthSessionTable();
  final platforms = PlatformTable();
  final platformCredentials = PlatformCredentialTable();
  final actionProviders = ActionProviderTable();
  final actions = ActionTable();
  final actionRules = ActionRuleTable();
  final actionEvents = ActionEventTable();
  final diaries = DiaryTable();
  final wods = WodTable();

  List<DbAccessor> get allTables => [
        movements,
        metcons,
        metconMovements,
        metconSessions,
        routes,
        cardioSessions,
        strengthSets,
        strengthSessions,
        platforms,
        platformCredentials,
        actionProviders,
        actions,
        actionRules,
        actionEvents,
        diaries,
        wods,
      ];
}
