import 'package:armada/widgets/todoForms/importantForm.dart';
import 'package:armada/widgets/todoForms/myDayForm.dart';
import 'package:armada/widgets/todoForms/plan.dart';
import 'package:armada/widgets/todoForms/task.dart';
import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  // int currentindex = 0;
  // List<Widget> forms = [MyDayForm(), ImportantForm(), Plan(), Tasks()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Container(
                  child: MyDayForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
