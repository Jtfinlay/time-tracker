import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  State createState() => new TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  final _stopWatch = new Stopwatch();
  var _actionIcon = Icons.play_arrow;
  var _actionColor = Colors.blue;
  var _toolTip = 'Start timer';

  void _startTimer() {
    print('start timer: ${_stopWatch.elapsedMilliseconds}');
    _stopWatch.start();

    _actionIcon = Icons.stop;
    _actionColor = Colors.red;
    _toolTip = 'Stop timer';
  }

  void _stopTimer() {
    print('stop timer: ${_stopWatch.elapsedMilliseconds}');
    _stopWatch.stop();

    _actionIcon = Icons.play_arrow;
    _actionColor = Colors.blue;
    _toolTip = 'Start timer';
  }

  void _actionButtonPressed() {
    setState(() {
      print('action button. Running: ${_stopWatch.isRunning}');
      if (_stopWatch.isRunning) {
        _stopTimer();
      } else {
        _startTimer();
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