//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <hotkey_manager/hotkey_manager_plugin.h>
#include <keypress_simulator_windows/keypress_simulator_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  HotkeyManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HotkeyManagerPlugin"));
  KeypressSimulatorWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("KeypressSimulatorWindowsPluginCApi"));
}
