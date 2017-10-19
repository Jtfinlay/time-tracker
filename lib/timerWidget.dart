import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerWidget extends StatefulWidget {
  @override
  State createState() => new TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Stopwatch _stopWatch;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 15), vsync: this)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.value = 0.0;
          _controller.forward();
        }
        setState(() {});
      })
      ..forward();

    _stopWatch = new Stopwatch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Icon get _primaryButtonIcon => _isRunning
      ? new Icon(Icons.pause_circle_filled) : new Icon(Icons.play_circle_filled);

  MaterialColor get _primaryButtonColor => _isRunning
      ? Colors.orange : Colors.blue;

  String get _primaryButtonTooltip => _isRunning
      ? 'Pause timer' : 'Start timer';

  bool get _isRunning => _stopWatch.isRunning;

  bool get _isResetButtonVisible => _stopWatch.elapsedMilliseconds > 0;

  void stop() {
    _stopWatch.stop();
    setState(() {});
  }

  void start() {
    _stopWatch.start();
    setState(() {});
  }

  void reset() {
    _stopWatch.stop();
    _stopWatch.reset();
    setState(() {});
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

    result += '${formatMinutes}:${formatSeconds}.${formatMs}';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Stack(
            children: <Widget>[
              new Align(
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
                  ]
                )
              ),
              new Align(
                alignment: Alignment.bottomCenter,
                child: _isResetButtonVisible ? new IconButton(
                    icon: new Icon(Icons.replay),
                    iconSize: 48.0,
                    color: Colors.blue,
                    tooltip: 'Reset timer',
                    onPressed: reset,
                    ) : new Container(),
              ),
            ],
          ),
        );
  }
}