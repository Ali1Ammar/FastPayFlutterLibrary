import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fastpay_flutter_sdk_platform_interface.dart';

/// An implementation of [FastpayFlutterSdkPlatform] that uses method channels.
class MethodChannelFastpayFlutterSdk extends FastpayFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fastpay_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
