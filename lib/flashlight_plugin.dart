
import 'flashlight_plugin_platform_interface.dart';

class FlashlightPlugin {
  static Future<bool> onLight() {
    return FlashlightPluginPlatform.instance.toggle();
  }
}
