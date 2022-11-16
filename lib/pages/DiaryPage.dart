import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_location_2nd/Util/Util.dart';
import 'package:test_location_2nd/Util/DateHandler.dart';
import 'package:test_location_2nd/Util/global.dart' as global;
import 'package:test_location_2nd/Data/DataManager.dart';
import 'package:test_location_2nd/Note/NoteManager.dart';
import 'package:test_location_2nd/StateProvider/NavigationIndexStateProvider.dart';
import 'package:test_location_2nd/StateProvider/YearPageStateProvider.dart';
import 'package:test_location_2nd/StateProvider/DayPageStateProvider.dart';

class DiaryPage extends StatefulWidget {
  NoteManager noteManager;

  @override
  State<DiaryPage> createState() => _DiaryPageState();

  DiaryPage(this.noteManager, {Key? key}) : super(key: key);
}

class _DiaryPageState extends State<DiaryPage> {
  late NoteManager noteManager;

  @override
  void initState() {
    this.noteManager = widget.noteManager;
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      // backgroundColor: Colors.black12.withAlpha(10),
      body: Center(
        child: ListView.builder(
            itemCount: noteManager.notes.length,
            itemBuilder: (BuildContext buildContext, int index) {
              String date = noteManager.notes.keys.elementAt(index);
              return MaterialButton(
                onPressed: () {

                  var provider =
                  Provider.of<NavigationIndexProvider>(context, listen: false);
                  var yearPageStateProvider =
                  Provider.of<YearPageStateProvider>(context, listen: false);

                  provider.setNavigationIndex(2);
                  provider.setDate(formatDateString(date));
                  yearPageStateProvider.setAvailableDates(int.parse(date.substring(0, 4)));
                  Provider.of<DayPageStateProvider>(context, listen: false)
                      .setAvailableDates(yearPageStateProvider.availableDates);

                },
                // padding: EdgeInsets.all(5),
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: physicalWidth,
                  color:
                      global.kColor_container, //Colors.black12.withAlpha(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${formateDate2(formatDateString(date))}",
                        style: TextStyle(
                            fontWeight: global.kFontWeight_diaryTitle,
                            color: global.kColor_diaryText),
                      ),
                      Text(
                        "${noteManager.notes[date]}",
                        style: TextStyle(
                            fontWeight: global.kFontWeight_diaryContents,
                            color: global.kColor_diaryText),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print(noteManager.notes);
        },
      ),
    );
  }
}
