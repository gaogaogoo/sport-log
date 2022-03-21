import 'package:fixnum/fixnum.dart';
import 'package:sport_log/api/api.dart';
import 'package:sport_log/data_provider/data_provider.dart';
import 'package:sport_log/data_provider/data_providers/movement_data_provider.dart';
import 'package:sport_log/database/database.dart';
import 'package:sport_log/database/table_accessor.dart';
import 'package:sport_log/models/account_data/account_data.dart';
import 'package:sport_log/models/cardio/all.dart';
import 'package:sport_log/models/cardio/cardio_session_description.dart';

class RouteDataProvider extends EntityDataProvider<Route> {
  static final instance = RouteDataProvider._();
  RouteDataProvider._();

  @override
  final Api<Route> api = Api.routes;

  @override
  final TableAccessor<Route> db = AppDatabase.routes;

  @override
  List<Route> getFromAccountData(AccountData accountData) => accountData.routes;
}

class CardioSessionDataProvider extends EntityDataProvider<CardioSession> {
  static final instance = CardioSessionDataProvider._();
  CardioSessionDataProvider._();

  @override
  final Api<CardioSession> api = Api.cardioSessions;

  @override
  final TableAccessor<CardioSession> db = AppDatabase.cardioSessions;

  @override
  List<CardioSession> getFromAccountData(AccountData accountData) =>
      accountData.cardioSessions;
}

class CardioSessionDescriptionDataProvider
    extends DataProvider<CardioSessionDescription> {
  final _cardioSessionDescriptionDb = AppDatabase.cardioSessionDescriptions;

  final _cardioDataProvider = CardioSessionDataProvider.instance;
  final _routeDataProvider = RouteDataProvider.instance;
  final _movementDataProvider = MovementDataProvider.instance;

  CardioSessionDescriptionDataProvider._();
  static CardioSessionDescriptionDataProvider? _instance;
  static CardioSessionDescriptionDataProvider get instance {
    if (_instance == null) {
      _instance = CardioSessionDescriptionDataProvider._();
      _instance!._cardioDataProvider.addListener(_instance!.notifyListeners);
      _instance!._routeDataProvider.addListener(_instance!.notifyListeners);
      _instance!._movementDataProvider.addListener(_instance!.notifyListeners);
    }
    return _instance!;
  }

  @override
  Future<DbResult> createSingle(CardioSessionDescription object) async {
    return await _cardioDataProvider.createSingle(object.cardioSession);
  }

  @override
  Future<DbResult> updateSingle(CardioSessionDescription object) async {
    return await _cardioDataProvider.updateSingle(object.cardioSession);
  }

  @override
  Future<DbResult> deleteSingle(CardioSessionDescription object) async {
    return await _cardioDataProvider.deleteSingle(object.cardioSession);
  }

  @override
  Future<List<CardioSessionDescription>> getNonDeleted() async {
    return Future.wait(
      (await _cardioDataProvider.getNonDeleted())
          .map(
            (session) async => CardioSessionDescription(
              cardioSession: session,
              route: await _routeDataProvider.getById(session.id),
              movement:
                  (await _movementDataProvider.getById(session.movementId))!,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<bool> pullFromServer() async {
    if (!await _movementDataProvider.pullFromServer()) {
      return false;
    }
    if (!await _routeDataProvider.pullFromServer()) {
      return false;
    }
    return await _cardioDataProvider.pullFromServer();
  }

  @override
  Future<bool> pushCreatedToServer() async {
    return await _cardioDataProvider.pushCreatedToServer();
  }

  @override
  Future<bool> pushUpdatedToServer() async {
    return await _cardioDataProvider.pushUpdatedToServer();
  }

  Future<List<CardioSessionDescription>> getByTimerangeAndMovement({
    Int64? movementId,
    DateTime? from,
    DateTime? until,
  }) async {
    return _cardioSessionDescriptionDb.getByTimerangeAndMovement(
      from: from,
      until: until,
      movementIdValue: movementId,
    );
  }
}
