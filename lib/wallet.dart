library ethers;

import 'dart:async';
import 'dart:convert';

import 'package:ethers/error.dart';
import 'package:ethers/src/javascript_runtime.dart';
import 'package:ethers/src/types.dart';
import 'package:flutter_js/extensions/handle_promises.dart';

class Wallet {
  Wallet({required this.address});

  /// Create a random wallet
  ///
  /// Returns a new [Wallet] with a random private key. You can provide optional
  /// creation options with `extraEntropy` as a hex string that provides some
  /// extra entropy to the randomization.
  ///
  /// ```
  ///   final wallet = await Wallet.createRandom({'extraEntropy': '0xbaadf00d'});
  /// ```
  ///
  /// See original documentation
  ///  - https://docs.ethers.io/v5/api/signer/#Wallet-createRandom
  static Future<Wallet> createRandom([JsonMap? options]) async {
    final jsRuntime = await getEthersJsRuntime();

    final opts = jsonEncode(options ?? {});

    final result = jsRuntime.evaluate('''
      const wallet = global.ethers.Wallet.createRandom($opts);

      // Return from evaluation
      JSON.stringify({
        address: wallet.address
      });
    ''');

    if (result.isError) {
      throw JavascriptError(result.stringResult);
    }

    final json = jsonDecode(result.stringResult);
    return Wallet(
      address: json['address'],
    );
  }

  static Future<Wallet> fromEncryptedJson({
    required String json,
    required String password,
    ProgressCallback? onProgress,
  }) async {
    final jsRuntime = await getEthersJsRuntime();

    jsRuntime.onMessage('onProgress', (pct) {
      if (onProgress != null) {
        onProgress(pct);
      }
    });

    final js = '''
      global.ethers.Wallet.fromEncryptedJson(
        `$json`,
        "$password",
        (percent) => sendMessage("onProgress", JSON.stringify(percent || 0))
      )
      .then((wallet) => JSON.stringify({
            address: wallet.address,
          })
      );
    ''';

    final asyncResult = await jsRuntime.evaluateAsync(js);
    if (asyncResult.isError) {
      throw JavascriptError(asyncResult.stringResult);
    }

    final resolvedPromise = await jsRuntime.handlePromise(asyncResult);
    final walletJson = jsonDecode(resolvedPromise.stringResult);

    return Wallet(
      address: walletJson['address'],
    );
  }

  final String address;
}
