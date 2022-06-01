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
        case "simulateKeyPress":
            simulateKeyPress(call, result: result)
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
    
    public func simulateKeyPress(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args:[String: Any] = call.arguments as! [String: Any]
        
        let key: String? = args["key"] as? String
        let modifiers: Array<String> = args["modifiers"] as! Array<String>
        let keyDown: Bool = args["keyDown"] as! Bool
        
        let event = _createKeyPressEvent(key, modifiers, keyDown);
        event.post(tap: .cghidEventTap);
        result(true)
    }
    
    public func _createKeyPressEvent(_ key: String?, _ modifiers: Array<String>, _ keyDown: Bool) -> CGEvent {
        var keyCode: Int = 0
        if (key != nil) {
            keyCode = KnownLogicalKeys[key!]!;
        }
        let virtualKey: CGKeyCode = CGKeyCode(UInt32(keyCode))
        var flags: CGEventFlags = CGEventFlags()
        
        if (modifiers.contains("shiftModifier")) {
            flags.insert(CGEventFlags.maskShift)
        }
        if (modifiers.contains("controlModifier")) {
            flags.insert(CGEventFlags.maskControl)
        }
        if (modifiers.contains("altModifier")) {
            flags.insert(CGEventFlags.maskAlternate)
        }
        if (modifiers.contains("metaModifier")) {
            flags.insert(CGEventFlags.maskCommand)
        }
        if (modifiers.contains("functionModifier")) {
            flags.insert(CGEventFlags.maskSecondaryFn)
        }
        let eventKeyPress = CGEvent(keyboardEventSource: nil, virtualKey: virtualKey, keyDown: keyDown);
        eventKeyPress!.flags = flags
        return eventKeyPress!
    }
}
