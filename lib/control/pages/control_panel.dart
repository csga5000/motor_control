import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motor_control/ble/managers/device_connection.dart';
import 'package:motor_control/control/components/joystick.dart';

class ControlPanelPage extends ConsumerWidget {
  static MaterialPageRoute route(BluetoothDevice motorControlDevice) =>
      MaterialPageRoute(
        builder: (c) => ControlPanelPage(
          motorControlDevice: motorControlDevice,
        ),
      );

  final BluetoothDevice motorControlDevice;

  const ControlPanelPage({super.key, required this.motorControlDevice});

  void onJoystickChange(WidgetRef ref, double size, Offset offset) {
    final deviceNotifier =
        ref.read(deviceConnectionProvider(motorControlDevice).notifier);
    final percentOffset = offset / size;
    final speed = 255 * (1 - percentOffset.dy);
    if (kDebugMode) {
      print("V percent: ${percentOffset.dy} sending speed: $speed");
    }
    deviceNotifier.sendSpeed([speed.round()]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceStatus =
        ref.watch(deviceConnectionProvider(motorControlDevice));
    final rssi = ref.watch(deviceRSSIProvider(motorControlDevice));

    final size = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      body: Column(
        children: [
          deviceStatus.when(
            connected: (device) => ListTile(
              title: const Text("Connected"),
              subtitle: Text("${device.device.name} (${device.device.id})"),
              trailing: rssi.when(
                  data: (data) => Text("$data"),
                  error: (err, trace) => const Text("?"),
                  loading: _buildProgressindicator),
            ),
            disconnected: (device, reason, err, trace) => ListTile(
              title: const Text("Disconnected"),
              subtitle: Text("${device.name} (${device.id})"),
            ),
            connecting: (device) => ListTile(
              title: const Text("Connecting..."),
              subtitle: Text("${device.name} (${device.id})"),
              trailing: _buildProgressindicator(),
            ),
            discoveringService: (device) => ListTile(
              title: const Text("Setting up..."),
              subtitle: Text("${device.name} (${device.id})"),
              trailing: _buildProgressindicator(),
            ),
          ),
          JoystickView(
            size: size,
            onDirectionChanged: (offset) => onJoystickChange(ref, size, offset),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressindicator() {
    return const SizedBox(
        width: 20, height: 20, child: CircularProgressIndicator());
  }
}
