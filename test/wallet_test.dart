import 'package:ethers/ethers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Wallet >', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('Create random wallet', () async {
      final wallet = await Wallet.createRandom();
      expect(wallet.address.startsWith('0x'), true);
      expect(wallet.address.length, 42);
      expect(wallet.publicKey.startsWith('0x'), true);
      expect(wallet.publicKey.length, 132);
    });

    test('Create random wallet with extra entropy', () async {
      final wallet = await Wallet.createRandom(extraEntropy: '0xbaadf00d');
      expect(wallet.address.startsWith('0x'), true);
      expect(wallet.address.length, 42);
      expect(wallet.publicKey.startsWith('0x'), true);
      expect(wallet.publicKey.length, 132);
    });

    test('Create random wallet with empty entropy', () async {
      final wallet = await Wallet.createRandom(extraEntropy: null);
      expect(wallet.address.startsWith('0x'), true);
      expect(wallet.address.length, 42);
      expect(wallet.publicKey.startsWith('0x'), true);
      expect(wallet.publicKey.length, 132);
    });

    test(
      'Create wallet from JSON',
      () async {
        const json =
            '''{"address":"d0838a7daccaa2714223205d97deeb6e69d61881","id":"eed8d922-6efa-4a7a-918f-32aef11f6491","version":3,"Crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"debe20fb510e45195119b721319b0010"},"ciphertext":"736492fc2d8abfbdab92fbded6d7f25ae6389e616a3ea0755993f8321bf6dfc1","kdf":"scrypt","kdfparams":{"salt":"fae523dfcc82adb40bbf995e2f1d25ecab8af68c94f3da7c16e52fc3456e6b41","n":131072,"dklen":32,"p":1,"r":8},"mac":"f1006cca3e2dd34cc9213b47c0f9e57066a042150072dcd152e5b8181e16f114"},"x-ethers":{"client":"ethers.js","gethFilename":"UTC--2021-09-15T07-49-26.0Z--d0838a7daccaa2714223205d97deeb6e69d61881","mnemonicCounter":"d8c6504071381a48c0c3edfb485fdefd","mnemonicCiphertext":"79fde0f147ade80df2ffd49b27fd69f9","path":"m/44'/60'/0'/0/0","locale":"en","version":"0.1"}}''';
        const password =
            '0x57abf95df1af1ff38f5a86b075032c979c9f5c42dc7dc0fa458c322acfa0edfc';
        final wallet =
            await Wallet.fromEncryptedJson(json: json, password: password);

        expect(
          wallet.address.toLowerCase(),
          '0xd0838a7daccaa2714223205d97deeb6e69d61881',
        );
        expect(wallet.publicKey.startsWith('0x'), true);
        expect(wallet.publicKey.length, 132);
      },
      // This function takes long time for decrypting the wallet.
      timeout: const Timeout(
        Duration(minutes: 5),
      ),
    );
  });
}
