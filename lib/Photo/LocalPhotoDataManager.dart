import 'package:exif/exif.dart';
import 'package:glob/list_local_fs.dart';
import 'package:test_location_2nd/Util/DateHandler.dart';
import 'package:test_location_2nd/Util/responseParser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:test_location_2nd/Data/DataManager.dart';
import 'package:glob/glob.dart';
import 'package:test_location_2nd/Util/global.dart';

String _pathToLocalPhotoGallery1 = "/storage/emulated/0/DCIM/Camera";
String _pathToLocalPhotoGallery2 = "/storage/emulated/0/Pictures";
String _pathToLocalPhotoGallery3 = "/storage/emulated/0/Pictures/*";


enum filetypes {
  jpg,
  png,
}

class LocalPhotoDataManager {
  List photoDataAll = [];
  List<String> dates = [];
  List<String> files = [];
  List modifiedDatesOfFiles = [];

  LocalPhotoDataManager() {
    init();
  }
  Future init() async {
    files = await getAllFiles();
    modifiedDatesOfFiles = getDatesFromFilnames(files);
  }

  static Future getPhotoOfDate_static(String date) async {
    List files = [];
    List cTimes = [];
    final filesFromPath1_png =
        await Glob("$_pathToLocalPhotoGallery1/*${date}*.png").listSync();
    final filesFromPath2_png =
        await Glob("$_pathToLocalPhotoGallery2/*${date}*.png").listSync();
    final filesFromPath1_jpg =
        await Glob("$_pathToLocalPhotoGallery1/*${date}*.jpg").listSync();
    final filesFromPath2_jpg =
        await Glob("$_pathToLocalPhotoGallery2/*${date}*.jpg").listSync();
    final filesFromPath3_jpg =
    await Glob("$_pathToLocalPhotoGallery3/*${date}*.jpg").listSync();

    //delyay is introduced to avoid slow down in ui
    await Future.delayed(Duration(milliseconds: 100));
    files.addAll(filesFromPath1_png);
    files.addAll(filesFromPath2_png);
    files.addAll(filesFromPath1_jpg);
    files.addAll(filesFromPath2_jpg);
    files.addAll(filesFromPath3_jpg);

    //cTime of DateTime is converted to string
    cTimes.addAll(List.generate(
        files.length,
        (index) => DateFormat("yyyyMMdd_HHmmss")
            .format(FileStat.statSync(files.elementAt(index).path).accessed)));
    print("files during GetPhotoOfDate : $files");
    files = List.generate(files.length, (index) => files.elementAt(index).path);
    return [cTimes, files];
  }

  Future getPhotoOfDate(String date) async {
    List files = [];
    List cTimes = [];
    List files_new = [];
    final filesFromPath1_png =
        await Glob("$_pathToLocalPhotoGallery1/*${date}*.png").listSync();
    final filesFromPath2_png =
        await Glob("$_pathToLocalPhotoGallery2/*${date}*.png").listSync();
    final filesFromPath1_jpg =
        await Glob("$_pathToLocalPhotoGallery1/*${date}*.jpg").listSync();
    final filesFromPath2_jpg =
        await Glob("$_pathToLocalPhotoGallery2/*${date}*.jpg").listSync();
    final filesFromPath3_jpg =
    await Glob("$_pathToLocalPhotoGallery3/*${date}*.jpg").listSync();

    files.addAll(filesFromPath1_png);
    files.addAll(filesFromPath2_png);
    files.addAll(filesFromPath1_jpg);
    files.addAll(filesFromPath2_jpg);
    files.addAll(filesFromPath3_jpg);

    //cTime of DateTime is converted to string
    for (int i = 0; i < files.length; i++) {
      var bytes = await File(files.elementAt(i).path).readAsBytes();
      var data = await readExifFromBytes(bytes);
      // print("date of photo : ${data['Image DateTime'].toString().replaceAll(":", "")}");
      String dateInExif = data['Image DateTime'].toString().replaceAll(":", "");

      print("getPhotoOfDate $i, ${dateInExif}");
      //exclude the images without exif data
      if (dateInExif == "null") continue;

      String date =
          DateFormat("yyyyMMdd_HHmmss").format(DateTime.parse(dateInExif));
      cTimes.add(date);
      files_new.add(files.elementAt(i).path);
    }
    print("files during GetPhotoOfDate : $cTimes");
    // files = List.generate(files.length, (index)=> files.elementAt(index).path);
    return [cTimes, files_new];
  }

  Future<String> getExifDateOfFile(String file) async {
    var bytes = await File(file).readAsBytes();
    var data = await readExifFromBytes(bytes);
    // print("date of photo : ${data['Image DateTime'].toString().replaceAll(":", "")}");
    String dateInExif = data['Image DateTime'].toString().replaceAll(":", "");
    return dateInExif;
  }


  Future getAllFiles() async {
    List<String> files = [];
    final filesFromPath1_png =
        await Glob("$_pathToLocalPhotoGallery1/*.png").listSync();
    final filesFromPath2_png =
        await Glob("$_pathToLocalPhotoGallery2/*.png").listSync();
    final filesFromPath1_jpg =
        await Glob("$_pathToLocalPhotoGallery1/*.jpg").listSync();
    final filesFromPath2_jpg =
        await Glob("$_pathToLocalPhotoGallery2/*.jpg").listSync();
    final filesFromPath3_jpg =
    await Glob("$_pathToLocalPhotoGallery3/*.jpg").listSync();

    print("getAllFiles, filesFromPath3 : ${filesFromPath3_jpg}");
    files.addAll(List.generate(filesFromPath1_png.length,
        (index) => filesFromPath1_png.elementAt(index).path));
    files.addAll(List.generate(filesFromPath2_png.length,
        (index) => filesFromPath2_png.elementAt(index).path));
    files.addAll(List.generate(filesFromPath1_jpg.length,
        (index) => filesFromPath1_jpg.elementAt(index).path));
    files.addAll(List.generate(filesFromPath2_jpg.length,
        (index) => filesFromPath2_jpg.elementAt(index).path));
    files.addAll(List.generate(filesFromPath3_jpg.length,
            (index) => filesFromPath3_jpg.elementAt(index).path));
    return files;
  }


  void test(){
    print('test function');
    print("test : ${files}");
    // print(getDatesFromFilnames(files));
    getDatesFromFilnames(files);
    print(modifiedDatesOfFiles);
  }

  List getDatesFromFilnames(files){
    print("getDAtesFromFilenames : $files");

    List modifiedDatesOfFiles = List.generate(
        files.length, (index) =>
        inferDateFromFilename(files.elementAt(index)));

    print("getDatesFromFilenames : $modifiedDatesOfFiles");
    modifiedDatesOfFiles = List.generate(
      modifiedDatesOfFiles.length, (index) => modifiedDatesOfFiles.elementAt(index)?? formatDate(FileStat.statSync(files[index]).modified)
    );

    print("getDatesFromFilenames : $modifiedDatesOfFiles");
    // modifiedDatesOfFiles = List.generate(
    //   modifiedDatesOfFiles.length, (index) => formatDateString(modifiedDatesOfFiles.elementAt(index))
    // );
    print("getDatesFromFilenames : $modifiedDatesOfFiles");
    // modifiedDatesOfFiles.sort((a, b) => a.compareTo(b));
    // exifDateOfFiles.sort((a, b) => a.comparedTo(b));
    this.modifiedDatesOfFiles = modifiedDatesOfFiles;
    print("getDatesFromFilnames : $modifiedDatesOfFiles");
    return modifiedDatesOfFiles;
  }

  String? inferDateFromFilename(filename) {
    https://soooprmx.com/%EC%A0%95%EA%B7%9C%ED%91%9C%ED%98%84%EC%8B%9D%EC%9D%98-%EA%B0%9C%EB%85%90%EA%B3%BC-%EA%B8%B0%EC%B4%88-%EB%AC%B8%EB%B2%95/
    // RegExp exp = RegExp(r"[0-9]{8}\D?[0-9]{6}");
    RegExp exp1 = RegExp(r"[0-9]{8}\D");
    RegExp exp2 = RegExp(r"[0-9]{4}\D[0-9]{2}\D[0-9]{2}");
    RegExp exp3 = RegExp(r"[0-9]{13}");

    if(filename.contains("thumbnail")){
      return null;
    }

    Iterable<RegExpMatch> matches = exp3.allMatches(filename);
    if(matches.length!=0){
      var date = new DateTime.fromMicrosecondsSinceEpoch(int.parse(matches.first.group(0)!)*1000);
      return formatDate(date);
    }

    matches = exp1.allMatches(filename);
    if( matches.length!=0) {
      // print("${matches.first.group(0).toString().replaceAll(
      //     RegExp(r"[^0-9]"), "")}, $filename");
      return matches.first.group(0).toString().replaceAll(RegExp(r"[^0-9]") , "");
    }
    matches = exp2.allMatches(filename);
    if( matches.length!=0) {
      // print("${matches.first.group(0).toString().replaceAll(RegExp(r"[^0-9]"), "")}, $filename");
      return matches.first.group(0).toString().replaceAll(RegExp(r"[^0-9]"), "");
    }
    return null;
  }

  List getModifiedDatesOfFiles(files) {
    List modifiedDatesOfFiles = List.generate(
        files.length, (index) => FileStat.statSync(files[index]).modified);


    modifiedDatesOfFiles.sort((a, b) => a.compareTo(b));
    // exifDateOfFiles.sort((a, b) => a.comparedTo(b));
    this.modifiedDatesOfFiles = modifiedDatesOfFiles;
    // this.modifiedDatesOfFiles = exifDateOfFiles;
    return modifiedDatesOfFiles;
  }
}
