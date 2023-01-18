import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:proflow/providers/tools_provider.dart';
import 'package:proflow/shared.dart';

class HotKeys {
  Map<HotKey, Function> hotKeyFuncts = {};
  Map<HotKey, Function> get keyFunctList => hotKeyFuncts;

  static Future<void> setKeys(HotKey hotKey, Function keyFunction) async {
    await hotKeyManager.unregister(hotKey);
    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (hotKey) {
        keyFunction();
      },
      // Only works on macOS.
      keyUpHandler: (hotKey) {},
    );
  }

  Future<void> setInitKeys(Tools tool) async {
    await hotKeyManager.unregisterAll();
    // print(tool.toString());
    hotKeyFuncts = {
      HotKey(KeyCode.escape, scope: HotKeyScope.inapp, identifier: "ESC"):
          tool.animateExitTool,
      HotKey(KeyCode.arrowLeft,
          scope: HotKeyScope.inapp,
          identifier: "ARROWLEFT"): () => tool.nav(-1),
      HotKey(KeyCode.arrowRight,
          scope: HotKeyScope.inapp,
          identifier: "ARROWRIGHT"): () => tool.nav(1),
      HotKey(KeyCode.enter, scope: HotKeyScope.inapp, identifier: "ENTER"):
          tool.enter,
      HotKey(KeyCode.arrowLeft,
          modifiers: [KeyModifier.control],
          scope: HotKeyScope.inapp,
          identifier: "CTRLLEFT"): () => tool.nav(null, index: 0),
      HotKey(KeyCode.arrowRight,
              modifiers: [KeyModifier.control],
              scope: HotKeyScope.inapp,
              identifier: "CTRLRIGHT"):
          () => tool.nav(null, index: tool.savedTools.length - 1),
    };

    for (HotKey key in hotKeyFuncts.keys) {
      Function? keyFunction = hotKeyFuncts[key];
      // print(key.toString());
      await HotKeys.setKeys(key, () {
        if (appWindow.isVisible) {
          keyFunction!();
        }
      });
    }
  }
}
