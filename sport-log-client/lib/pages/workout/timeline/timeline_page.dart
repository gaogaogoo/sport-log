import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/data_providers/all.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/helpers/snackbar.dart';
import 'package:sport_log/models/cardio/cardio_session_description.dart';
import 'package:sport_log/models/diary/diary.dart';
import 'package:sport_log/models/metcon/metcon_session_description.dart';
import 'package:sport_log/models/movement/movement.dart';
import 'package:sport_log/models/strength/all.dart';
import 'package:sport_log/models/timeline_union.dart';
import 'package:sport_log/pages/workout/cardio/cardio_overview_page.dart';
import 'package:sport_log/pages/workout/date_filter/date_filter_state.dart';
import 'package:sport_log/pages/workout/date_filter/date_filter_widget.dart';
import 'package:sport_log/pages/workout/diary/diary_overview_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_session_overview_page.dart';
import 'package:sport_log/pages/workout/session_tab_utils.dart';
import 'package:sport_log/pages/workout/strength_sessions/strength_overview_page.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/main_drawer.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => TimelinePageState();
}

class TimelinePageState extends State<TimelinePage> {
  final _logger = Logger('TimelinePage');
  final _strengthDataProvider = StrengthSessionDescriptionDataProvider.instance;
  final _metconDataProvider = MetconSessionDescriptionDataProvider.instance;
  final _cardioDataProvider = CardioSessionDescriptionDataProvider.instance;
  final _diaryDataProvider = DiaryDataProvider.instance;
  List<StrengthSessionDescription> _strengthSessionsDescriptions = [];
  List<MetconSessionDescription> _metconSessionsDescriptions = [];
  List<CardioSessionDescription> _cardioSessionsDescriptions = [];
  List<Diary> _diaries = [];
  List<TimelineUnion> _items = [];

  DateFilterState _dateFilter = MonthFilter.current();
  Movement? _movement;

  @override
  void initState() {
    super.initState();
    _strengthDataProvider
      ..addListener(updateStrengthSessions)
      ..onNoInternetConnection =
          () => showSimpleToast(context, 'No Internet connection.');
    _metconDataProvider
      ..addListener(updateMetconSessions)
      ..onNoInternetConnection =
          () => showSimpleToast(context, 'No Internet connection.');
    _cardioDataProvider
      ..addListener(updateCardioSessions)
      ..onNoInternetConnection =
          () => showSimpleToast(context, 'No Internet connection.');
    _diaryDataProvider
      ..addListener(updateDiaries)
      ..onNoInternetConnection =
          () => showSimpleToast(context, 'No Internet connection.');
    _update();
  }

  @override
  void dispose() {
    _strengthDataProvider
      ..removeListener(updateStrengthSessions)
      ..onNoInternetConnection = null;
    _metconDataProvider
      ..removeListener(updateMetconSessions)
      ..onNoInternetConnection = null;
    _cardioDataProvider
      ..removeListener(updateCardioSessions)
      ..onNoInternetConnection = null;
    _diaryDataProvider
      ..removeListener(updateDiaries)
      ..onNoInternetConnection = null;
    super.dispose();
  }

  Future<void> updateStrengthSessions() async {
    _strengthSessionsDescriptions =
        await _strengthDataProvider.getByTimerangeAndMovement(
      movementId: null,
      from: _dateFilter.start,
      until: _dateFilter.end,
    );
    sortItems();
  }

  Future<void> updateMetconSessions() async {
    _metconSessionsDescriptions =
        await _metconDataProvider.getByTimerangeAndMovement(
      movementId: _movement?.id,
      from: _dateFilter.start,
      until: _dateFilter.end,
    );
    sortItems();
  }

  Future<void> updateCardioSessions() async {
    _cardioSessionsDescriptions =
        await _cardioDataProvider.getByTimerangeAndMovement(
      movementId: _movement?.id,
      from: _dateFilter.start,
      until: _dateFilter.end,
    );
    sortItems();
  }

  Future<void> updateDiaries() async {
    _diaries = await _diaryDataProvider.getByTimerange(
      _dateFilter.start,
      _dateFilter.end,
    );
    sortItems();
  }

  void sortItems() {
    final items = _strengthSessionsDescriptions
        .map((s) => TimelineUnion.strengthSession(s))
        .toList()
      ..addAll(
        _metconSessionsDescriptions.map((m) => TimelineUnion.metconSession(m)),
      )
      ..addAll(
        _cardioSessionsDescriptions.map((c) => TimelineUnion.cardioSession(c)),
      )
      ..addAll(_diaries.map((d) => TimelineUnion.diary(d)))
      ..sort((a, b) => b.compareTo(a));
    if (mounted) {
      setState(() => _items = items);
    }
  }

  Future<void> _update() async {
    _logger.d(
      'Updating timeline with start = ${_dateFilter.start}, end = ${_dateFilter.end}',
    );
    await updateStrengthSessions();
    await updateMetconSessions();
    await updateCardioSessions();
    await updateDiaries();
  }

  Future<void> _pullFromServer() {
    return Future.wait([
      _strengthDataProvider.pullFromServer(),
      _metconDataProvider.pullFromServer(),
      _cardioDataProvider.pullFromServer(),
      _diaryDataProvider.pullFromServer(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_movement?.name ?? "Timeline"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: DateFilter(
            initialState: _dateFilter,
            onFilterChanged: (dateFilter) async {
              setState(() => _dateFilter = dateFilter);
              await _update();
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullFromServer,
        child: _items.isEmpty
            ? SessionsPageTab.timeline.noEntriesText
            : Container(
                padding: Defaults.edgeInsets.normal,
                child: ListView.separated(
                  itemBuilder: (context, index) =>
                      _itemCard(context, _items[index]),
                  separatorBuilder: (_, __) =>
                      Defaults.sizedBox.vertical.normal,
                  itemCount: _items.length,
                ),
              ),
      ),
      bottomNavigationBar: SessionTabUtils.bottomNavigationBar(
        context,
        SessionsPageTab.timeline,
      ),
      drawer: MainDrawer(selectedRoute: Routes.timeline.overview),
      floatingActionButton: null,
    );
  }

  Widget _itemCard(BuildContext context, TimelineUnion item) {
    return item.map(
      (strengthSession) =>
          StrengthSessionCard(strengthSessionDescription: strengthSession),
      (metconSessionDescription) => MetconSessionCard(
        metconSessionDescription: metconSessionDescription,
      ),
      (cardioSession) =>
          CardioSessionCard(cardioSessionDescription: cardioSession),
      (diary) => DiaryCard(diary: diary),
    );
  }
}
