library ethers;

import 'dart:async';
import 'dart:convert';

import 'package:ethers/src/javascript_runtime.dart';
import 'package:ethers/src/types.dart';

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

    final json = jsonDecode(result.stringResult);
    return Wallet(
      address: json['address'],
    );
  }

  final String address;
}
