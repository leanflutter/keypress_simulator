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

  /// Simulate key down.
  Future<void> simulateKeyDown({
    LogicalKeyboardKey? key,
    List<ModifierKey> modifiers = const [],
  }) {
    return _platform.simulateKeyPress(
      key: key,
      modifiers: modifiers,
      keyDown: true,
    );
  }

  /// Simulate key up.
  Future<void> simulateKeyUp({
    LogicalKeyboardKey? key,
    List<ModifierKey> modifiers = const [],
  }) {
    return _platform.simulateKeyPress(
      key: key,
      modifiers: modifiers,
      keyDown: false,
    );
  }

  @Deprecated('Please use simulateKeyDown & simulateKeyUp methods.')
  Future<void> simulateCtrlCKeyPress() async {
    const key = LogicalKeyboardKey.keyC;
    final modifiers = Platform.isMacOS
        ? [ModifierKey.metaModifier]
        : [ModifierKey.controlModifier];
    await simulateKeyDown(key: key, modifiers: modifiers);
    await simulateKeyUp(key: key, modifiers: modifiers);
  }

  @Deprecated('Please use simulateKeyDown & simulateKeyUp methods.')
  Future<void> simulateCtrlVKeyPress() async {
    const key = LogicalKeyboardKey.keyV;
    final modifiers = Platform.isMacOS
        ? [ModifierKey.metaModifier]
        : [ModifierKey.controlModifier];
    await simulateKeyDown(key: key, modifiers: modifiers);
    await simulateKeyUp(key: key, modifiers: modifiers);
  }
}

final keyPressSimulator = KeyPressSimulator.instance;
