import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:true_time/true_time.dart';

class Utils {
  static pushScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static Future<bool> hasAccessToInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static Future<DateTime> getTime() async {
    bool isInit = await TrueTime.init(ntpServer: 'time.google.com');
    if (isInit)
      return await TrueTime.now();
    else
      return DateTime.now();
  }

  static String cut(String word, int chars) {
    return word.substring(0, word.length - chars);
  }
}
