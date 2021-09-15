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
    });

    test('Create random wallet with extra entropy', () async {
      final wallet = await Wallet.createRandom({'extraEntropy': '0xbaadf00d'});
      expect(wallet.address.startsWith('0x'), true);
      expect(wallet.address.length, 42);
    });

    test('Create random wallet with empty entropy', () async {
      final wallet = await Wallet.createRandom({'extraEntropy': null});
      expect(wallet.address.startsWith('0x'), true);
      expect(wallet.address.length, 42);
    });
  });
}
