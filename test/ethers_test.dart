import 'package:ethers/ethers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Creating random wallet', () async {
    final wallet = await Wallet.createRandom();
    expect(wallet.address.startsWith('0x'), true);
    expect(wallet.address.length, 42);
  });
}
