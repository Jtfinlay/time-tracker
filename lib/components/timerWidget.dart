import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';

class TimerWidget extends StatefulWidget {
  @override
  State createState() => new TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> with TickerProviderStateMixin{
  Timer _redrawTimer;
  Stopwatch _stopWatch;

  AnimationController _controller;
  Animation<double> _submitButtonAnimation;

  static const platform = const MethodChannel('finlay.io/timer');
  DatabaseReference _logsDb;

  @override
  void initState() {
    super.initState();

    _logsDb = FirebaseDatabase.instance.reference().child('logs');

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180)
    );
    _submitButtonAnimation = new CurvedAnimation(
        parent: _controller,
        curve: new Interval(0.0, 1.0, curve: Curves.linear)
    );
    _controller.reverse();

    _redrawTimer = new Timer.periodic(
        new Duration(milliseconds: 15),
        (Timer t) => setState(() {}));
    _stopWatch = new Stopwatch();
  }

  @override
  void dispose() {
    _stopWatch.stop();
    _redrawTimer.cancel();
    super.dispose();
  }

  Icon get _primaryButtonIcon => _isRunning
      ? new Icon(Icons.pause_circle_filled) : new Icon(Icons.play_circle_filled);

  MaterialColor get _primaryButtonColor => _isRunning
      ? Colors.orange : Colors.teal;

  String get _primaryButtonTooltip => _isRunning
      ? 'Pause timer' : 'Start timer';

  bool get _isRunning => _stopWatch.isRunning;

  startService() async {
    try {
      final String result = await platform.invokeMethod('start',
          _stopWatch.elapsedMilliseconds);
      print('Channel result: $result');
    } on PlatformException catch (e) {
      print('Exception thrown: ${e.message}');
    }
  }

  stopService() async {
    try {
      final String result = await platform.invokeMethod('stop');
      print('Channel result: $result');
    } on PlatformException catch (e) {
      print('Exception thrown: ${e.message}');
    }
  }

  void stop() {
    _stopWatch.stop();
    setState(() {});
    stopService();
  }

  void start() {
    _stopWatch.start();
    startService();
    setState(() {
      _controller.forward();
    });
  }

  void reset() {
    _stopWatch.stop();
    _stopWatch.reset();
    setState(() {
      _controller.reverse();
    });
  }

  void submit() {
    _stopWatch.stop();
    _logsDb.push().set({
      'elapsedTime': _stopWatch.elapsedMilliseconds,
      'timestamp': new DateTime.now(),
      'salaryId' : null,
      'salaryName' : null,
      'salarySalary': 0
    });
  }

  String prettifyElapsedTime() {
    String result = '';
    var duration = new Duration(milliseconds: _stopWatch.elapsedMilliseconds);

    var days = duration.inDays;
    duration -= new Duration(days: days);

    var hours = duration.inHours;
    duration -= new Duration(hours: hours);

    var minutes = duration.inMinutes;
    duration -= new Duration(minutes: minutes);

    var seconds = duration.inSeconds;
    duration -= new Duration(seconds: seconds);

    var ms = duration.inMilliseconds;

    if (days > 0)
    {
      result += '${days}d ${hours}h ';
    } else if (hours > 0) {
      result += '${hours}h ';
    }

    String formatMinutes = '';
    if (minutes == 0)       formatMinutes = '00';
    else if (minutes < 10)  formatMinutes = '0$minutes';
    else                    formatMinutes = '$minutes';

    String formatSeconds = '';
    if (seconds == 0)       formatSeconds = '00';
    else if (seconds < 10)  formatSeconds = '0$seconds';
    else                    formatSeconds = '$seconds';

    String formatMs = '';
    if (ms < 10)            formatMs = '00';
    else if (ms < 100)      formatMs = '0$ms'.substring(0,2);
    else                    formatMs = '$ms'.substring(0,2);

    result += '$formatMinutes:$formatSeconds.$formatMs';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
              prettifyElapsedTime(),
              style: Theme
                  .of(context)
                  .textTheme
                  .display2
          ),
          new IconButton(
              icon: _primaryButtonIcon,
              iconSize: 48.0,
              color: _primaryButtonColor,
              tooltip: _primaryButtonTooltip,
              onPressed: () => _isRunning ? stop() : start(),
          ),
          new ScaleTransition(
            scale: _submitButtonAnimation,
            child: new ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new RaisedButton(
                  child: const Text('DISCARD'),
                  onPressed: reset
                ),
                new RaisedButton(
                    child: const Text('SUBMIT'),
                    onPressed: submit
                ),
              ],
            )
          )
        ]
      )
    );
  }
}