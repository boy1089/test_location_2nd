import 'package:flutter/material.dart';
import 'package:lateDiary/Util/DateHandler.dart';
import 'package:lateDiary/Util/Util.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:lateDiary/Data/DataManager.dart';
import 'package:provider/provider.dart';

class YearPageStateProvider with ChangeNotifier {
  String date = formatDate(DateTime.now());
  double zoomInAngle = 0.0;
  bool isZoomIn = false;
  bool isBottomNavigationBarShown = true;
  int lastNavigationIndex = 0;
  int year = DateTime.now().year;
  int index = 0;

  DataManager dataManager;
  YearPageStateProvider(this.dataManager);

  dynamic data;
  List<String> availableDates = [];
  int maxOfSummary = 0;


  void setAvailableDates(int year) {
    availableDates = dataManager.summaryOfPhotoData.keys.where((element) {
      return element.substring(0, 4) == year.toString();
    }).toList();
    availableDates.sort();
  }

  void updateData() {
    setAvailableDates(year);

    data = List.generate(52, (index) {
      return [
        index,
        1,
        10,
        0.01,
      ];
    });
    if (availableDates.length == 0) return data;

    int weekdayOfJan01 = DateTime(year).weekday;
    int offsetToMakeWeekendOutward = -2;

    //generate data for graph plot
    data = List.generate(availableDates.length, (index) {
      String date = availableDates[index];

      int days = int.parse(DateFormat("D").format(DateTime.parse(date))) +
          weekdayOfJan01 +
          offsetToMakeWeekendOutward;
      int value =
      dataManager.summaryOfPhotoData[date]! > 200 ? 200 : dataManager.summaryOfPhotoData[date]!;
      double distance = 4;
      if (dataManager.summaryOfLocationData.containsKey(date))
        distance = floorDistance(dataManager.summaryOfLocationData[date]!);
      return [
        (days / 7).floor(),
        days % 7,
        value,
        distance,
      ];
    });

    List<int> dummy3 = List<int>.generate(transpose(data)[0].length,
        (index) => int.parse(transpose(data)[2][index].toString()));
    maxOfSummary = dummy3.reduce(max);
    print("year page, dummy3 : $maxOfSummary");

    // notifyListeners();
  }

  double floorDistance(double? distance) {
    if (distance == null) return 4;

    if (distance > 50) return 0;
    if (distance! > 20) return 1;
    if (distance! > 5) return 2;
    if (distance! > 1) return 3;
    return 4;
  }

  void setBottomNavigationBarShown(bool isBottomNavigationBarShown) {
    this.isBottomNavigationBarShown = isBottomNavigationBarShown;
    print("isBottomNavigationBarShown : $isBottomNavigationBarShown");
    notifyListeners();
  }

  void setLastNavigationIndex(int index) {
    lastNavigationIndex = index;
  }

  void setDate(DateTime date) {
    this.date = formatDate(date);
    print("date : ${this.date}");
  }


  void setZoomInRotationAngle(angle) {
    // print("provider set zoomInAngle to $angle");
    zoomInAngle = angle;
    notifyListeners();
  }

  void setZoomInState(isZoomIn) {
    print("provider set isZoomIn to $isZoomIn");
    this.isZoomIn = isZoomIn;
    notifyListeners();
  }

  void setYear(int year, {bool notify: false}) {
    print("provider set year to $year");
    this.year = year;
    setIndex(DateTime.now().year - year);
    updateData();

    if (notify) notifyListeners();
  }

  void setIndex(int index) {
    this.index = index;
  }

  @override
  void dispose() {
    print("provider disposed");
  }
}
