import 'package:flutter/material.dart';

class AlertFormTodo extends StatefulWidget {
  @override
  _AlertFormTodoState createState() => _AlertFormTodoState();
}

class _AlertFormTodoState extends State<AlertFormTodo> {
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Todo'),
      content: Column(
        children: <Widget>[
          Text('Bonjoor'),
        ],
      ),
    );
  }
}
