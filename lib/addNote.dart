import 'package:flutter/material.dart';
import 'package:note_keper/Homepage.dart';
import 'package:note_keper/real_TimeStamp.dart';
import 'package:note_keper/sqflit_hleper.dart';
import 'package:note_keper/sqflit_model.dart';

class AddNote extends StatefulWidget {
  final String bartitle;

  const AddNote({Key key, this.bartitle}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

var dbHelper;
String name;
var time = DateTime.now();
final formKey = GlobalKey<FormState>();
Future<List<Courses>> coursesLst;

class _AddNoteState extends State<AddNote> {
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshList();
  }

  void validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Courses e = Courses(null, name, time.toString());
      dbHelper.save(e);
      dbHelper.update(e);

      CourseNameController.text = "";
      Navigator.pop(context);
      refreshList();
    }
  }

  void refreshList() {
    setState(() {
      coursesLst = dbHelper.getCourses();
      dbHelper.getMaxID();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bartitle),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Note ID:"),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.exposure_plus_1),
                ),
                enabled: false,
                controller: CourseIDController,
              ),
              Text("Note Name:"),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.add),
                  hintText: "Course Name",
                ),
                controller: CourseNameController,
                keyboardType: TextInputType.text,
                validator: (val) => val.length == 0 ? 'Enter Name' : null,
                onSaved: (val) => name = val,
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    widget.bartitle,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: validate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
