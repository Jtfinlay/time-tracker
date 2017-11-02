import 'package:flutter/material.dart';

class JobData {
  String title = '';
  String salary = '';
  TimeOfDay startTime, endTime;
  Map<String,bool> weekDays = {
    "Sunday": false,
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
  };
}