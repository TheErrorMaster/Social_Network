import 'package:flutter/material.dart';
// reuseable loading indicators.\
Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.green),
    ),
  );
}

Container linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.green),
    ),
  );
}
