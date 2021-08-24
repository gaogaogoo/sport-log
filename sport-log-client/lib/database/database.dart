
import 'dart:io';

import 'package:result_type/result_type.dart';
import 'package:sport_log/config.dart';
import 'package:sport_log/models/account_data/account_data.dart';
import 'tables/all.dart';
import 'package:sport_log/database/table.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {

  static final AppDatabase? _instance = Config.isAndroid || Config.isIOS
      ? AppDatabase._() : null;

  static AppDatabase? get instance => _instance;

  AppDatabase._();

  // TODO: possible without init method
  Future<void> init() async {
    const fileName = 'database.sqlite';
    final File databaseFile = File(await getDatabasesPath() + '/' + fileName);
    // TODO: remove this
    if (await databaseFile.exists()) {
      await databaseFile.delete();
    }
    await openDatabase(
      fileName,
      version: 1,
      onConfigure: (db) => db.execute("PRAGMA foreign_keys = ON;"),
      onCreate: (db, version) async {
        for (final table in allTables) {
          await table.init(db);
        }
        // FIXME: this is awkward
        metcons.metconMovements = metconMovements;
      }
    );
  }

  DbResult<void> upsertAccountData(AccountData data) async {
    diaries.upsertMultiple(data.diaries);
    wods.upsertMultiple(data.wods);
    movements.upsertMultiple(data.movements);
    strengthSessions.upsertMultiple(data.strengthSessions);
    strengthSets.upsertMultiple(data.strengthSets);
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
    return Success(null);
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


  List<Table> get allTables => [
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