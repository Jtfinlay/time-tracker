class Log {
  Log({
    this.uid,
    this.elapsedTime,
    this.timestamp,
    this.salaryId,
    this.salaryName,
    this.salaryValue
  });

  Log.fromMap(String key, dynamic value)
  {
    uid = key;
    elapsedTime = value['elapsedTime'];
    timestamp = value['timestamp'];
    salaryId = value['salaryId'];
    salaryName = value['salaryName'];
    salaryValue = value['salaryValue'];
  }

  Map toMap() {
    return {
      'uid': uid,
      'elapsedTime': elapsedTime,
      'timestamp': timestamp,
      'salaryId': salaryId,
      'salaryName': salaryName,
      'salaryValue': salaryValue
    };
  }

  String uid;
  int elapsedTime;
  DateTime timestamp;
  String salaryId;
  String salaryName;
  double salaryValue;
}