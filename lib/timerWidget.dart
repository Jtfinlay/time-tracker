import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

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

  void _stop() {
    _stopWatch.stop();
    setState(() {});
  }

  void _start() {
    _stopWatch.start();
    setState(() {});
  }

  void _reset() {
    _stopWatch.stop();
    _stopWatch.reset();
    setState(() {});
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
                        '${(_stopWatch.elapsedMilliseconds / 1000)
                            .toString()}s',
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
                        onPressed: () => _isRunning ? _stop() : _start(),
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
                    onPressed: _reset,
                    ) : new Container(),
              ),
            ],
          ),
        );
  }
}