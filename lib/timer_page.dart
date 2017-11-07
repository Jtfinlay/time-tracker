import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'timerWidget.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        itemExtent: 366.0,
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        children: <Widget>[
          new TimerWidget()
        ],
      )
    );
  }
}