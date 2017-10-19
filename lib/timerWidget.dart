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

  var _actionIcon = Icons.play_circle_filled;
  var _actionColor = Colors.blue;
  var _toolTip = 'Start timer';

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

  bool _isRunning() => _stopWatch.isRunning;

  bool _isResetButtonVisible() => _stopWatch.elapsedMilliseconds > 0;

  void _stop() {
    _stopWatch.stop();

    _actionIcon = Icons.play_circle_filled;
    _actionColor = Colors.blue;
    _toolTip = 'Start timer';

    setState(() {});
  }

  void _start() {
    _stopWatch.start();

    _actionIcon = Icons.stop;
    _actionColor = Colors.red;
    _toolTip = 'Stop timer';

    setState(() {});
  }

  void _reset() {
    _stop();
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
                        icon: new Icon(_actionIcon),
                        iconSize: 48.0,
                        color: _actionColor,
                        tooltip: _toolTip,
                        onPressed: () => _isRunning() ? _stop() : _start(),
                        ),
                  ]
                )
              ),
              new Align(
                alignment: Alignment.bottomCenter,
                child: _isResetButtonVisible() ? new IconButton(
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


//      child: new Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          new Text(
//              '${(_stopWatch.elapsedMilliseconds / 1000).toString()}s',
//              style: Theme.of(context).textTheme.display2
//          ),
//          new IconButton(
//              icon: new Icon(_actionIcon),
//              iconSize: 48.0,
//              color: _actionColor,
//              tooltip: _toolTip,
//              onPressed: () => _isRunning() ? _stop() : _start(),
//              ),
//          new Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new FloatingActionButton(
//                onPressed: _reset,
//                tooltip: 'Reset timer',
//                child: new Icon(Icons.replay),
//              ),
//            ],
//          ),
//          _isResetButtonVisible() ? new IconButton(
//              icon: new Icon(Icons.replay),
//              iconSize: 48.0,
//              color: Colors.blue,
//              tooltip: 'Reset timer',
//              onPressed: _reset,
//              ) : new Container(),
  }
}