import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ble_motor_control.freezed.dart';

@freezed
class BleMotorControlDevice with _$BleMotorControlDevice {
  const factory BleMotorControlDevice({
    required BluetoothDevice device,
    required BluetoothService motorControl,
    required BluetoothCharacteristic writeCharacteristic,
  }) = _BleMotorControlDevice;
}
