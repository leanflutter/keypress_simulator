import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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

  Future<void> simulateCtrlCKeyPress() async {
    await _channel.invokeMethod('simulateCtrlCKeyPress', {});
  }

  Future<void> simulateCtrlVKeyPress() async {
    await _channel.invokeMethod('simulateCtrlVKeyPress', {});
  }
}

final keyPressSimulator = KeyPressSimulator.instance;
