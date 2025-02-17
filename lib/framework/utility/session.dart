import 'package:flutter_base_setup/ui/routing/navigation_stack_item.dart';
import 'package:flutter_base_setup/ui/routing/stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const String keyAppLanguage = 'keyAppLanguage';
const String keyIsOnBoardingShowed = 'keyIsOnBoardingShowed';
const String keyUserAuthToken = 'keyUserAuthToken';
const String keyDeviceId = 'keyDeviceId';
const String keyUserRefreshToken = 'keyUserRefreshToken';
const String keyDeviceFCMToken = 'keyDeviceFCMToken';
const String keyAppThemeDark = 'keyAppThemeDark';

class Session {
  Session._();

  static var userBox = Hive.box('userBox');

  static String getUserAccessToken() => (userBox.get(keyUserAuthToken) ?? '');

  static String getAppLanguage() => (userBox.get(keyAppLanguage) ?? 'en');

  static bool getIsOnBoardingShowed() =>
      (userBox.get(keyIsOnBoardingShowed) ?? false);

  static String getDeviceID() => (userBox.get(keyDeviceId) ?? '');

  static String getDeviceFCMToken() =>
      (userBox.get(keyDeviceFCMToken) ?? '123456');

  static bool? getIsAppThemeDark() => (userBox.get(keyAppThemeDark));

  ///Save Local Data
  static saveLocalData(String key, value) {
    userBox.put(key, value);
  }

  ///Save Local Data
  static setIsThemeModeDark(value) {
    userBox.put(keyAppThemeDark, value);
  }

  ///Session Logout
  Future sessionLogout(WidgetRef ref) async {
    // String appLanguage = getAppLanguage();
    // String isOnBoarding = getIsOnBoardingShowed();
    // String deviceToken = getDeviceFCMToken();

    await Session.userBox.clear().then((value) {
      // Session.saveLocalData(isGuestUser, true);
      // Session.saveLocalData(showLanguageScreen, false);
      // saveLocalData(KEY_APP_LANGUAGE, appLanguage);
      // saveLocalData(KEY_IS_ONBOARDING_SHOWED, isOnBoarding);
      // saveLocalData(KEY_FCM_DEVICE_TOKEN, deviceToken);
      debugPrint(
          '===========================YOU LOGGED OUT FROM THE APP==============================');

      ref
          .read(navigationStackController)
          .pushAndRemoveAll(const NavigationStackItem.splash());
    });
  }
}
