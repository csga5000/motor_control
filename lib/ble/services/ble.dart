import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final motorControlService = Guid("99d70a93-bc50-41c0-9b16-196d95e27d29");
final motorControlCharacteristic = Guid("83f2df5a-e0df-4eb4-8246-03f8d1a7419f");

final bleProvider = Provider((ref) => FlutterBluePlus.instance);

/// Watch the results of scanning for BLE devices.  Scans while being watched, stops when the provider autodisposes due to no longer being watched
/// Yields a list of the conglomerated devices since the last disposal
final bleScanProvider = StreamProvider.autoDispose((ref) async* {
  final ble = ref.watch(bleProvider);

  final resultStream = ble.scan(
    timeout: null,
    withServices: [motorControlService],
    scanMode: ScanMode.lowLatency,
  );
  ref.onDispose(() {
    ble.stopScan();
  });

  List<ScanResult> scanResults = [];
  await for (final scanResult in resultStream) {
    scanResults.add(scanResult);
    yield scanResults;
  }
});
