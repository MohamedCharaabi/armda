import 'package:armada/constants/theme.dart';
import 'package:armada/models/Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  TaskRow({@required this.task});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: task.color, borderRadius: BorderRadius.circular(20)),
      // height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(color: white),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DateFormat('yyyy-MM-dd hh:mm').format(task.start),
                    // task.start.toIso8601String(),
                    style: TextStyle(color: white),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd hh:mm').format(task.end),
                    style: TextStyle(color: white),
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                  icon: Icon(Icons.notification_important, color: white),
                  onPressed: null),
            ],
          ),
        ],
      ),
    );
  }
}
