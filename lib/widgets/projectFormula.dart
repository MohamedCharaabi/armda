import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/databaseHelper.dart';
import 'package:armada/models/Project.dart';
import 'package:armada/screens/Todo.dart';
import 'package:armada/widgets/btn.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:o_color_picker/o_color_picker.dart';

class ProjectFormula extends StatefulWidget {
  Project project;
  ProjectFormula({this.project});

  @override
  _ProjectFormulaState createState() => _ProjectFormulaState();
}

class _ProjectFormulaState extends State<ProjectFormula> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  Color selectedColor = Colors.lightGreen[300];

  Map<String, dynamic> formData = {
    // 'type': 'Projects',

    'note': '',
    'subject': '',
    'startTime': '',
    'endTime': '',
    'colorTime': 4282735204,
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Project'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
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
                      FormulaLabel(label: 'Project title'),
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
                      FormulaLabel(label: 'Project Note'),
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
                    text: 'Create project', onClicked: _submitFormular)),
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

    Project project = Project(
      title: _titleController.text,
      note: _noteController.text,
      // type: formData['type'],
      start: DateTime.parse(formData['startTime'] ?? DateTime.now()),
      end: DateTime.parse(
          formData['endTime'] ?? DateTime.now().add(const Duration(days: 2))),
      color: Color(formData['colorTime']),
    );

    if (widget.project == null) {
      //insert project
      int result = await DatabaseHelper.instance.insertProject(project);

      (result == 1) || (result == 2)
          ? Fluttertoast.showToast(
              msg: 'Your project created successfuly',
              toastLength: Toast.LENGTH_SHORT)
          : Fluttertoast.showToast(
              msg: 'Failed to submit your project ',
              toastLength: Toast.LENGTH_SHORT);

      print('result insert ===  $result');
    } else {
      //update Task
      DatabaseHelper.instance.updateProject(project);
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
