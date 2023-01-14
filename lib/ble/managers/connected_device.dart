// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:motor_control/ble/managers/device_connection.dart';
// import 'package:motor_control/ble/models/device_connection.dart';

// class ChosenDevicesNotifier extends StateNotifier<List<DeviceConnection>> {
//   final Ref ref;
//   final Map<BluetoothDevice, ProviderSubscription> _deviceSubscriptions = {};
//   ChosenDevicesNotifier(this.ref) : super(List.unmodifiable([]));

//   void connect(BluetoothDevice device) {
//     if (state.where((con) => con.device?.id == device.id).isNotEmpty) return;

//     _deviceSubscriptions[device] = ref.container.listen(
//       deviceConnectionProvider(device),
//       (previous, next) {
//         state = next;
//       },
//     );
//     state = List.unmodifiable([
//       ...state,
//       ref.read<DeviceConnection>(deviceConnectionProvider(device))
//     ]);
//   }

//   void disconnect(BluetoothDevice device) {
//     for (var i = 0; i < state.length; i++) {
//       final connectedDevice = state[i];
//       if (connectedDevice.device?.id == device.id) {
//         state = [
//           ...state.sublist(0, i),
//           ...state.sublist(i + 1),
//         ];

//         return;
//       }
//     }
//   }
// }

// This is awkward in riverpods, not sure hte best way to do it yet.
// final chosenDevicesProvider =
//     StateProvider<List<BluetoothDevice>>((ref) => List.unmodifiable([]));
// final chosenDeviceConnectionProvider =
//     StateNotifierProvider<ChosenDeviceConnectionNotifier, DeviceConnection>(
//   (ref) => ChosenDeviceConnectionNotifier(ref,
//       device: ref.watch(chosenDeviceProvider)),
// );

/// Subscribes to ConnectDeviceProvider for the `device` specified and disposes (to allow auto-disposing) when device changes
// class ChosenDeviceConnectionNotifier extends StateNotifier<DeviceConnection> {
//   final StateNotifierProviderRef ref;
//   BluetoothDevice? device;
//   ProviderSubscription? stateSub;
//   ChosenDeviceConnectionNotifier(this.ref, {this.device})
//       : super(const DeviceConnection.none()) {
//     // This instance will forever do nothing, a new device will force a new chosen device
//     if (device == null) return;

//     // Subscribe to device conneciton using family providder
//     stateSub = ref.container.listen(
//       connectedDeviceProvider(device!),
//       (previous, next) {
//         state = next;
//       },
//     );
//   }
//   @override
//   void dispose() {
//     stateSub?.close();
//     super.dispose();
//   }
// }
