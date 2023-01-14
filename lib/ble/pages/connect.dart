import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motor_control/ble/components/scan_results.dart';
import 'package:motor_control/ble/services/ble.dart';
import 'package:motor_control/control/pages/control_panel.dart';

class ConnectPage extends ConsumerWidget {
  const ConnectPage({super.key});

  // Callbacks

  void chooseDevice(BuildContext context, WidgetRef ref, ScanResult result) {
    Navigator.of(context).push(ControlPanelPage.route(result.device));
  }

  // View Building

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: buildResultsList(context, ref));
  }

  Widget buildResultsList(BuildContext context, WidgetRef ref) {
    final scanResults = ref.watch(bleScanProvider);

    return scanResults.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, trace) => const Text("Something went wrong"),
      data: (data) => ScanResults(
        scanResults: data,
        onScanResultChosen: (res) => chooseDevice(context, ref, res),
      ),
    );
  }
}
