import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:keypress_simulator_platform_interface/src/keypress_simulator_platform_interface.dart';
import 'package:uni_platform/uni_platform.dart';

/// An implementation of [KeyPressSimulatorPlatform] that uses method channels.
class MethodChannelKeyPressSimulator extends KeyPressSimulatorPlatform {
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
    LogicalKeyboardKey? key,
    PhysicalKeyboardKey? physicalKey,
    List<ModifierKey> modifiers = const [],
    bool keyDown = true,
  }) async {
    int? keyCode = UniPlatform.call<int?>(
      macOS: () {
        return kMacOsToPhysicalKey.entries
            .firstWhereOrNull((e) => e.value == physicalKey)
            ?.key;
      },
      windows: () => null,
      otherwise: () => null,
    );

    if (keyCode == null) {
      throw UnsupportedError(
        'Unsupported logical key: $key with modifiers: $modifiers',
      );
    }
    final Map<Object?, Object?> arguments = {
      'key': key?.keyLabel,
      'keyCode': keyCode,
      'modifiers': modifiers.map((e) => e.name).toList(),
      'keyDown': keyDown,
    }..removeWhere((key, value) => value == null);
    await methodChannel.invokeMethod('simulateKeyPress', arguments);
  }
}
