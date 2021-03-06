import 'package:flutter/material.dart';

class Project {
  int id;
  String title;
  String note;
  DateTime start;
  DateTime end;
  Color color;

  Project({this.title, this.note, this.start, this.end, this.color});
  Project.withId(
      {this.id, this.title, this.note, this.start, this.end, this.color});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['note'] = note;

    map['start'] = start.toIso8601String();
    map['end'] = end.toIso8601String();
    map['color'] = color.value;
    return map;
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project.withId(
      id: map['id'],
      title: map['title'],
      note: map['note'],
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
