import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'salary_edit.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  void _addNewSalary(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<DismissDialogAction>(
        builder: (BuildContext context) => new SalaryEditWidget()
    ));
  }

  void _manageSalaries(context) {
    showDialog(
        context: context,
        child: new SimpleDialog(
            title: new Text('Edit jobs'),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, null);
                  _addNewSalary(context);
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Icon(Icons.add_circle, size: 36.0, color: Colors.blue),
                    new Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: new Text('add new salary'),
                    ),
                  ],
                ),
              ),
            ],
        )
    );
  }

  void _sendFeedback() {
    print('Send Feedback');
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
        padding: new EdgeInsets.all(6.0),
        children: <Widget>[
          new ListTile(
              title: new Text('Salaries'),
              subtitle: new Text('Keep a list of your different work '
                  'places and salaries for easy access.'),
              onTap: () => _manageSalaries(context),
              ),
          new ListTile(
              title: new Text('Send Feedback'),
              subtitle: new Text('Any bugs or feedback? Notify the dev!'),
              onTap: _sendFeedback,
              ),
        ]
    );
  }
}