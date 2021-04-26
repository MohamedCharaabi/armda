import 'package:armada/constants/theme.dart';
import 'package:armada/helpers/databaseHelper.dart';
import 'package:armada/models/Task.dart';
import 'package:armada/widgets/taskRow.dart';
import 'package:armada/widgets/todoForm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todo4 extends StatefulWidget {
  @override
  _Todo4State createState() => _Todo4State();
}

class _Todo4State extends State<Todo4> {
  //database
  Future<List<Task>> _taskList;

  @override
  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTasksListType('Important');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
      ),
      // height: 250,
      width: width,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(DateFormat.yMd().format(DateTime.now())),
                TextButton(
                  onPressed: () {
                    print('pressed');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TodoForm()));
                  },
                  child: Text('Add task'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: _taskList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  for (var item in snapshot.data) {
                    print('data $item  == ${item.title}');
                  }
                  print('snapshot ${snapshot.data.length}');
                  if (snapshot.data.length == 0) {
                    return Text('No data');
                  }

                  return Container(
                    height: 100,
                    width: width,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return TaskRow(
                            task: snapshot.data[index],
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
