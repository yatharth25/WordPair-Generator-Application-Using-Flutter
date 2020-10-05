import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final String name;
  final func;
  LoadingButton({@required this.name, @required this.func});

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        minWidth: double.infinity,
        height: 60,
        onPressed: () {
          setState(() {
            if (_state == 0) {
              animateButton();
            }
          });
          widget.func;
        },
        color: Colors.purple[900],
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: setUpButtonChild());
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        widget.name,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
