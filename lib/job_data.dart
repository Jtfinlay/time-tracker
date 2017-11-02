import 'package:flutter/material.dart';

class JobData {
  JobData({
    this.title,
    this.salary,
    this.startTime,
    this.endTime,
    bool sunday,
    bool monday,
    bool tuesday,
    bool wednesday,
    bool thursday,
    bool friday,
    bool saturday
  }) {
    weekDays['Sunday'] = sunday;
    weekDays['Monday'] = sunday;
    weekDays['Tuesday'] = sunday;
    weekDays['Wednesday'] = sunday;
    weekDays['Thursday'] = sunday;
    weekDays['Friday'] = sunday;
    weekDays['Saturday'] = sunday;
  }

  String title = '';
  String salary = '';
  TimeOfDay startTime, endTime;
  final Map<String,bool> weekDays = {
    "Sunday": false,
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
  };
}