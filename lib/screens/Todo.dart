import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/databaseHelper.dart';
import 'package:armada/models/Project.dart';
import 'package:armada/models/Task.dart';
import 'package:armada/widgets/customAlert.dart';
import 'package:armada/widgets/todoALertChoose.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todo extends StatefulWidget {
  Todo({Key key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
//database
  Future<List<Task>> _taskList;
  Future<List<Project>> _projectList;

  int todayTaskNumber;

  @override
  void initState() {
    super.initState();
    getListOfTasks();
    getListOfProjects();
  }

  getListOfTasks() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTasksList();
    });
  }

  getListOfProjects() {
    setState(() {
      _projectList = DatabaseHelper.instance.getProjectsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    DateTime today = DateTime.now();
    // print('Today => $today');

    return Scaffold(
      backgroundColor: honey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // height: height * 0.2,
                color: honey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AdvanceCustomAlert();
                              });
                        }),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TodoAlertChoose();
                            });
                      },
                      label: Text(
                        "Add",
                        style: TextStyle(color: white),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 13,
                      ),
                      buildTitleRow("TODAY TASKS", todayTaskNumber),
                      SizedBox(
                        height: 13,
                      ),
                      FutureBuilder<List<Task>>(
                          future: _taskList,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            // WidgetsBinding.instance
                            //     .addPostFrameCallback((timeStamp) {
                            //   setState(() {
                            //     todayTaskNumber = snapshot.data.length;
                            //   });
                            // });

                            if (snapshot.data.length == 0) {
                              return Center(
                                child: Text('No Tasks for today!!'),
                              );
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Task snap = snapshot.data[index];

                                  if (snap.start.month == today.month &&
                                      snap.start.day == today.day) {
                                    return buildClassItem(snap);
                                  }

                                  return SizedBox(
                                    height: 0,
                                  );
                                });
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      buildTitleRow("YOUR Projects", 4),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<List<Project>>(
                          future: _projectList,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            // WidgetsBinding.instance
                            //     .addPostFrameCallback((timeStamp) {
                            //   setState(() {
                            //     todayTaskNumber = snapshot.data.length;
                            //   });
                            // });

                            if (snapshot.data.length == 0) {
                              return Center(
                                child: Text('No Projects!!'),
                              );
                            }

                            return Container(
                              height: height * 0.3,
                              width: width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Project snap = snapshot.data[index];

                                    // if (snap.start.month == today.month &&
                                    //     snap.start.day == today.day) {
                                    // print('chosen snap ${snap.title}');
                                    return buildTaskItem(
                                        3,
                                        "The Basic of Typography II",
                                        Colors.red,
                                        snap);

                                    // print(' No chosen snap ${snap.start}');

                                    // return SizedBox(
                                    //   height: 0,
                                    // );
                                  }),
                            );
                          }),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTaskItem(
      int numDays, String courseTitle, Color color, Project task) {
    int deadline = task.end.difference(DateTime.now()).inDays;
    Color deadLineColor = deadline < 3 ? color : Colors.green;

    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(12),
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: task.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deadline",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  color: deadLineColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '$deadline days left',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: deadLineColor),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            // width: 100,
            child: Text(
              task.title,
              // overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 100,
            child: Text(
              task.note,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: darkgrey),
            ),
          ),
        ],
      ),
    );
  }

  Row buildTitleRow(String title, int number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: number != null ? "($number)" : '-',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ]),
        ),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => TodoForm()));
        //   },
        //   child: Text(
        //     "Add Task",
        //     style: TextStyle(
        //         fontSize: 12,
        //         color: Color(0XFF3E3993),
        //         fontWeight: FontWeight.bold),
        //   ),
        // )
      ],
    );
  }

  Container buildClassItem(Task task) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(right: 10, top: 0, bottom: 0),
      height: 100,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: double.infinity,
            decoration: BoxDecoration(
                color: task.color,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(30))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('kk:mm ').format(task.start),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: white),
                    ),
                    Text(
                      DateFormat('a').format(task.start),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('kk:mm ').format(task.end),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: white),
                    ),
                    Text(
                      DateFormat('a').format(task.end),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 1,
            color: Colors.grey.withOpacity(0.5),
            margin: EdgeInsets.only(right: 10),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 160,
                child: Text(
                  task.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      "${task.note}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
