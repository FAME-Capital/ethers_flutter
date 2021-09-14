import 'dart:async';

import 'package:flutter/services.dart';

class Ethers {
  static const _channel = MethodChannel('famecapital_ethers');

  static Future<String?> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
