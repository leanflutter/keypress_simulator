import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:preference_list/preference_list.dart';
import 'package:keypress_simulator/keypress_simulator.dart';

final hotKeyManager = HotKeyManager.instance;

final kShortcutSimulateCtrlT = HotKey(
  KeyCode.keyT,
  modifiers: [
    Platform.isMacOS ? KeyModifier.meta : KeyModifier.control,
  ],
);

final kShortcutSimulateCtrlC = HotKey(
  KeyCode.keyC,
  modifiers: [
    KeyModifier.shift,
    Platform.isMacOS ? KeyModifier.meta : KeyModifier.control,
  ],
);

final kShortcutSimulateCtrlV = HotKey(
  KeyCode.keyV,
  modifiers: [
    KeyModifier.shift,
    Platform.isMacOS ? KeyModifier.meta : KeyModifier.control,
  ],
);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAccessAllowed = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _isAccessAllowed = await keyPressSimulator.isAccessAllowed();
    setState(() {});

    // 初始化快捷键
    hotKeyManager.unregisterAll();
    hotKeyManager.register(
      kShortcutSimulateCtrlT,
      keyDownHandler: (_) async {
        print('simulateCtrlAKeyPress');
        await keyPressSimulator.simulateKeyPress(
          key: LogicalKeyboardKey.keyA,
          modifiers: [
            Platform.isMacOS
                ? ModifierKey.metaModifier
                : ModifierKey.controlModifier,
          ],
        );
        await keyPressSimulator.simulateKeyPress(
          key: LogicalKeyboardKey.keyA,
          modifiers: [
            Platform.isMacOS
                ? ModifierKey.metaModifier
                : ModifierKey.controlModifier,
          ],
          keyDown: false,
        );
        print('simulateCtrlCKeyPress');
        await keyPressSimulator.simulateCtrlCKeyPress();
        await Future.delayed(Duration(milliseconds: 200));
        print('simulateCtrlVKeyPress');
        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
        await Clipboard.setData(ClipboardData(
          text: 'KPS: ${data?.text}',
        ));
        await keyPressSimulator.simulateCtrlVKeyPress();
      },
    );
    hotKeyManager.register(
      kShortcutSimulateCtrlC,
      keyDownHandler: (_) async {
        print('simulateCtrlCKeyPress');
        keyPressSimulator.simulateCtrlCKeyPress();
      },
    );
    hotKeyManager.register(
      kShortcutSimulateCtrlV,
      keyDownHandler: (_) async {
        print('simulateCtrlVKeyPress');
        ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
        await Clipboard.setData(ClipboardData(
          text: 'KPS: ${data?.text}',
        ));
        keyPressSimulator.simulateCtrlVKeyPress();
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return PreferenceList(
      children: <Widget>[
        if (Platform.isMacOS)
          PreferenceListSection(
            children: [
              PreferenceListItem(
                title: const Text('isAccessAllowed'),
                accessoryView: Text('$_isAccessAllowed'),
                onTap: () async {
                  bool allowed = await keyPressSimulator.isAccessAllowed();
                  BotToast.showText(text: 'allowed: $allowed');
                  setState(() {
                    _isAccessAllowed = allowed;
                  });
                },
              ),
              PreferenceListItem(
                title: const Text('requestAccess'),
                onTap: () async {
                  await keyPressSimulator.requestAccess();
                },
              ),
            ],
          ),
        PreferenceListSection(
          title: const Text('Examples'),
          children: [
            PreferenceListItem(
              title: const Text('Active Spotlight'),
              onTap: () async {
                await keyPressSimulator.simulateKeyPress(
                  key: LogicalKeyboardKey.space,
                  modifiers: [
                    ModifierKey.metaModifier,
                  ],
                );
                await keyPressSimulator.simulateKeyPress(
                  key: LogicalKeyboardKey.space,
                  modifiers: [
                    ModifierKey.metaModifier,
                  ],
                  keyDown: false,
                );
              },
            ),
            PreferenceListItem(
              title: const Text('Active Siri'),
              onTap: () async {
                await keyPressSimulator.simulateKeyPress(
                  key: LogicalKeyboardKey.space,
                  modifiers: [
                    ModifierKey.metaModifier,
                  ],
                );
                await Future.delayed(const Duration(seconds: 6));
                await keyPressSimulator.simulateKeyPress(
                  key: LogicalKeyboardKey.space,
                  modifiers: [
                    ModifierKey.metaModifier,
                  ],
                  keyDown: false,
                );
              },
            ),
            PreferenceListItem(
              title: const Text('Screenshot'),
              onTap: () async {
                if (Platform.isMacOS) {
                  await keyPressSimulator.simulateKeyPress(
                    key: LogicalKeyboardKey.digit4,
                    modifiers: [
                      ModifierKey.shiftModifier,
                      ModifierKey.metaModifier,
                    ],
                  );
                  await keyPressSimulator.simulateKeyPress(
                    key: LogicalKeyboardKey.digit4,
                    modifiers: [
                      ModifierKey.shiftModifier,
                      ModifierKey.metaModifier,
                    ],
                    keyDown: false,
                  );
                } else if (Platform.isWindows) {
                  await keyPressSimulator.simulateKeyPress(
                    key: LogicalKeyboardKey.f1,
                    modifiers: [
                      ModifierKey.controlModifier,
                    ],
                  );
                  await keyPressSimulator.simulateKeyPress(
                    key: LogicalKeyboardKey.f1,
                    modifiers: [
                      ModifierKey.controlModifier,
                    ],
                    keyDown: false,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildBody(context),
    );
  }
}
