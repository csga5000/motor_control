import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motor_control/ble/models/ble_motor_control.dart';
import 'package:motor_control/ble/models/device_connection.dart';
import 'package:motor_control/ble/services/ble.dart';

/// Loads the RRSI periodically for a device
final deviceRSSIProvider = StreamProvider.autoDispose
    .family<int, BluetoothDevice>((ref, device) async* {
  bool disposed = false;
  ref.onDispose(() {
    disposed = true;
  });

  while (!disposed) {
    yield await device.readRssi();
    await Future.delayed(const Duration(seconds: 1));
  }
});

/// Manages connections of all watched devices
final deviceConnectionProvider = StateNotifierProvider.autoDispose
    .family<DeviceConnectionNotifier, DeviceConnection, BluetoothDevice>(
  (ref, device) => DeviceConnectionNotifier(ref, device: device),
);

class DeviceConnectionNotifier extends StateNotifier<DeviceConnection> {
  final Ref ref;
  final BluetoothDevice device;
  DeviceConnectionNotifier(this.ref, {required this.device})
      : super(DeviceConnection.connecting(device)) {
    manageConnection();
  }

  void manageConnection() async {
    await device.connect();
    if (!mounted) return;

    await for (final newState in device.state) {
      if (!mounted) return;

      switch (newState) {
        case BluetoothDeviceState.connecting:
          state = DeviceConnection.connecting(device);
          break;
        case BluetoothDeviceState.connected:
          // Discover services
          Iterable<BluetoothService> services = await device.discoverServices();
          services =
              services.where((element) => element.uuid == motorControlService);

          if (services.length != 1) {
            state = DeviceConnection.disconnected(
              device: device,
              reason: "Service not found",
            );
            continue;
          }
          final service = services.first;

          // Find characteristic
          final characteristics = service.characteristics.where(
            (char) => char.uuid == motorControlCharacteristic,
          );
          if (characteristics.length != 1) {
            state = DeviceConnection.disconnected(
              device: device,
              reason: "Could not find characteristic",
            );
            continue;
          }
          final characteristic = characteristics.first;

          state = DeviceConnection.connected(BleMotorControlDevice(
            device: device,
            motorControl: service,
            writeCharacteristic: characteristic,
          ));
          continue;
        case BluetoothDeviceState.disconnected:
        case BluetoothDeviceState.disconnecting:
          state = DeviceConnection.disconnected(
            device: device,
            reason: "Connection lost",
          );
          continue;
      }
    }
  }

  void sendSpeed(List<int> speedData) {
    state.whenOrNull(connected: (motorControlDevice) {
      motorControlDevice.writeCharacteristic.write(speedData);
    });
  }
}
