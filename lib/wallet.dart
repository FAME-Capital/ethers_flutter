library ethers;

import 'dart:async';
import 'dart:convert';

import 'package:ethers/src/javascript_runtime.dart';

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
  static Future<Wallet> createRandom([Map<String, dynamic>? options]) async {
    final jsRuntime = await getEthersJsRuntime();
    final walletCompleter = Completer<Wallet>();

    jsRuntime.onMessage('onWalletCreated', (json) {
      walletCompleter.complete(
        Wallet(
          address: json['address'],
        ),
      );
    });

    final opts = json.encode(options ?? {});

    jsRuntime.evaluate('''
      const wallet = global.ethers.Wallet.createRandom($opts);

      const walletJson = {
        address: wallet.address
      };
      sendMessage("onWalletCreated", JSON.stringify(walletJson));
    ''');

    return walletCompleter.future;
  }

  final String address;
}
