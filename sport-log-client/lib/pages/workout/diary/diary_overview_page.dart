import 'package:flutter/material.dart';
import 'package:sport_log/api/api.dart';
import 'package:sport_log/data_provider/data_providers/diary_data_provider.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/formatting.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/helpers/snackbar.dart';
import 'package:sport_log/models/diary/diary.dart';
import 'package:sport_log/pages/workout/date_filter/date_filter_state.dart';
import 'package:sport_log/pages/workout/date_filter/date_filter_widget.dart';
import 'package:sport_log/pages/workout/session_tab_utils.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/main_drawer.dart';
import 'package:sport_log/widgets/value_unit_description.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => DiaryPageState();
}

class DiaryPageState extends State<DiaryPage> {
  final _logger = Logger('DiaryPage');
  final _dataProvider = DiaryDataProvider.instance;
  List<Diary> _diaries = [];
  //Diary(
  //id: randomId(),
  //userId: Settings.userId!,
  //date: DateTime.now(),
  //bodyweight: null,
  //comments: null,
  //deleted: false),
  //Diary(
  //id: randomId(),
  //userId: Settings.userId!,
  //date: DateTime.now().subtract(const Duration(days: 1)),
  //bodyweight: 78.3,
  //comments: null,
  //deleted: false),
  //Diary(
  //id: randomId(),
  //userId: Settings.userId!,
  //date: DateTime.now().subtract(const Duration(days: 2)),
  //bodyweight: null,
  //comments: "bla bli\nblub\n..la",
  //deleted: false),
  //Diary(
  //id: randomId(),
  //userId: Settings.userId!,
  //date: DateTime.now().subtract(const Duration(days: 3)),
  //bodyweight: 80.0,
  //comments: "bla",
  //deleted: false),
  //Diary(
  //id: randomId(),
  //userId: Settings.userId!,
  //date: DateTime.now().subtract(const Duration(days: 5)),
  //bodyweight: 180.0,
  //comments:
  //"very long line bc abc abc abc abc abc abc abc abc abc abc abc",
  //deleted: false),
  //];

  DateFilterState _dateFilter = MonthFilter.current();

  @override
  void initState() {
    super.initState();
    _dataProvider.addListener(update);
    _dataProvider.onNoInternetConnection =
        () => showSimpleSnackBar(context, 'No Internet connection.');
    update();
  }

  @override
  void dispose() {
    _dataProvider.removeListener(update);
    _dataProvider.onNoInternetConnection = null;
    super.dispose();
  }

  Future<void> update() async {
    _logger.d(
        'Updating diary page with start = ${_dateFilter.start}, end = ${_dateFilter.end}');
    final diaries = await _dataProvider.getByTimerange(
        from: _dateFilter.start, until: _dateFilter.end);
    setState(() => _diaries = diaries);
  }

  // full update (from server)
  Future<void> _refreshPage() async {
    await _dataProvider.doFullUpdate().onError((error, stackTrace) {
      if (error is ApiError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toErrorMessage())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: DateFilter(
            initialState: _dateFilter,
            onFilterChanged: (dateFilter) => setState(() {
              _dateFilter = dateFilter;
            }),
          ),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: ListView.builder(
            itemBuilder: (_, index) => DiaryCard(diary: _diaries[index]),
            itemCount: _diaries.length,
          )),
      bottomNavigationBar:
          SessionTabUtils.bottomNavigationBar(context, SessionsPageTab.diary),
      drawer: MainDrawer(selectedRoute: Routes.diary.overview),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.diary.edit);
          }),
    );
  }
}

class DiaryCard extends StatelessWidget {
  final Diary diary;

  const DiaryCard({Key? key, required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.diary.edit, arguments: diary);
        },
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(diary.date),
                      style: const TextStyle(fontSize: 20),
                    ),
                    Defaults.sizedBox.horizontal.big,
                    SizedBox(
                      width: 80,
                      child: diary.bodyweight != null
                          ? ValueUnitDescription(
                              value: diary.bodyweight!.toStringAsFixed(1),
                              unit: "kg",
                              description: null)
                          : null,
                    ),
                    Defaults.sizedBox.horizontal.big,
                    Expanded(
                      child: Text(
                        diary.comments ?? "",
                        textAlign: TextAlign.start,
                        softWrap: true,
                      ),
                    ),
                  ],
                ))));
  }
}
