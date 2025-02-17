
import 'dart:io';

const String appName = 'Base';
bool getIsIOSPlatform() => Platform.isIOS;
bool getIsAppleSignInSupport() => (iosVersion >= 13);
int iosVersion = 11;
String getDeviceType() => getIsIOSPlatform() ? 'iphone' : 'android';