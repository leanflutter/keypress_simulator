#include "include/keypress_simulator/keypress_simulator_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <map>
#include <memory>
#include <sstream>

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

namespace {

const std::unordered_map<std::string, UINT> kKnownVirtualKeyCodes = {
    std::make_pair("none", 0),
    std::make_pair("hyper", 0),
    std::make_pair("superKey", 0),
    std::make_pair("fnLock", 0),
    std::make_pair("suspend", 0),
    std::make_pair("resume", 0),
    std::make_pair("turbo", 0),
    std::make_pair("privacyScreenToggle", 0),
    std::make_pair("sleep", VK_SLEEP),
    std::make_pair("wakeUp", 0),
    std::make_pair("displayToggleIntExt", 0),
    std::make_pair("usbReserved", 0),
    std::make_pair("usbErrorRollOver", 0),
    std::make_pair("usbPostFail", 0),
    std::make_pair("usbErrorUndefined", 0),
    std::make_pair("keyA", 0x41),
    std::make_pair("keyB", 0x42),
    std::make_pair("keyC", 0x43),
    std::make_pair("keyD", 0x44),
    std::make_pair("keyE", 0x45),
    std::make_pair("keyF", 0x46),
    std::make_pair("keyG", 0x47),
    std::make_pair("keyH", 0x48),
    std::make_pair("keyI", 0x49),
    std::make_pair("keyJ", 0x4A),
    std::make_pair("keyK", 0x4B),
    std::make_pair("keyL", 0x4C),
    std::make_pair("keyM", 0x4D),
    std::make_pair("keyN", 0x4E),
    std::make_pair("keyO", 0x4F),
    std::make_pair("keyP", 0x50),
    std::make_pair("keyQ", 0x51),
    std::make_pair("keyR", 0x52),
    std::make_pair("keyS", 0x53),
    std::make_pair("keyT", 0x54),
    std::make_pair("keyU", 0x55),
    std::make_pair("keyV", 0x56),
    std::make_pair("keyW", 0x57),
    std::make_pair("keyX", 0x58),
    std::make_pair("keyY", 0x59),
    std::make_pair("keyZ", 0x5A),
    std::make_pair("digit1", 0x31),
    std::make_pair("digit2", 0x32),
    std::make_pair("digit3", 0x33),
    std::make_pair("digit4", 0x34),
    std::make_pair("digit5", 0x35),
    std::make_pair("digit6", 0x36),
    std::make_pair("digit7", 0x37),
    std::make_pair("digit8", 0x38),
    std::make_pair("digit9", 0x39),
    std::make_pair("digit0", 0x30),
    std::make_pair("enter", VK_RETURN),
    std::make_pair("escape", VK_ESCAPE),
    std::make_pair("backspace", VK_BACK),
    std::make_pair("tab", VK_TAB),
    std::make_pair("space", VK_SPACE),
    std::make_pair("minus", VK_OEM_MINUS),
    std::make_pair("equal", 0),
    std::make_pair("bracketLeft", 0),
    std::make_pair("bracketRight", 0),
    std::make_pair("backslash", 0),
    std::make_pair("semicolon", 0),
    std::make_pair("quote", 0),
    std::make_pair("backquote", 0),
    std::make_pair("comma", 0),
    std::make_pair("period", 0),
    std::make_pair("slash", 0),
    std::make_pair("capsLock", VK_CAPITAL),
    std::make_pair("f1", VK_F1),
    std::make_pair("f2", VK_F2),
    std::make_pair("f3", VK_F3),
    std::make_pair("f4", VK_F4),
    std::make_pair("f5", VK_F5),
    std::make_pair("f6", VK_F6),
    std::make_pair("f7", VK_F7),
    std::make_pair("f8", VK_F8),
    std::make_pair("f9", VK_F9),
    std::make_pair("f10", VK_F10),
    std::make_pair("f11", VK_F11),
    std::make_pair("f12", VK_F12),
    std::make_pair("printScreen", VK_SNAPSHOT),
    std::make_pair("scrollLock", VK_SCROLL),
    std::make_pair("pause", VK_PAUSE),
    std::make_pair("insert", VK_INSERT),
    std::make_pair("home", VK_HOME),
    std::make_pair("pageUp", VK_PRIOR),
    std::make_pair("delete", VK_DELETE),
    std::make_pair("end", VK_END),
    std::make_pair("pageDown", VK_NEXT),
    std::make_pair("arrowRight", VK_RIGHT),
    std::make_pair("arrowLeft", VK_LEFT),
    std::make_pair("arrowDown", VK_DOWN),
    std::make_pair("arrowUp", VK_UP),
    std::make_pair("numLock", VK_NUMLOCK),
    std::make_pair("numpadDivide", VK_DIVIDE),
    std::make_pair("numpadMultiply", VK_MULTIPLY),
    std::make_pair("numpadSubtract", VK_SUBTRACT),
    std::make_pair("numpadAdd", VK_ADD),
    std::make_pair("numpadEnter", 0),
    std::make_pair("numpad1", VK_NUMPAD1),
    std::make_pair("numpad2", VK_NUMPAD2),
    std::make_pair("numpad3", VK_NUMPAD3),
    std::make_pair("numpad4", VK_NUMPAD4),
    std::make_pair("numpad5", VK_NUMPAD5),
    std::make_pair("numpad6", VK_NUMPAD6),
    std::make_pair("numpad7", VK_NUMPAD7),
    std::make_pair("numpad8", VK_NUMPAD8),
    std::make_pair("numpad9", VK_NUMPAD9),
    std::make_pair("numpad0", VK_NUMPAD0),
    std::make_pair("numpadDecimal", VK_DECIMAL),
    std::make_pair("intlBackslash", 0),
    std::make_pair("contextMenu", 0),
    std::make_pair("power", 0),
    std::make_pair("numpadEqual", 0),
    std::make_pair("f13", VK_F13),
    std::make_pair("f14", VK_F14),
    std::make_pair("f15", VK_F15),
    std::make_pair("f16", VK_F16),
    std::make_pair("f17", VK_F17),
    std::make_pair("f18", VK_F18),
    std::make_pair("f19", VK_F19),
    std::make_pair("f20", VK_F20),
    std::make_pair("f21", VK_F21),
    std::make_pair("f22", VK_F22),
    std::make_pair("f23", VK_F23),
    std::make_pair("f24", VK_F24),
    std::make_pair("open", 0),
    std::make_pair("help", VK_HELP),
    std::make_pair("select", VK_SELECT),
    std::make_pair("again", 0),
    std::make_pair("undo", 0),
    std::make_pair("cut", 0),
    std::make_pair("copy", 0),
    std::make_pair("paste", 0),
    std::make_pair("find", 0),
    std::make_pair("audioVolumeMute", VK_VOLUME_MUTE),
    std::make_pair("audioVolumeUp", VK_VOLUME_UP),
    std::make_pair("audioVolumeDown", VK_VOLUME_DOWN),
    std::make_pair("numpadComma", 0),
    std::make_pair("intlRo", 0),
    std::make_pair("kanaMode", 0),
    std::make_pair("intlYen", 0),
    std::make_pair("convert", 0),
    std::make_pair("nonConvert", 0),
    std::make_pair("lang1", 0),
    std::make_pair("lang2", 0),
    std::make_pair("lang3", 0),
    std::make_pair("lang4", 0),
    std::make_pair("lang5", 0),
    std::make_pair("abort", 0),
    std::make_pair("props", 0),
    std::make_pair("numpadParenLeft", 0),
    std::make_pair("numpadParenRight", 0),
    std::make_pair("numpadBackspace", 0),
    std::make_pair("numpadMemoryStore", 0),
    std::make_pair("numpadMemoryRecall", 0),
    std::make_pair("numpadMemoryClear", 0),
    std::make_pair("numpadMemoryAdd", 0),
    std::make_pair("numpadMemorySubtract", 0),
    std::make_pair("numpadSignChange", 0),
    std::make_pair("numpadClear", 0),
    std::make_pair("numpadClearEntry", 0),
    std::make_pair("controlLeft", VK_LCONTROL),
    std::make_pair("shiftLeft", VK_LSHIFT),
    std::make_pair("altLeft", 0),
    std::make_pair("metaLeft", VK_LWIN),
    std::make_pair("controlRight", VK_RCONTROL),
    std::make_pair("shiftRight", VK_RSHIFT),
    std::make_pair("altRight", 0),
    std::make_pair("metaRight", VK_RWIN),
    std::make_pair("info", 0),
    std::make_pair("closedCaptionToggle", 0),
    std::make_pair("brightnessUp", 0),
    std::make_pair("brightnessDown", 0),
    std::make_pair("brightnessToggle", 0),
    std::make_pair("brightnessMinimum", 0),
    std::make_pair("brightnessMaximum", 0),
    std::make_pair("brightnessAuto", 0),
    std::make_pair("kbdIllumUp", 0),
    std::make_pair("kbdIllumDown", 0),
    std::make_pair("mediaLast", 0),
    std::make_pair("launchPhone", 0),
    std::make_pair("programGuide", 0),
    std::make_pair("exit", 0),
    std::make_pair("channelUp", 0),
    std::make_pair("channelDown", 0),
    std::make_pair("mediaPlay", VK_MEDIA_PLAY_PAUSE),
    std::make_pair("mediaPause", VK_MEDIA_PLAY_PAUSE),
    std::make_pair("mediaRecord", 0),
    std::make_pair("mediaFastForward", 0),
    std::make_pair("mediaRewind", 0),
    std::make_pair("mediaTrackNext", VK_MEDIA_NEXT_TRACK),
    std::make_pair("mediaTrackPrevious", VK_MEDIA_PREV_TRACK),
    std::make_pair("mediaStop", VK_MEDIA_STOP),
    std::make_pair("eject", 0),
    std::make_pair("mediaPlayPause", 0),
    std::make_pair("speechInputToggle", 0),
    std::make_pair("bassBoost", 0),
    std::make_pair("mediaSelect", VK_LAUNCH_MEDIA_SELECT),
    std::make_pair("launchWordProcessor", 0),
    std::make_pair("launchSpreadsheet", 0),
    std::make_pair("launchMail", VK_LAUNCH_MAIL),
    std::make_pair("launchContacts", 0),
    std::make_pair("launchCalendar", 0),
    std::make_pair("launchApp2", VK_LAUNCH_APP2),
    std::make_pair("launchApp1", VK_LAUNCH_APP1),
    std::make_pair("launchInternetBrowser", 0),
    std::make_pair("logOff", 0),
    std::make_pair("lockScreen", 0),
    std::make_pair("launchControlPanel", 0),
    std::make_pair("selectTask", 0),
    std::make_pair("launchDocuments", 0),
    std::make_pair("spellCheck", 0),
    std::make_pair("launchKeyboardLayout", 0),
    std::make_pair("launchScreenSaver", 0),
    std::make_pair("launchAssistant", 0),
    std::make_pair("launchAudioBrowser", 0),
    std::make_pair("newKey", 0),
    std::make_pair("close", 0),
    std::make_pair("save", 0),
    std::make_pair("print", VK_PRINT),
    std::make_pair("browserSearch", VK_BROWSER_SEARCH),
    std::make_pair("browserHome", VK_BROWSER_HOME),
    std::make_pair("browserBack", VK_BROWSER_BACK),
    std::make_pair("browserForward", VK_BROWSER_FORWARD),
    std::make_pair("browserStop", VK_BROWSER_STOP),
    std::make_pair("browserRefresh", VK_BROWSER_REFRESH),
    std::make_pair("browserFavorites", VK_BROWSER_FAVORITES),
    std::make_pair("zoomIn", 0),
    std::make_pair("zoomOut", 0),
    std::make_pair("zoomToggle", 0),
    std::make_pair("redo", 0),
    std::make_pair("mailReply", 0),
    std::make_pair("mailForward", 0),
    std::make_pair("mailSend", 0),
    std::make_pair("keyboardLayoutSelect", 0),
    std::make_pair("showAllWindows", 0),
    std::make_pair("gameButton1", 0),
    std::make_pair("gameButton2", 0),
    std::make_pair("gameButton3", 0),
    std::make_pair("gameButton4", 0),
    std::make_pair("gameButton5", 0),
    std::make_pair("gameButton6", 0),
    std::make_pair("gameButton7", 0),
    std::make_pair("gameButton8", 0),
    std::make_pair("gameButton9", 0),
    std::make_pair("gameButton10", 0),
    std::make_pair("gameButton11", 0),
    std::make_pair("gameButton12", 0),
    std::make_pair("gameButton13", 0),
    std::make_pair("gameButton14", 0),
    std::make_pair("gameButton15", 0),
    std::make_pair("gameButton16", 0),
    std::make_pair("gameButtonA", 0),
    std::make_pair("gameButtonB", 0),
    std::make_pair("gameButtonC", 0),
    std::make_pair("gameButtonLeft1", 0),
    std::make_pair("gameButtonLeft2", 0),
    std::make_pair("gameButtonMode", 0),
    std::make_pair("gameButtonRight1", 0),
    std::make_pair("gameButtonRight2", 0),
    std::make_pair("gameButtonSelect", 0),
    std::make_pair("gameButtonStart", 0),
    std::make_pair("gameButtonThumbLeft", 0),
    std::make_pair("gameButtonThumbRight", 0),
    std::make_pair("gameButtonX", 0),
    std::make_pair("gameButtonY", 0),
    std::make_pair("gameButtonZ", 0),
    std::make_pair("fn", 0),
    std::make_pair("shift", VK_SHIFT),
    std::make_pair("meta", VK_LWIN),
    std::make_pair("alt", VK_MENU),
    std::make_pair("control", VK_CONTROL),
};

const EncodableValue* ValueOrNull(const EncodableMap& map, const char* key) {
  auto it = map.find(EncodableValue(key));
  if (it == map.end()) {
    return nullptr;
  }
  return &(it->second);
}

class KeypressSimulatorPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  KeypressSimulatorPlugin();

  virtual ~KeypressSimulatorPlugin();

 private:
  void KeypressSimulatorPlugin::SimulateKeyPress(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

// static
void KeypressSimulatorPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "keypress_simulator",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<KeypressSimulatorPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

KeypressSimulatorPlugin::KeypressSimulatorPlugin() {}

KeypressSimulatorPlugin::~KeypressSimulatorPlugin() {}

void KeypressSimulatorPlugin::SimulateKeyPress(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const EncodableMap& args = std::get<EncodableMap>(*method_call.arguments());

  std::string key = std::get<std::string>(args.at(EncodableValue("key")));
  std::vector<std::string> modifiers;
  bool keyDown = std::get<bool>(args.at(EncodableValue("keyDown")));

  EncodableList key_modifier_list =
      std::get<EncodableList>(args.at(EncodableValue("modifiers")));
  for (flutter::EncodableValue key_modifier_value : key_modifier_list) {
    std::string key_modifier = std::get<std::string>(key_modifier_value);
    modifiers.push_back(key_modifier);
  }

  // const int inputLength = modifiers.size() + 1;
  INPUT input[6];

  for (int32_t i = 0; i < modifiers.size(); i++) {
    if (modifiers[i].compare("shiftModifier") == 0) {
      input[i].ki.wVk = VK_SHIFT;
    } else if (modifiers[i].compare("controlModifier") == 0) {
      input[i].ki.wVk = VK_CONTROL;
    } else if (modifiers[i].compare("altModifier") == 0) {
      input[i].ki.wVk = VK_MENU;
    } else if (modifiers[i].compare("metaModifier") == 0) {
      input[i].ki.wVk = VK_LWIN;
    }

    input[i].ki.dwFlags = keyDown ? 0 : KEYEVENTF_KEYUP;
    input[i].type = INPUT_KEYBOARD;
  }

  int keyIndex = static_cast<int>(modifiers.size());
  input[keyIndex].ki.wVk = static_cast<WORD>(kKnownVirtualKeyCodes.at(key));
  input[keyIndex].ki.dwFlags = keyDown ? 0 : KEYEVENTF_KEYUP;
  input[keyIndex].type = INPUT_KEYBOARD;

  // Send key sequence to system
  SendInput(static_cast<UINT>(std::size(input)), input, sizeof(INPUT));

  result->Success(flutter::EncodableValue(true));
}

void KeypressSimulatorPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("simulateKeyPress") == 0) {
    SimulateKeyPress(method_call, std::move(result));
  } else {
    result->NotImplemented();
  }
}

}  // namespace

void KeypressSimulatorPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  KeypressSimulatorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
