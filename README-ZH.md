# keypress_simulator

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url] ![][visits-count-image] 

[pub-image]: https://img.shields.io/pub/v/keypress_simulator.svg
[pub-url]: https://pub.dev/packages/keypress_simulator

[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb

[visits-count-image]: https://img.shields.io/badge/dynamic/json?label=Visits%20Count&query=value&url=https://api.countapi.xyz/hit/leanflutter.keypress_simulator/visits

这个插件允许 Flutter 桌面应用模拟按键操作。

---

[English](./README.md) | 简体中文

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [keypress_simulator](#keypress_simulator)
  - [平台支持](#平台支持)
  - [快速开始](#快速开始)
    - [安装](#安装)
    - [用法](#用法)
  - [谁在用使用它？](#谁在用使用它)
  - [许可证](#许可证)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 平台支持

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|   ➖   |   ✔️   |    ✔️    |

## 快速开始

### 安装

将此添加到你的软件包的 pubspec.yaml 文件：

```yaml
dependencies:
  keypress_simulator: ^0.1.0
```

或

```yaml
dependencies:
  keypress_simulator:
    git:
      url: https://github.com/leanflutter/keypress_simulator.git
      ref: main
```

### 用法

```dart
import 'package:keypress_simulator/keypress_simulator.dart';

// 1. Simulate pressing ⌘ + C

// 1.1 Simulate key down
await keyPressSimulator.simulateKeyPress(
  key: LogicalKeyboardKey.keyC,
  modifiers: [ModifierKey.metaModifier],
);

// 1.2 Simulate key up
await keyPressSimulator.simulateKeyPress(
  key: LogicalKeyboardKey.keyC,
  modifiers: [ModifierKey.metaModifier],
  keyDown: false,
);

// 2. Simulate long pressing ⌘ + space

// 2.1. Simulate key down
await keyPressSimulator.simulateKeyPress(
  key: LogicalKeyboardKey.space,
  modifiers: [
    ModifierKey.metaModifier,
  ],
);

await Future.delayed(const Duration(seconds: 5));
                
// 2.2. Simulate key up
await keyPressSimulator.simulateKeyPress(
  key: LogicalKeyboardKey.space,
  modifiers: [
    ModifierKey.metaModifier,
  ],
  keyDown: false,
);
```

> 请看这个插件的示例应用，以了解完整的例子。

## 谁在用使用它？

- [Biyi (比译)](https://biyidev.com/) - 一个便捷的翻译和词典应用程序。

## 许可证

[MIT](./LICENSE)
