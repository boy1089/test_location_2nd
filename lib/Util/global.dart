import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

DateTime selectedDate = DateTime(2022, 1, 1);

int mainPageSelectionIndex = 0;

Map<String, int> summaryOfPhotoData = {};
Map<String, int> summaryOfNoteData = {};

//Colors
Color kBackGroundColor = Colors.white;

// Color kMainColor_warm = Colors.deepOrangeAccent;
// Color kMainColor_cool = Colors.white.withAlpha(240);
// Color kMainColor_option = Colors.green.withAlpha(180);

// Color kMainColor_warm = Color.fromARGB(200, 100, 100, 100);
// Color kMainColor_warm = Color.fromARGB(255, 255, 203, 196); //peach color1
Color kMainColor_warm = Color.fromARGB(255, 255, 167, 166); //peach color2
// Color kMainColor_cool = Color.fromARGB(255, 108, 245, 151); // complementary of peach color2;
// Color kMainColor_cool = Color.fromARGB(255, 149, 166, 230); // complementary of peach color2;
// Color kMainColor_cool = Color.fromARGB(255, 166, 166, 255);
Color kMainColor_cool = Color.fromARGB(255, 190, 194, 255);


// Color kMainColor_cool = Colors.white.withOpacity(0.8);
Color kMainColor_option = Colors.green.withAlpha(180);


Color kColor_grey = Colors.black12.withAlpha(10);
Color kColor_white = Colors.white.withOpacity(0.85);
Color kColor_container = Colors.black12.withAlpha(10);
Color kColor_containerFocused = Colors.white.withAlpha(150);
Color kColor_backgroundText = Colors.black45;
Color kColor_diaryText = Colors.black87;

Color kColor_polarPlotOutline = Colors.black12;
Color kColor_polarPlotPhotoScatter = kMainColor_warm;


Color kColor_badge = Color.fromARGB(255, 80, 90, 235);


FontWeight kFontWeight_diaryContents = FontWeight.w400;
FontWeight kFontWeight_diaryTitle = FontWeight.w700;

double kSize_polarPlotPhotoScatter = 5;

const event_color_goingOut = Colors.red;
const event_color_backHome = Colors.blue;


List<Color> get colorsHotCold => [
      Colors.deepOrangeAccent,
      Colors.blue,
    ];

int indexForZoomInImage = -1;
bool isImageClicked = false;

int animationTime = 200;
double monthPageScrollOffset = 0.0;

int startYear = 2013;

double kMinimumTimeDifferenceBetweenImages = 0.05; //unit is hour

GoogleSignInAccount? currentUser;

double value = 0.8;
double value2 = 0.6;
List<List<dynamic>> dummyData1 = [
  [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [1.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [2.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [3.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [4.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [5.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [6.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [7.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [8.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [9.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [10.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [11.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [12.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [13.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [14.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [15.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [16.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [17.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [18.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [19.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [20.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [21.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [22.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [23.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [24.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
];

List<List<dynamic>> dummyData2 = [
  [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
  [0.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [1.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [2.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [3.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [4.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [5.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [6.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [7.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [8.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [9.0, value, 0.0, 0.0, 0.0, 0.0, 0.0],
  [10.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [11.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [12.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [13.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [14.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [15.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [16.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [17.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [18.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [19.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [20.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [21.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [22.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [23.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
  [24.0, value2, 0.0, 0.0, 0.0, 0.0, 0.0],
];
