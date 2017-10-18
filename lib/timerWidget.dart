import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  State createState() => new TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  var _actionIcon = Icons.play_arrow;
  var _actionColor = Colors.blue;
  var _toolTip = 'Start timer';
  var _isTimerRunning = false;

  void _actionButtonPressed() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
      if (_isTimerRunning) {
        _actionIcon = Icons.stop;
        _actionColor = Colors.red;
        _toolTip = 'Stop timer';
      } else {
        _actionIcon = Icons.play_arrow;
        _actionColor = Colors.blue;
        _toolTip = 'Start timer';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                  '0:00',
                  style: Theme.of(context).textTheme.display2
              ),
              new IconButton(
                  icon: new Icon(_actionIcon),
                  iconSize: 48.0,
                  color: _actionColor,
                  tooltip: _toolTip,
                  onPressed: _actionButtonPressed,
                  ),
            ],
            )
    );
  }
}