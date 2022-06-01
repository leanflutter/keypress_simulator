import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'known_logical_keys.dart';

class KeyPressSimulator {
  KeyPressSimulator._();

  /// The shared instance of [KeyPressSimulator].
  static final KeyPressSimulator instance = KeyPressSimulator._();

  final MethodChannel _channel = const MethodChannel('keypress_simulator');

  Future<bool> isAccessAllowed() async {
    if (!kIsWeb && Platform.isMacOS) {
      return await _channel.invokeMethod('isAccessAllowed');
    }
    return true;
  }

  Future<void> requestAccess({
    bool onlyOpenPrefPane = false,
  }) async {
    if (!kIsWeb && Platform.isMacOS) {
      final Map<String, dynamic> arguments = {
        'onlyOpenPrefPane': onlyOpenPrefPane,
      };
      await _channel.invokeMethod('requestAccess', arguments);
    }
  }

  Future<void> simulateKeyPress({
    LogicalKeyboardKey? key,
    List<ModifierKey> modifiers = const [],
    bool keyDown = true,
  }) async {
    final Map<String, dynamic> arguments = {
      'key': key != null ? kKnownLogicalKeys[key.keyId] : null,
      'modifiers': modifiers.map((e) => describeEnum(e)).toList(),
      'keyDown': keyDown,
    }..removeWhere((key, value) => value == null);
    await _channel.invokeMethod('simulateKeyPress', arguments);
  }

  @Deprecated("Please use simulateKeyPress method.")
  Future<void> simulateCtrlCKeyPress() async {
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyC,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier
      ],
    );
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyC,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier
      ],
      keyDown: false,
    );
  }

  @Deprecated("Please use simulateKeyPress method.")
  Future<void> simulateCtrlVKeyPress() async {
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyV,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier
      ],
    );
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyV,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier
      ],
      keyDown: false,
    );
  }
}

final keyPressSimulator = KeyPressSimulator.instance;
