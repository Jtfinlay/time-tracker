import 'package:flutter/material.dart';

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

  Widget _timerWidget() {
    return new Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
                '0:00',
                style: Theme.of(context).textTheme.display2
            ),
            new IconButton(
              icon: new Icon(Icons.play_arrow),
              iconSize: 48.0,
              color: Colors.blue,
              tooltip: 'Start timer',
              onPressed: () { print('onPressed'); },
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Stool Tracker')),
        body: _timerWidget()
    );
  }


}

