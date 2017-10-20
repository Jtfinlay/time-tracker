import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
        padding: new EdgeInsets.all(6.0),
        children: <Widget>[
          new ListTile(
              title: new Text('Salaries'),
              subtitle: new Text('Keep a list of your different work '
                'places and salaries for easy access.')
          ),
          new ListTile(
              title: new Text('Send Feedback'),
              subtitle: new Text('Any bugs or feedback? Notify the dev!')
          ),
        ]
    );
  }
}