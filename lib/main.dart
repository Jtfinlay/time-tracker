import 'package:flutter/material.dart';

import 'timerWidget.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Stool Tracker',
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Stool Tracker')),
        body: new TimerWidget()
    );
  }


}

