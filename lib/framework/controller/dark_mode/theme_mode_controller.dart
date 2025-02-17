import 'package:flutter_base_setup/framework/utility/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider =
    ChangeNotifierProvider.autoDispose((ref) => ThemeModeController());

class ThemeModeController extends ChangeNotifier {
  var themeMode =
      (Session.getIsAppThemeDark() ?? false) ? ThemeMode.dark : ThemeMode.light;

  void updateThemeMode(ThemeMode themeMode) {
    this.themeMode = themeMode;
    Session.setIsThemeModeDark(themeMode == ThemeMode.dark ? true : false);
    notifyListeners();
  }
}
