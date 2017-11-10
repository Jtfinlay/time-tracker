import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../components/timerWidget.dart';
import '../components/log_summary.dart';
import '../models/log.dart';

class TimerPage extends StatefulWidget {
  @override
  State createState() => new _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {

  DatabaseReference _logsDb;

  void onSubmitTime(int elapsedTime) {
    var log = new Log(
      elapsedTime: elapsedTime,
      timestamp: new DateTime.now()
    );

    Navigator.push(context, new MaterialPageRoute<Log>(
      builder: (BuildContext context) => new LogSummaryComponent(log)
    )).then((Log log) {
      // TODO
    });
  }

  @override
  void initState() {
    super.initState();

    _logsDb = FirebaseDatabase.instance.reference().child('logs');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        itemExtent: 366.0,
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        children: <Widget>[
          new TimerWidget(onSubmit: onSubmitTime)
        ],
      )
    );
  }
}