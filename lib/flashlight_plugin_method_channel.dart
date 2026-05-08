import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flashlight_plugin_platform_interface.dart';

/// An implementation of [FlashlightPluginPlatform] that uses method channels.
class MethodChannelFlashlightPlugin extends FlashlightPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flashlight_plugin');

  @override
  Future<bool> toggle() async {
    final enabled = await methodChannel.invokeMethod<bool>('toggle');
    return enabled ?? false;
  }
}
