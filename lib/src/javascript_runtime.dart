import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

Future<JavascriptRuntime> getEthersJsRuntime() async {
  final JavascriptRuntime jsRuntime = getJavascriptRuntime();
  jsRuntime.evaluate('var window = global = globalThis;');

  // JS script assets to load
  const scriptAssets = [
    'packages/ethers/assets/js/crypto-shim.js',
    'packages/ethers/assets/js/ethers-5.2.umd.min.js',
  ];

  for (final scriptAsset in scriptAssets) {
    final js = await rootBundle.loadString(scriptAsset);
    jsRuntime.evaluate(js);
  }

  return jsRuntime;
}
