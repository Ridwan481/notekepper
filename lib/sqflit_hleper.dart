import 'package:note_keper/sqflit_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';
import 'main.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = "Courses.db";
  static const String CourseID = 'CourseID';
  static const String CourseName = 'CourseName';
  static const String TABLE = 'Courses';
  static const String Time = 'Time';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($CourseID INTEGER PRIMARY KEY, $CourseName TEXT, $Time TEXT)");
  }

  Future<Courses> save(Courses Cr) async {
    var dbCourses = await db;
    Cr.courseID = await dbCourses.insert(TABLE, Cr.toMap());
    return Cr;
  }

  Future<List<Courses>> getCourses() async {
    var dbCourses = await db;
    List<Map> maps = await dbCourses.rawQuery("SELECT * FROM $TABLE");
    List<Courses> CoursesArr = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        CoursesArr.add(Courses.fromMap(maps[i]));
      }
    }
    return CoursesArr;
  }

  Future close() async {
    var dbCourse = await db;
    dbCourse.close();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE, where: '$CourseID = ?', whereArgs: [id]);
  }

  Future<int> update(Courses Cr) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, Cr.toMap(),
        where: '$CourseID = ?', whereArgs: [Cr.courseID]);
  }

  Future getMaxID() async {
    var dbClient = await db;
    var Query =
        await dbClient.rawQuery("SELECT MAX(CourseID)+1 as LID FROM $TABLE");
    if (Query.first["LID"] == null) {
      CourseIDController.text = "1";
    } else {
      CourseIDController.text = Query.first["LID"].toString();
    }
  }
}
