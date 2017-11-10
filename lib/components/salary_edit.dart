import 'dart:async';

import 'package:flutter/material.dart';

import 'package:timetracker_mobile/models/job_data.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
  Key key,
  this.child,
  this.labelText,
  this.valueText,
  this.valueStyle,
  this.onPressed }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ?
                Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({
    Key key,
    this.labelText,
    this.selectedTime,
    this.selectTime
}) : super(key: key);

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? new TimeOfDay(hour: 0, minute: 0)
    );
    if (picked != null && picked != selectedTime) {
      selectTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      flex: 3,
      child: new _InputDropdown(
        labelText: labelText,
        valueText: selectedTime?.format(context) ?? '',
        valueStyle: Theme.of(context).textTheme.title,
        onPressed: () { _selectTime(context); },
      )
    );
  }
}

class _WeekDayItem extends StatelessWidget {
  _WeekDayItem({
    Key key,
    this.labelText,
    this.enabled,
    this.onPressed
}) : super(key: key);

  final String labelText;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new FlatButton(
        color: enabled ? Colors.blue : Colors.white,
        child: new Text(labelText),
        onPressed: onPressed
      )
    );
  }
}

class SalaryEditWidget extends StatefulWidget {
  SalaryEditWidget(this.job, {Key key}) : super(key: key);

  final JobData job;

  @override
  State createState() => new SalaryEditWidgetState(job);
}

class SalaryEditWidgetState extends State<SalaryEditWidget> {
  SalaryEditWidgetState(this.job);

  bool _autovalidate = false;
  bool _formWasEdited = false;
  JobData job = null;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    job ??= new JobData();
    print('Job: ${job.title}');
  }

  void handleWeekDayItemPressed(String weekday) {
    setState(() {
      _formWasEdited = true;
      job.weekDays[weekday] = !job.weekDays[weekday];

      if (job.startTime == null) {
        job.startTime = new TimeOfDay(hour: 0, minute: 0);
      }
      if (job.endTime == null) {
        job.endTime = new TimeOfDay(hour:23, minute: 59);
      }
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  void handleSaveAndDismiss(BuildContext context) {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      // TODO - snackbar doesn't show since scaffold disappears.
      showInSnackBar('${job.title} has been added');
      Navigator.pop(context, job);
    }
  }

  void handleDismissButton(BuildContext context) {
    final FormState form = _formKey.currentState;
    form.validate();

    if (!_formWasEdited) {
      Navigator.pop(context, null);
      return;
    }

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(
        color: theme.textTheme.caption.color
    );

    showDialog<JobData>(
      context: context,
      child: new AlertDialog(
        content: new Text(
          'Discard new job?',
          style: dialogTextStyle
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('CANCEL'),
            onPressed: () => Navigator.pop(context, null)
          ),
          new FlatButton(
            child: new Text('DISCARD'),
            onPressed: () {
              Navigator.of(context)
                ..pop(null) // pop cancel/discard dialog
                ..pop(); // pop the SalaryEditWidget
            }
          )
        ]
      )
    );
  }

  Widget buildWeekDayList(BuildContext context) {
    var children = <Widget>[new Padding(padding: const EdgeInsets.only(left:20.0))];

    job.weekDays.forEach((name, enabled) =>
      children.add(new _WeekDayItem(
        labelText: name[0],
        enabled: enabled,
        onPressed: () => handleWeekDayItemPressed(name),
      ))
    );

    return new Row(children: children);
  }

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) {
      return 'Job title is required.';
    }
    return null;
  }

  String _validateSalary(String value) {
    _formWasEdited = true;
    if (value.isEmpty) {
      return 'Salary is required.';
    }
    // TODO - Regex validation
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () => handleDismissButton(context)
        ),
        title: new Text('Edit salary'),
        actions: <Widget> [
          new FlatButton(
            child: new Text('SAVE', style: theme.textTheme.body1.copyWith(
                color: Colors.white
            )),
            onPressed: () { handleSaveAndDismiss(context); }
          )
        ]
      ),
      body: new Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            new TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.work),
                hintText: 'Name of employer or your position',
                labelText: 'Job Title *',
              ),
              initialValue: job.title,
              onSaved: (String value) { job.title = value; },
              validator: _validateName,
            ),
            new TextFormField(
              decoration: const InputDecoration(
                labelText: 'Salary (Hourly) *',
                prefixText: '\$',
                suffixText: 'USD',
                suffixStyle: const TextStyle(color: Colors.green)
              ),
              initialValue: job.salary,
              keyboardType: TextInputType.number,
              onSaved: (String value) { job.salary = value; },
              validator: _validateSalary
            ),

            new Padding(padding: const EdgeInsets.only(top: 20.0)),
            new Row(
              children: <Widget>[
                new _TimePicker(
                  labelText: 'Start Time (optional):',
                  selectedTime: job.startTime,
                  selectTime: (TimeOfDay t) {
                    setState(() {
                      _formWasEdited = true;
                      job.startTime = t;
                    });
                  }
                ),
                const SizedBox(width: 12.0),
                new _TimePicker(
                    labelText: 'End Time (optional):',
                    selectedTime: job.endTime,
                    selectTime: (TimeOfDay t) {
                      setState(() {
                        _formWasEdited = true;
                        job.endTime = t;
                      });
                    }
                ),
              ],
            ),

            new Padding(padding: const EdgeInsets.only(top: 20.0)),
            new Row(
              children: <Widget>[
                new Icon(Icons.calendar_today, size: 20.0, color: Colors.grey),
                new Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0)),
                new Text(
                    'Repeat (optional)',
                    style: Theme.of(context).textTheme.subhead
                ),
              ]
            ),

            new Padding(padding: const EdgeInsets.only(top: 20.0)),
            buildWeekDayList(context),

            new Container(
                padding: const EdgeInsets.only(top: 40.0),
                child: new Text('* indicates required field',
                    style: Theme.of(context).textTheme.caption)
            )
          ]
        )
      )
    );
  }

}