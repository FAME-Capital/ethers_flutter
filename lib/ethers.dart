
import 'dart:async';

import 'package:flutter/services.dart';

class Ethers {
  static const MethodChannel _channel = MethodChannel('ethers');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
