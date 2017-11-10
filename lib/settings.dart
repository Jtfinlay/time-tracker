import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'job_data.dart';
import 'salary_edit.dart';

class _SalaryNewDialogOption extends StatelessWidget {
  _SalaryNewDialogOption({
    Key key,
    this.onSubmit
  }) : super(key: key);

  final ValueChanged<JobData> onSubmit;

  void _addSalary(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<JobData>(
        builder: (BuildContext context) => new SalaryEditWidget(null)
    )).then((JobData result) {
      if (result != null) {
        onSubmit(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: () { Navigator.pop(context, null); _addSalary(context); },
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
    );
  }
}

class _SalaryUpdateDialogOption extends StatelessWidget {
  _SalaryUpdateDialogOption({
    Key key,
    this.job,
    this.onUpdate,
    this.onDelete
  }) : super(key: key);

  final JobData job;
  final ValueChanged<JobData> onUpdate;
  final ValueChanged<JobData> onDelete;

  void _updateSalary(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<JobData>(
        builder: (BuildContext context) => new SalaryEditWidget(job)
    )).then((JobData result) {
      if (result != null) {
        onUpdate(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: () { Navigator.pop(context, null); _updateSalary(context); },
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Icon(Icons.work, size: 30.0, color: Colors.blue),
          new Expanded(
            child: new Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: new Text(job.title, maxLines: 1),
            )
          ),
          new IconButton(
            icon: new Icon(Icons.delete, size: 36.0, color: Colors.grey),
            onPressed: () => onDelete(job),
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

  final _dialogChildren = <Widget>[];
  StreamSubscription<Event> _jobAdded, _jobUpdated, _jobRemoved;
  DatabaseReference _jobsDb;

  @override
  void initState() {
    super.initState();

    _jobsDb = FirebaseDatabase.instance.reference().child('jobs');

    _dialogChildren.add(new _SalaryNewDialogOption(onSubmit: _addJob));

    _jobAdded = _jobsDb.orderByKey().onChildAdded.listen((Event event) {
      JobData job = new JobData.fromDb(event.snapshot.key, event.snapshot.value);
      _dialogChildren.insert(
          _dialogChildren.length-1, // keep the last item the 'new' option.
          new _SalaryUpdateDialogOption(
              job: job,
              onUpdate: _updateJob,
              onDelete: _deleteJob
          )
      );
    });

    _jobUpdated = _jobsDb.orderByKey().onChildChanged.listen((Event event) {
      var index = _dialogChildren.indexOf(
        _dialogChildren.firstWhere((Widget element) =>
          (element is _SalaryUpdateDialogOption) &&
          (element as _SalaryUpdateDialogOption).job.uid == event.snapshot.key
        )
      );
      _dialogChildren.removeAt(index);
      _dialogChildren.insert(index,
        new _SalaryUpdateDialogOption(
          job: new JobData.fromDb(event.snapshot.key, event.snapshot.value),
          onUpdate: _updateJob,
          onDelete: _deleteJob,
        )
      );
    });

    _jobRemoved = _jobsDb.orderByKey().onChildRemoved.listen((Event event) {
      _dialogChildren.removeWhere((Widget element) =>
        (element is _SalaryUpdateDialogOption) &&
        (element as _SalaryUpdateDialogOption).job.uid == event.snapshot.key
      );
    });
  }

  @override
  void dispose() {
    _jobAdded.cancel();
    _jobUpdated.cancel();
    _jobRemoved.cancel();
    super.dispose();
  }

  void _manageSalaries(context) {
    showDialog(
        context: context,
        child: new SimpleDialog(
            title: new Text('Edit jobs'),
            children: _dialogChildren
        )
    );
  }

  void _addJob(JobData job) {
    _jobsDb.push().set(job.toMap());
  }

  void _updateJob(JobData job) {
    _jobsDb.child(job.uid).update(job.toMap());
  }

  void _deleteJob(JobData job) {
    Navigator.pop(context, null);

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(
        color: theme.textTheme.caption.color
    );

    showDialog(
      context: context,
      child: new AlertDialog(
        content: new Text(
          'Delete job \'${job.title}\'?',
          style: dialogTextStyle
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('CANCEL'),
            onPressed: () => Navigator.pop(context, null)
          ),
          new FlatButton(
            child: new Text('DELETE'),
            onPressed: () {
              Navigator.of(context)
              ..pop(); // pop the SalaryEditWidget

              _jobsDb.child(job.uid).remove();
            }
          )
        ]
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