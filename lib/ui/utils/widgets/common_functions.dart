// TODO Implement this library.


// Get Device Id
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

getDeviceIdPlatformWise() async {
  if(kIsWeb){
    WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    Session.saveLocalData(keyDeviceId, '${webBrowserInfo.hardwareConcurrency.toString().removeWhiteSpace.toLowerCase()}${webBrowserInfo.appCodeName.toString().removeWhiteSpace.toLowerCase()}${Session.getUserUuid()}-vendor');
  }else if (getIsIOSPlatform()) {
    final iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    Session.saveLocalData(keyDeviceId, iosDeviceInfo.identifierForVendor);
    showLog('Device ID  ${Session.getDeviceID()}');
  } else {
    AndroidId androidIdPlugin = const AndroidId();
    final String? androidId = await androidIdPlugin.getId();
    Session.saveLocalData(keyDeviceId, androidId);
  }
}