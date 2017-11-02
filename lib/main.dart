import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'settings.dart';
import 'timerWidget.dart';

class NavigationIconView {
  NavigationIconView({
    Icon icon,
    Text title,
    Color color,
    Widget page,
    TickerProvider sync,
  }) : _page = page,
        item = new BottomNavigationBarItem(
          icon: icon,
          title: title,
          backgroundColor: color,
       ),
        controller = new AnimationController(
            duration: kThemeAnimationDuration,
            vsync: sync,
       ) {
    _animation = new CurvedAnimation(
        parent: controller,
        curve: new Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  Widget _page;
  BottomNavigationBarItem item;
  AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    return new FadeTransition(
        opacity: _animation,
    child: new SlideTransition(
        position: new Tween<Offset>(
            begin: const Offset(0.0, 0.2), // Small offset from the top
            end: const Offset(0.0, 0.0),
        ).animate(_animation),
        child: _page
      ),
    );
  }
}

void main() {
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.goOffline();
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

class HomeScreenState extends State<HomeScreen>
  with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();

    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
          icon: new Icon(Icons.access_alarm),
          title: new Text('Timer'),
          color: Colors.brown[500],
          page: new TimerWidget(),
          sync: this,
          ),
      new NavigationIconView(
          icon: new Icon(Icons.insert_chart),
          title: new Text('History'),
          color: Colors.deepOrange[500],
          page: new Container(),
          sync: this,
          ),
      new NavigationIconView(
          icon: new Icon(Icons.settings),
          title: new Text('Settings'),
          color: Colors.teal[500],
          page: new SettingsPage(),
          sync: this,
          ),
    ];

    for (NavigationIconView view in _navigationViews)
    {
      view.controller.addListener(_rebuild);
    }

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews) {
      transitions.add(
          view.transition(BottomNavigationBarType.shifting, context));
    }

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.listenable;
      final Animation<double> bAnimation = b.listenable;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
        items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        },
    );

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Stool Tracker'),
            backgroundColor: Colors.lightBlue,
        ),
        body:  new Center(
            child: _buildTransitionsStack()
        ),
        bottomNavigationBar: botNavBar,
    );
  }


}

