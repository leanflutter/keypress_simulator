import Carbon
import Cocoa
import FlutterMacOS

public class KeypressSimulatorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "keypress_simulator", binaryMessenger: registrar.messenger)
    let instance = KeypressSimulatorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isAccessAllowed":
            isAccessAllowed(call, result: result)
            break
        case "requestAccess":
            requestAccess(call, result: result)
            break
        case "simulateCtrlCKeyPress":
            simulateCtrlCKeyPress(call, result: result)
            break
        case "simulateCtrlVKeyPress":
            simulateCtrlVKeyPress(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func isAccessAllowed(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(AXIsProcessTrusted())
    }
    
    public func requestAccess(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args:[String: Any] = call.arguments as! [String: Any]
        let onlyOpenPrefPane: Bool = args["onlyOpenPrefPane"] as! Bool
        
        if (!onlyOpenPrefPane) {
            let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
            AXIsProcessTrustedWithOptions(options)
        } else  {
            let prefpaneUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            NSWorkspace.shared.open(prefpaneUrl)
        }
        result(true)
    }
    
    public func simulateCtrlCKeyPress(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let eventKeyDown = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(UInt32(kVK_ANSI_C)), keyDown: true);
        eventKeyDown!.flags = CGEventFlags.maskCommand;
        eventKeyDown!.post(tap: .cgAnnotatedSessionEventTap);
        
        let eventKeyUp = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(UInt32(kVK_ANSI_C)), keyDown: false);
        eventKeyUp!.flags = CGEventFlags.maskCommand;
        eventKeyUp!.post(tap: .cgAnnotatedSessionEventTap);
        result(true)
    }
    
    public func simulateCtrlVKeyPress(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let eventKeyDown = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(UInt32(kVK_ANSI_V)), keyDown: true);
        eventKeyDown!.flags = CGEventFlags.maskCommand;
        eventKeyDown!.post(tap: .cgAnnotatedSessionEventTap);
        
        let eventKeyUp = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(UInt32(kVK_ANSI_V)), keyDown: false);
        eventKeyUp!.flags = CGEventFlags.maskCommand;
        eventKeyUp!.post(tap: .cgAnnotatedSessionEventTap);
        result(true)
    }
}
