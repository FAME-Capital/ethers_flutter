library ethers;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class Wallet {
  static const _ethersLib = 'assets/js/ethers-5.2.umd.min.js';

  Wallet({required this.address});

  static Future<Wallet> createRandom() async {
    final jsRuntime = await _initializedJsRuntime;
    final walletCompleter = Completer<Wallet>();

    jsRuntime.onMessage('onWalletCreated', (json) {
      walletCompleter.complete(
        Wallet(
          address: json['address'],
        ),
      );
    });

    jsRuntime.evaluate('''
      const wallet = global.ethers.Wallet.createRandom();
      const walletJson = {
        address: wallet.address
      };
      sendMessage("onWalletCreated", JSON.stringify(walletJson));
    ''');

    return walletCompleter.future;
  }

  final String address;

  static Future<JavascriptRuntime> get _initializedJsRuntime async {
    final JavascriptRuntime jsRuntime = getJavascriptRuntime();
    jsRuntime.evaluate('var window = global = globalThis;');

    // Shim getRandomValues first, before importing ethers lib
    // The crypto functions are not available on the js runtime.
    jsRuntime.evaluate('''
      // https://developer.mozilla.org/en-US/docs/Web/API/Crypto/getRandomValues
      window.crypto = window.crypto || {};
      window.crypto.getRandomValues = (typedArray) => {
        for (i in typedArray) {
          typedArray[i] = Math.round(Math.random() * 255);
        }
        return typedArray;
      };

      window.crypto.randomBytes = (size, callback) => {
        const QUOTA = 65536;
        const arr = new Uint8Array(size);
        for (var i = 0; i < size; i += QUOTA) {
          window.crypto.getRandomValues(arr.subarray(i, i + Math.min(size - i, QUOTA)));
        }
        const buf = Buffer.from(arr);
        if (!!callback) {
          callback(null, buf);
        }
        return buf;
      }
    ''');

    jsRuntime.evaluate(await rootBundle.loadString(_ethersLib));

    return jsRuntime;
  }
}
