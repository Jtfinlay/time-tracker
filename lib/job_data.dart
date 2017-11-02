import 'package:flutter/material.dart';

class JobData {
  JobData();

  JobData.fromDb(dynamic value)
  {
    title = value['title'];
    salary = value['salary'];
    startTime = value['startTime'];
    endTime = value['endTime'];

    weekDays['Sunday'] = value['Sunday'];
    weekDays['Monday'] = value['Sunday'];
    weekDays['Tuesday'] = value['Tuesday'];
    weekDays['Wednesday'] = value['Wednesday'];
    weekDays['Thursday'] = value['Thursday'];
    weekDays['Friday'] = value['Friday'];
    weekDays['Saturday'] = value['Saturday'];
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