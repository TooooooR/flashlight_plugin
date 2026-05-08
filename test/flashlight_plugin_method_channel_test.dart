import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flashlight_plugin/flashlight_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlashlightPlugin platform = MethodChannelFlashlightPlugin();
  const MethodChannel channel = MethodChannel('flashlight_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'toggle') {
            return true;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('toggle', () async {
    expect(await platform.toggle(), true);
  });
}
