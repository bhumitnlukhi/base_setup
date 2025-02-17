import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {

  String toStringWithCustomDate(String outputFormat) {
    if(this == null){
      return '';
    }
    return DateFormat(outputFormat).format(this);
  }

}

extension TimeExtension on TimeOfDay {

  bool isEqual(TimeOfDay time){
    return this == time;
  }

  bool isBefore(TimeOfDay time){
    int startSeconds = (hour * 3600) + (minute * 60);
    int endSeconds = (time.hour * 3600) + (time.minute * 60);
    return startSeconds < endSeconds;
  }

  bool isAfter(TimeOfDay time){
    int startSeconds = (hour * 3600) + (minute * 60);
    int endSeconds = (time.hour * 3600) + (time.minute * 60);
    return startSeconds > endSeconds;
  }
}