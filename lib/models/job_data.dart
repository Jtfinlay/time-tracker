import 'package:flutter/material.dart';

class JobData {
  JobData();

  JobData.fromDb(String key, dynamic value)
  {
    uid = key;
    title = value['title'];
    salary = value['salary'];
    if (value['startTime'] != null) {
      startTime = new TimeOfDay.fromDateTime(value['startTime']);
    }
    if (value['endTime'] != null) {
      endTime = new TimeOfDay.fromDateTime(value['endTime']);
    }

    String weekDayList = value['weekDays'];
    weekDays['Sunday'] = weekDayList.contains('Sunday');
    weekDays['Monday'] = weekDayList.contains('Monday');
    weekDays['Tuesday'] = weekDayList.contains('Tuesday');
    weekDays['Wednesday'] = weekDayList.contains('Wednesday');
    weekDays['Thursday'] = weekDayList.contains('Thursday');
    weekDays['Friday'] = weekDayList.contains('Friday');
    weekDays['Saturday'] = weekDayList.contains('Saturday');
  }

  Map toMap() {
    var enabledWeekDays = new List<String>();
    weekDays.forEach((weekDay, enabled) {
      if (enabled) {
        enabledWeekDays.add(weekDay);
      }
    });

    var startDateTime = (startTime == null) ? null :
      new DateTime(1980, 1, 1, startTime.hour, startTime.minute);
    var endDateTime = (endTime == null) ? null :
      new DateTime(1980, 1, 1, endTime.hour, endTime.minute);

    Map<String, Object> result = {
      'title': title,
      'salary': salary,
      'weekDays': enabledWeekDays.join(',')
    };
    if (startDateTime != null) {
      result['startTime'] = startDateTime;
    }
    if (endDateTime != null) {
      result['endTime'] = endDateTime;
    }
    return result;
  }

  String uid = null;
  String title = '';
  String salary = '';
  TimeOfDay startTime, endTime;
  final Map<String,bool> weekDays = {
    "Sunday": true,
    "Monday": true,
    "Tuesday": true,
    "Wednesday": true,
    "Thursday": true,
    "Friday": true,
    "Saturday": true,
  };
}