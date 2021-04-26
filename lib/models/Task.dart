import 'package:flutter/material.dart';

class Task {
  int id;
  String title;
  String note;
  String type;
  DateTime start;
  DateTime end;
  Color color;

  Task({this.title, this.note, this.type, this.start, this.end, this.color});
  Task.withId(
      {this.id,
      this.title,
      this.note,
      this.type,
      this.start,
      this.end,
      this.color});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['note'] = note;

    map['type'] = type;
    map['start'] = start.toIso8601String();
    map['end'] = end.toIso8601String();
    map['color'] = color.value;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      type: map['type'],
      start: DateTime.parse(map['start']),
      end: DateTime.parse(map['end']),
      color: new Color(map['color']),
    );
  }

  Color convertColor(String color) {
    // String colorString = color.toString(); // Color(0x12345678)
    String valueString =
        color.split('(0xff')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = new Color(value);
    print('new color $otherColor.toString()');
    return otherColor;
  }
}
