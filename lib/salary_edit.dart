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
    );
  }

}