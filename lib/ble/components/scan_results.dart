import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

typedef ScanResultChosenCallback = void Function(ScanResult result);

class ScanResults extends StatelessWidget {
  final List<ScanResult> scanResults;

  final ScanResultChosenCallback? onScanResultChosen;

  const ScanResults(
      {super.key, required this.scanResults, this.onScanResultChosen});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final scanResult in scanResults)
          ListTile(
            title: Text(scanResult.device.name),
            subtitle: Text(scanResult.device.id.id),
            trailing: Text(scanResult.rssi.toString()),
            onTap: onScanResultChosen == null
                ? null
                : () => onScanResultChosen!(scanResult),
          ),
      ],
    );
  }
}
