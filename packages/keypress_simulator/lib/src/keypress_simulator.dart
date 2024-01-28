import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keypress_simulator_platform_interface/keypress_simulator_platform_interface.dart';

class KeyPressSimulator {
  KeyPressSimulator._();

  /// The shared instance of [KeyPressSimulator].
  static final KeyPressSimulator instance = KeyPressSimulator._();

  KeyPressSimulatorPlatform get _platform => KeyPressSimulatorPlatform.instance;

  Future<bool> isAccessAllowed() {
    return _platform.isAccessAllowed();
  }

  Future<void> requestAccess({
    bool onlyOpenPrefPane = false,
  }) {
    return _platform.requestAccess(onlyOpenPrefPane: onlyOpenPrefPane);
  }

  /// Simulates a key press.
  Future<void> simulateKeyPress({
    LogicalKeyboardKey? key,
    PhysicalKeyboardKey? physicalKey,
    List<ModifierKey> modifiers = const [],
    bool keyDown = true,
  }) {
    return _platform.simulateKeyPress(
      key: key,
      physicalKey: physicalKey,
      modifiers: modifiers,
      keyDown: keyDown,
    );
  }

  @Deprecated('Please use simulateKeyPress method.')
  Future<void> simulateCtrlCKeyPress() async {
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyC,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier,
      ],
    );
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyC,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier,
      ],
      keyDown: false,
    );
  }

  @Deprecated('Please use simulateKeyPress method.')
  Future<void> simulateCtrlVKeyPress() async {
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyV,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier,
      ],
    );
    await simulateKeyPress(
      key: LogicalKeyboardKey.keyV,
      modifiers: [
        Platform.isMacOS
            ? ModifierKey.metaModifier
            : ModifierKey.controlModifier,
      ],
      keyDown: false,
    );
  }
}

final keyPressSimulator = KeyPressSimulator.instance;
