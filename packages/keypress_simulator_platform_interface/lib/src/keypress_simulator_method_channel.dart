import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:keypress_simulator_platform_interface/src/keypress_simulator_platform_interface.dart';
import 'package:uni_platform/uni_platform.dart';

/// An implementation of [KeyPressSimulatorPlatform] that uses method channels.
class MethodChannelKeyPressSimulator extends KeyPressSimulatorPlatform {
  int? _findPhysicalKeyCode(PhysicalKeyboardKey? key) {
    final keymap = UniPlatform.select<Map<int, PhysicalKeyboardKey>>(
      macOS: kMacOsToPhysicalKey,
      otherwise: {},
    );
    return keymap.entries.firstWhereOrNull((e) => e.value == key)?.key;
  }

  int? _findPhysicalScanCode(PhysicalKeyboardKey? key) {
    final keymap = UniPlatform.select<Map<int, PhysicalKeyboardKey>>(
      windows: kWindowsToPhysicalKey,
      otherwise: {},
    );
    return keymap.entries.firstWhereOrNull((e) => e.value == key)?.key;
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'dev.leanflutter.plugins/keypress_simulator',
  );

  @override
  Future<bool> isAccessAllowed() async {
    if (UniPlatform.isMacOS) {
      return await methodChannel.invokeMethod('isAccessAllowed');
    }
    return true;
  }

  @override
  Future<void> requestAccess({
    bool onlyOpenPrefPane = false,
  }) async {
    if (UniPlatform.isMacOS) {
      final Map<String, dynamic> arguments = {
        'onlyOpenPrefPane': onlyOpenPrefPane,
      };
      await methodChannel.invokeMethod('requestAccess', arguments);
    }
  }

  @override
  Future<void> simulateKeyPress({
    PhysicalKeyboardKey? key,
    List<ModifierKey> modifiers = const [],
    bool keyDown = true,
  }) async {
    final Map<Object?, Object?> arguments = {
      'keyCode': _findPhysicalKeyCode(key),
      'scanCode': _findPhysicalScanCode(key),
      'modifiers': modifiers.map((e) => e.name).toList(),
      'keyDown': keyDown,
    }..removeWhere((key, value) => value == null);
    await methodChannel.invokeMethod('simulateKeyPress', arguments);
  }
}
