import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/databaseHelper.dart';
import 'package:armada/models/Task.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:o_color_picker/o_color_picker.dart';
import 'package:toggle_bar/toggle_bar.dart';

class MyDayForm extends StatefulWidget {
  Task task;
  MyDayForm({Key key, this.task}) : super(key: key);

  @override
  _MyDayFormState createState() => _MyDayFormState();
}

class _MyDayFormState extends State<MyDayForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  Color selectedColor = Colors.lightGreen[300];

  List<String> type = ['Projects', 'Important', 'plan', 'tasks'];

  Map<String, dynamic> formData = {
    'type': 'Projects',
    'note': '',
    'subject': '',
    'startTime': '',
    'endTime': '',
    'colorTime': 4282735204,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ToggleBar(
                    labels: type,
                    onSelectionUpdated: (index) {
                      setState(() {
                        formData = {...formData, 'type': type[index]};
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _titleController,
                    maxLines: 2,
                    decoration: InputDecoration(hintText: 'Enter title'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 6,
                    decoration: InputDecoration(hintText: 'Enter Note'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Enter Start Date'),
                  SizedBox(
                    height: 1,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    onSaved: (val) {
                      print(val);
                    },
                    onChanged: (val) {
                      formData = {...formData, 'startTime': val};
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Enter End Date'),
                  SizedBox(
                    height: 1,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
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
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      formData = {
                        ...formData,
                        'subject': _titleController.text,
                        'note': _noteController.text
                      };
                      print(formData);
                      // debugPrint('${Color(formData['colorTime'])}');
                      _submit();
                    },
                    child: Text('Submit'),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(horizontal: 100.0)),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(litegrey)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit() async {
    Task task = Task(
      title: formData['subject'],
      note: formData['note'],
      type: formData['type'],
      start: DateTime.parse(formData['startTime']),
      end: DateTime.parse(formData['endTime']),
      color: Color(formData['colorTime']),
    );

    if (widget.task == null) {
      //insert task
      int result = await DatabaseHelper.instance.insertTask(task);

      print('result insert ===  $result');
    } else {
      //update Task
      DatabaseHelper.instance.updateTask(task);
    }

    Navigator.pop(context);
  }
}
