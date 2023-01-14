import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motor_control/ble/models/ble_motor_control.dart';

part 'device_connection.freezed.dart';

@freezed
class DeviceConnection with _$DeviceConnection {
  const factory DeviceConnection.connecting(BluetoothDevice device) =
      _Connecting;
  const factory DeviceConnection.disconnected({
    required BluetoothDevice device,
    required String reason,
    dynamic error,
    StackTrace? trace,
  }) = _Disconnected;
  const factory DeviceConnection.discoveringService(BluetoothDevice device) =
      _DiscoveringService;
  const factory DeviceConnection.connected(BleMotorControlDevice device) =
      _Connected;

  const DeviceConnection._();

  BluetoothDevice get bluetoothDevice {
    if (device is BleMotorControlDevice) {
      return (device as BleMotorControlDevice).device;
    }
    return device as BluetoothDevice;
  }
}
