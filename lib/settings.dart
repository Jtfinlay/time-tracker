import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'job_data.dart';
import 'salary_edit.dart';

class _SalaryDialogOption extends StatelessWidget {
  _SalaryDialogOption({
    Key key,
    this.job
  }) : super(key: key);

  final JobData job;

  void _addNewSalary(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<JobData>(
        builder: (BuildContext context) => new SalaryEditWidget(job)
    )).then((JobData result) {
//      print('Push result: ${result.title}');
    });

  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, null);
        _addNewSalary(context);
      },
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          (job == null)
              ? new Icon(Icons.add_circle, size: 36.0, color: Colors.blue)
              : new Icon(Icons.work, size: 36.0, color: Colors.blue),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Text((job == null) ? 'add new salary' : job.title),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  State createState() => new SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  final dialogChildren = <Widget>[];
  StreamSubscription<Event> _jobsSubscription;

  @override
  void initState() {
    super.initState();

    final jobsDb = FirebaseDatabase.instance.reference().child('jobs');

    dialogChildren.add(new _SalaryDialogOption());
    _jobsSubscription = jobsDb.orderByKey().onChildAdded.listen((Event event) {
      JobData job = new JobData.fromDb(event.snapshot.value);
      dialogChildren.insert(dialogChildren.length-1,
          new _SalaryDialogOption(job: job));
    });
  }

  @override
  void dispose() {
    _jobsSubscription.cancel();
    super.dispose();
  }

  void _manageSalaries(context) {
    showDialog(
        context: context,
        child: new SimpleDialog(
            title: new Text('Edit jobs'),
            children: dialogChildren
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