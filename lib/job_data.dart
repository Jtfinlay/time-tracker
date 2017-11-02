import 'package:flutter/material.dart';

class JobData {
  JobData.fromTitle(this.title);
  JobData();

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