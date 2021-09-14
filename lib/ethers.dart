import 'dart:async';

import 'package:flutter/services.dart';

class Ethers {
  static const _channel = MethodChannel('ethers');

  static Future<String?> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
