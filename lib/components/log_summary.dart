import 'dart:async';

import 'package:flutter/material.dart';

import 'package:timetracker_mobile/components/expand_panel.dart';
import 'package:timetracker_mobile/models/log.dart';


class LogSummaryComponent extends StatefulWidget {
  LogSummaryComponent(this.log);

  final Log log;

  @override
  State createState() => new LogSummaryComponentState(log);
}

class LogSummaryComponentState extends State<LogSummaryComponent> {
  LogSummaryComponentState(this.log);

  List<ExpandPanel<dynamic>> _panelItems;
  Log log;

  void _handleDismissButton(BuildContext context) {
    // TODO
  }

  @override
  void initState() {
    super.initState();

    _panelItems = <ExpandPanel<dynamic>>[
      new ExpandPanel<int>(
        name: 'Elapsed time',
        value: log.elapsedTime,
        hint: 'Change elapsed time',
        valueToString: (int value) => value.toString(),
        builder: (ExpandPanel<int> item) {
          void close() {
            setState(() {
              item.isExpanded = false;
            });
          }
          return new Form(
            child: new Builder(
              builder: (BuildContext context) {
                return new CollapsibleBody(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  onSave: () { Form.of(context).save(); close(); },
                  onCancel: () { Form.of(context).reset(); close(); },
                  child: new FormField<int>(
                    initialValue: item.value,
                    onSaved: (int value) { item.value = value; },
                    builder: (FormFieldState<int> field) {

                    },
                  ),
                );
              },
            ),
          );
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.clear),
          onPressed: () => _handleDismissButton(context)
        ),
        title: new Text('Details'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: const EdgeInsets.all(24.0),
          child: new ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _panelItems[index].isExpanded = !isExpanded;
              });
            },
            children: _panelItems.map((ExpandPanel<dynamic> item) {
              return new ExpansionPanel(
                isExpanded: item.isExpanded,
                headerBuilder: item.headerBuilder,
                body: item.builder(item)
              );
            }).toList()
          )
        )
      )
    );

  }
}