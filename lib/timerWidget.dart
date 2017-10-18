import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  @override
  State createState() => new TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  Stopwatch _stopWatch;

  var _actionIcon = Icons.play_arrow;
  var _actionColor = Colors.blue;
  var _toolTip = 'Start timer';

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller = new AnimationController(
          duration: const Duration(milliseconds: 1500), vsync: this);
      _animation = new Tween(begin: 0.0, end: 300.0).animate(_controller)
        ..addListener(() {
          print('listener invoked');
          setState(() {
            // ...
          });
        });
      _controller.forward();

      _stopWatch = new Stopwatch();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _stopWatch.start();

    _actionIcon = Icons.stop;
    _actionColor = Colors.red;
    _toolTip = 'Stop timer';
  }

  void _stopTimer() {
    _stopWatch.stop();

    _actionIcon = Icons.play_arrow;
    _actionColor = Colors.blue;
    _toolTip = 'Start timer';
  }

  void _actionButtonPressed() {
    print('is controller null: ${_controller}');
    setState(() {
      print('is controller null: ${_animation}');
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
        child: new Container(
            height: 400.0,//_animation.value,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                      '${(_stopWatch.elapsedMilliseconds / 1000).toString()}s - Animation: ${_animation == null}',
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
        )
    );
  }
}