 import 'package:ethers/src/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

Future<JavascriptRuntime> getEthersJsRuntime() async {
    final JavascriptRuntime jsRuntime = getJavascriptRuntime();
    jsRuntime.evaluate('var window = global = globalThis;');

    jsRuntime.evaluate(await rootBundle.loadString(assetCryptoShimJs));
    jsRuntime.evaluate(await rootBundle.loadString(assetEthersJs));

    return jsRuntime;
  }
