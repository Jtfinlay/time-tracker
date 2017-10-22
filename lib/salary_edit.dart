import 'package:flutter/material.dart';

class SalaryEditWidget extends StatefulWidget {
  @override
  State createState() => new SalaryEditWidgetState();
}

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class SalaryEditWidgetState extends State<SalaryEditWidget> {
  TimeOfDay _startTime, _endTime;
  bool _savedNeeded = false;

  @override
  void initState() {
    super.initState();

    // TODO - Check settings if editing existing value
    _startTime = new TimeOfDay(hour: 9, minute: 0);
    _endTime = new TimeOfDay(hour: 5, minute: 0);
  }

  void handleDismissButton(BuildContext context) {
    if (!_savedNeeded) {
      Navigator.pop(context, null);
      return;
    }

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(
        color: theme.textTheme.caption.color
    );

    showDialog<DismissDialogAction>(
      context: context,
      child: new AlertDialog(
        content: new Text(
          'Discard new job?',
          style: dialogTextStyle
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('CANCEL'),
            onPressed: () => Navigator.pop(context, DismissDialogAction.cancel)
          ),
          new FlatButton(
            child: new Text('DISCARD'),
            onPressed: () {
              Navigator.of(context)
                ..pop(DismissDialogAction.discard) // pop cancel/discard dialog
                ..pop(); // pop the SalaryEditWidget
            }
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
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
            onPressed: () => Navigator.pop(context, DismissDialogAction.save)
          )
        ]
      ),
      body: new ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          new TextField(
            onSubmitted: null,
            decoration: new InputDecoration(
              icon: new Icon(Icons.work),
              hintText: 'Name of employer or your position',
              labelText: 'Job Title *',
            ),
          ),
          new TextField(
            onSubmitted: null,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              labelText: 'Salary (Hourly) *',
              prefixText: '\$',
              suffixText: 'USD',
              suffixStyle: const TextStyle(color: Colors.green)
            ),
          ),
          new Padding(padding: const EdgeInsets.only(top: 20.0)),
          new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'Start Time (optional):',
                  style: Theme.of(context).textTheme.subhead
                ),
                new Expanded(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new FlatButton(
                        child: new Text(
                          'SET',
                          style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 20.0
                          )
                        ),
                        onPressed: () { },
                        )
                    ],
                  )
                ),
              ],
          ),
          new Padding(padding: const EdgeInsets.only(top: 10.0)),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                'End Time (optional):',
                style: Theme.of(context).textTheme.subhead
              ),
              new Expanded(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text(
                       'SET',
                        style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 20.0
                        )
                      ),
                      onPressed: () { },
                    )
                  ],
                )
              ),
            ],
          ),
          new Padding(padding: const EdgeInsets.only(top: 20.0)),
          new Text(
            'Week days (optional)',
            style: Theme.of(context).textTheme.subhead
          ),
          new Padding(padding: const EdgeInsets.only(top: 20.0)),
          new Row(
            children: <Widget>[
              new Padding(padding: const EdgeInsets.only(left:20.0)),
              new Expanded( child: new Text('S') ),
              new Expanded( child: new Text('M') ),
              new Expanded( child: new Text('T') ),
              new Expanded( child: new Text('W') ),
              new Expanded( child: new Text('T') ),
              new Expanded( child: new Text('F') ),
              new Expanded( child: new Text('S') ),
              new Padding(padding: const EdgeInsets.only(right:20.0)),
            ],
          ),
          new Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: new Text('* indicated required field',
              style: Theme.of(context).textTheme.caption)
          )
        ]
      )
    );
  }

}