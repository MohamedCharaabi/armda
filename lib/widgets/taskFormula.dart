import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/databaseHelper.dart';
import 'package:armada/helpers/notification.dart';
import 'package:armada/models/Project.dart';
import 'package:armada/models/Task.dart';
import 'package:armada/screens/Todo.dart';
import 'package:armada/widgets/btn.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:provider/provider.dart';

class TaskFormula extends StatefulWidget {
  Task task;
  TaskFormula({this.task});

  @override
  _TaskFormulaState createState() => _TaskFormulaState();
}

class _TaskFormulaState extends State<TaskFormula> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  Color selectedColor = Colors.lightGreen[300];

  Map<String, dynamic> formData = {
    'projectId': null,
    'note': '',
    'subject': '',
    'startTime': '',
    'endTime': '',
    'colorTime': 4282735204,
  };

  Future<List<Project>> _projectList;
  List<Project> _projects;

  @override
  void initState() {
    super.initState();
    _projectList = getListOfProjects();
    Provider.of<NotificationService>(context, listen: false).initialize();
  }

  getListOfProjects() {
    setState(() {
      _projectList = DatabaseHelper.instance.getProjectsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
        backgroundColor: honey,
        actions: [
          Consumer<NotificationService>(
            builder: (context, model, _) {
              return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => model.cancelNotification()
                  // Navigator.pop(context);

                  );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FormulaLabel(label: 'Task title'),
                      SizedBox(
                        height: 9,
                      ),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter Title',
                          hintStyle: TextStyle(color: darkgrey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Color(0xffe5e6ed), width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.green, width: 3),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormulaLabel(label: 'Task Note'),
                      SizedBox(
                        height: 9,
                      ),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 6,
                        decoration: InputDecoration(hintText: 'Enter Note'),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormulaLabel(label: 'Project'),
                      SizedBox(
                        height: 9,
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffbed1ff)),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff1d62ff),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.1,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: _projects?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  Project data = _projects[index];

                                  if (data == null) {
                                    return SizedBox(
                                      width: 0,
                                    );
                                  }

                                  return Container(
                                    height: 50,
                                    width: width * 0.25,
                                    margin: EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffbed1ff)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(data.title),
                                          Icon(Icons.close)
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      )
                      // FutureBuilder<List<Project>>(
                      //     future: DatabaseHelper.instance.getProjectsList(),
                      //     builder: (context, snapshot) {
                      //       if (!snapshot.hasData) {
                      //         return Center(child: CircularProgressIndicator());
                      //       }

                      //       // WidgetsBinding.instance
                      //       //     .addPostFrameCallback((timeStamp) {
                      //       //   setState(() {
                      //       //     todayTaskNumber = snapshot.data.length;
                      //       //   });
                      //       // });

                      //       if (snapshot.data.length == 0) {
                      //         return Center(
                      //           child: Text('No Projects!!'),
                      //         );
                      //       }

                      //       return Container(
                      //         height: height * 0.1,
                      //         width: width,
                      //         child: ListView.builder(
                      //             scrollDirection: Axis.horizontal,
                      //             itemCount: snapshot.data.length,
                      //             itemBuilder:
                      //                 (BuildContext context, int index) {
                      //               Project snap = snapshot.data[index];

                      //               // if (snap.start.month == today.month &&
                      //               //     snap.start.day == today.day) {
                      //               // print('chosen snap ${snap.title}');
                      //               return InputChip(
                      //                   avatar: Icon(Icons.remove),
                      //                   label: Text(snap.title));

                      //               // print(' No chosen snap ${snap.start}');

                      //               // return SizedBox(
                      //               //   height: 0,
                      //               // );
                      //             }),
                      //       );
                      //     }),

                      ,
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: height * 0.2,
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: width * 0.4,
                              height: height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FormulaLabel(label: 'Starts'),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Expanded(
                                    child: DateTimePicker(
                                      type: DateTimePickerType.dateTime,
                                      decoration: timePickerDecoration(),
                                      initialValue: DateTime.now().toString(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100),
                                      onSaved: (val) {
                                        print(val);
                                      },
                                      onChanged: (val) {
                                        formData = {
                                          ...formData,
                                          'startTime': val
                                        };
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width * 0.4,
                              height: height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FormulaLabel(label: 'Ends'),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    decoration: timePickerDecoration(),
                                    initialValue: DateTime.now().toString(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    onSaved: (val) {
                                      print(val);
                                    },
                                    onChanged: (val) {
                                      formData = {...formData, 'endTime': val};
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) => Material(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    OColorPicker(
                                      selectedColor: selectedColor,
                                      colors: primaryColorsPalette,
                                      onColorChange: (color) {
                                        setState(() {
                                          selectedColor = color;
                                        });
                                        formData = {
                                          ...formData,
                                          'colorTime': color.value
                                        };

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            child: Text(
                              'Choose Color',
                              style: TextStyle(color: white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(red),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 25,
                            width: 25,
                            color: selectedColor,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.11,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Container(
                width: width,
                height: height * 0.1,
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ButtonWidget(
                    text: 'Create Task', onClicked: _submitFormular)),
          ),
        ],
      ),
    );
  }

  InputDecoration timePickerDecoration() {
    return InputDecoration(
      // hintText: 'Enter Title',
      hintStyle: TextStyle(color: darkgrey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xffe5e6ed), width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.green, width: 3),
      ),
    );
  }

  _submitFormular() async {
    // formData = {
    //   ...formData,
    //   'subject': _titleController.text,
    //   'note': _noteController.text
    // };
    // print(formData);

    Task task = Task(
      title: _titleController.text,
      note: _noteController.text,
      // type: formData['type'],
      start: DateTime.parse(formData['startTime'] ?? DateTime.now()),
      end: DateTime.parse(
          formData['endTime'] ?? DateTime.now().add(const Duration(days: 2))),
      color: Color(formData['colorTime']),
    );

    if (widget.task == null) {
      //insert task
      int result = await DatabaseHelper.instance.insertTask(task);

      // result == 1
      //     ? Fluttertoast.showToast(
      //         msg: 'Your task created successfuly',
      //         toastLength: Toast.LENGTH_SHORT)
      //     : Fluttertoast.showToast(
      //         msg: 'Failed to submit your task ',
      //         toastLength: Toast.LENGTH_SHORT);

      print('result insert ===  $result');
    } else {
      //update Task
      DatabaseHelper.instance.updateTask(task);
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Todo()));
  }
}

class FormulaLabel extends StatelessWidget {
  final String label;
  const FormulaLabel({
    Key key,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
