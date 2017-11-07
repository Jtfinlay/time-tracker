import 'package:flutter/material.dart';

typedef Widget PanelItemBodyBuilder<T>(PanelItem<T> item);
typedef String ValueToString<T>(T value);

class PanelItem<T> {
  PanelItem({
    this.name,
    this.value,
    this.hint,
    this.builder,
    this.valueToString
  });

  final String name;
  final String hint;
  final PanelItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return new AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      final ThemeData theme = Theme.of(context);
      final TextTheme textTheme = theme.textTheme;

      return new Row(
        children: <Widget>[
          new Expanded(
            flex: 2,
            child: new Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: new FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: new Text(
                  name,
                  style: textTheme.body1.copyWith(fontSize: 15.0),
                ),
              )
            )
          ),
          new Expanded(
            flex: 3,
            child: new Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                new Text(valueToString(value),
                  style: textTheme.caption.copyWith(fontSize: 15.0)
                ),
                new Text(hint,
                  style: textTheme.caption.copyWith(fontSize: 15.0)
                ),
                isExpanded
              ),
            )
          )
        ],
      );
    };
  }
}

class SubmitLogPage extends StatefulWidget {
  @override
  State createState() => new SubmitLogPageState();
}

class SubmitLogPageState extends State<SubmitLogPage> {
  List<PanelItem<dynamic>> _panelItems;

  @override
  void initState() {
    super.initState();

    _panelItems = <PanelItem<dynamic>>[
      new PanelItem<DateTime>(
        name: 'Date',
        value: new DateTime.now(),
        hint: 'Change date',
        valueToString: (DateTime value) => value.toString(),
        builder: (PanelItem<DateTime> item) {
          close() { setState(() { item.isExpanded = false; }); }

          return new Form(
            child: new Container()
          );
        }
      ),
      new PanelItem<double>(
        name: 'ElapsedTime',
        value: 0.0,
        hint: 'Change time it took',
        valueToString: (double value) => value.toString(),
        builder: (PanelItem<double> item) {
          close() { setState(() { item.isExpanded = false; }); }
          return new Form(
            child: new Builder(
              builder: (BuildContext context) {
                return new Container();
              }
            )
          );
        }
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Add new log')),
      body: new SingleChildScrollView(
        child: new Container(
          margin: const EdgeInsets.all(24.0),
          child: new ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _panelItems[index].isExpanded = !isExpanded;
              });
            },
            children: _panelItems.map((PanelItem<dynamic> item) {
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


