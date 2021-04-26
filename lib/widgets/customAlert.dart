import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/databaseHelper.dart';
import 'package:armada/models/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toggle_bar/toggle_bar.dart';

class AdvanceCustomAlert extends StatefulWidget {
  @override
  _AdvanceCustomAlertState createState() => _AdvanceCustomAlertState();
}

class _AdvanceCustomAlertState extends State<AdvanceCustomAlert>
    with SingleTickerProviderStateMixin {
  var _calendarView = CalendarView.month;

  CalendarController _controller;

  AnimationController animationController;
  Animation degOneTranslationAnimamtion;
  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  //database
  Future<List<Task>> _taskList;

  @override
  void initState() {
    super.initState();
//database
    getListOfTasks();
//
    animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 250));
    degOneTranslationAnimamtion =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation =
        Tween<double>(begin: 180.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
    _controller = CalendarController();

    animationController.addListener(() {
      setState(() {});
    });
  }

  getListOfTasks() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTasksList();
    });
  }

  int currentIndex = 0;
  // List<String> labels = ["My Day", "Importants", "Plan", "Tasks"];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: height * 0.7,
        // width: width,

        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Center(
              child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: _taskList,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Center(
                      child: SfCalendar(
                        view: _calendarView,
                        controller: _controller,
                        dataSource: Meeting(getAppoinments(snapshot.data)),
                      ),
                    );
                  }),
              Container(
                height: height * 0.06,
                width: width,
                margin: EdgeInsets.only(left: 8, top: 15),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    List<String> calType = ['month', 'week', 'day', 'schedule'];
                    List<CalendarView> calView = [
                      CalendarView.month,
                      CalendarView.week,
                      CalendarView.day,
                      CalendarView.schedule
                    ];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _controller.view = calView[index];
                        });
                        // print('calendar type ==> $_calendarView');
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        height: 7,
                        width: 77,
                        child: Center(
                            child: Text(
                          calType[index],
                          style: TextStyle(color: white, fontSize: 18),
                        )),
                        decoration: BoxDecoration(
                            color: _controller.view == calView[index]
                                ? honey
                                : darkgrey,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}

List<Appointment> getAppoinments(List<Task> tasks) {
  List<Appointment> meetings = <Appointment>[];

  for (var task in tasks) {
    meetings.add(Appointment(
        startTime: task.start,
        endTime: task.end,
        subject: task.title,
        notes: task.note,
        color: task.color));
  }

  // final DateTime today = DateTime.now();
  // final DateTime startTime =
  //     DateTime(today.year, today.month, today.day, 9, 0, 0);
  // final DateTime endTime = startTime.add(const Duration(hours: 2));

  // meetings.add(Appointment(
  //     startTime: startTime,
  //     endTime: endTime,
  //     subject: 'Watch movie',
  //     color: red));

  return meetings;
}

class Meeting extends CalendarDataSource {
  Meeting(List<Appointment> source) {
    appointments = source;
  }
}
