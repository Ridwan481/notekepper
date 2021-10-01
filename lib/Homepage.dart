import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_keper/addNote.dart';

import 'package:note_keper/sqflit_hleper.dart';
import 'package:note_keper/sqflit_model.dart';

var CourseNameController = TextEditingController();
var CourseIDController = TextEditingController();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Courses>> CoursesLst;

  String name;
  int curUserId;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
    print(dbHelper.getMaxID());
  }

//refresh the application
  void refreshList() {
    setState(() {
      CoursesLst = dbHelper.getCourses();
      dbHelper.getMaxID();
    });
  }

  var time = DateTime.now().millisecondsSinceEpoch;

  //Body of Application
  Widget dataTable(List<Courses> crsLst) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: crsLst
            .map((e) => Card(
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          e.courseID.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(e.courseName),
                      subtitle: Text(e.Time.toString()),
                      onTap: () {
                        setState(() {
                          curUserId = e.courseID;
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddNote(
                                  bartitle: 'Update',
                                )));
                        CourseNameController.text = e.courseName;
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          dbHelper.delete(e.courseID);
                          refreshList();
                        },
                      )),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(
                    bartitle: 'Add Note',
                  )));
        },
        child: Icon(Icons.add),
      ),
      appBar: new AppBar(
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: refreshList)
        ],
        title: new Text('NoteKepper'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Press the Refresh boutton to see New Added note'),
          ),
          FutureBuilder(
              future: CoursesLst,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return dataTable(snapshot.data);
                } else {
                  return Center(child: Text('No Note To show yet'));
                }
              })
        ],
      ),
    );
  }
}
