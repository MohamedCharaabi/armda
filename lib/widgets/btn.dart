import 'package:armada/constants/theme.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        style: TextButton.styleFrom(
          elevation: 4,
          shape: StadiumBorder(),
          primary: white,
          shadowColor: red,
          backgroundColor: violet,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // textStyle: TextStyle(color: violet),
        ),
        onPressed: onClicked,
      );
}
