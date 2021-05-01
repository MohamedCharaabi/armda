import 'package:armada/constants/theme.dart';
// import 'package:armada/helpers/databaseHelper.dart';
// import 'package:armada/models/Task.dart';
import 'package:armada/widgets/projectFormula.dart';
import 'package:armada/widgets/taskFormula.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:toggle_bar/toggle_bar.dart';

class TodoAlertChoose extends StatefulWidget {
  @override
  _TodoAlertChooseState createState() => _TodoAlertChooseState();
}

class _TodoAlertChooseState extends State<TodoAlertChoose> {
  // List<String> labels = ["My Day", "Importants", "Plan", "Tasks"];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: height * 0.5,
        // width: width,

        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Center(
              child: Column(
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProjectFormula()));
                },
                icon: Icon(
                  Icons.tab_rounded,
                  color: white,
                ),
                label: Text(
                  'Add Project',
                  style: TextStyle(color: white),
                ),
                style: TextButton.styleFrom(backgroundColor: red),
              ),
              SizedBox(
                height: 15,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TaskFormula()));
                  },
                  icon: Icon(
                    Icons.label,
                    color: white,
                  ),
                  label: Text(
                    'Add Task',
                    style: TextStyle(color: white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: red)),
            ],
          )),
        ),
      ),
    );
  }
}
