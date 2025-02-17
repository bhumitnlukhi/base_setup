import 'package:flutter_base_setup/framework/utility/session.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool isDarkMode = (Session.getIsAppThemeDark() ?? false);

  static const Color primary = Color(0xff1A2D31);
  static const Color lightPrimary = Color(0xff3F4F52);
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff000000);
  static const Color green3A4161 = Color(0xff3A4161);
  static const Color greyF7F8F8 = Color(0xffF7F8F8);
  static const Color black070707 = Color(0xff070707);
  static const Color black162A33 = Color(0xff162A33);
  static const Color lightGrey = Color(0xffE8E8EC);
  static const Color darkGreen = Color(0xff5B6F70);
  static const Color scaffoldBG = Color(0xffFFFFFF);
  static const Color bg1A2D3170 = Color(0x1A2D3170);
  static const Color fontLight = Color(0xff8B8B8B);
  static const Color lightGreenC5CCC4 = Color(0xffC5CCC4);
  static const Color lightGreen55C5CCC4 = Color(0x33C5CCC4);

  static const Color grey5B5B5B = Color(0xff5B5B5B);
  static const Color greyCFCFCF = Color(0xffCFCFCF);
  static const Color grey8A8A8A = Color(0xff8A8A8A);
  static const Color greyE6E6E6 = Color(0xffE6E6E6);
  static const Color greyFCFCFC = Color(0xffFCFCFC);
  static const Color grey6B6B6B = Color(0xff6B6B6B);
  static const Color greyF6F6F6 = Color(0xffF6F6F6);
  static const Color grey2B2B2B = Color(0xff2B2B2B);
  static const Color grey979FAD = Color(0xff979FAD);
  static const Color greyD5D5D5 = Color(0xffD5D5D5);
  static const Color greyF4F6F6 = Color(0xffF4F6F6);
  static const Color greyF8F8F8 = Color(0xffF8F8F8);
  static const Color pinch = Color(0xffDAA16A);
  static const Color yellow = Color(0xffFFB156);
  static const Color blue3E565B = Color(0xff3E565B);
  static const Color transparent = Color(0x00000000);
  static const Color red = Color(0xffE34850);
  static const Color lightRed = Color(0xffFA6063);
  static const Color blue = Color(0xff007AFF);
  static const Color greyFBFBFB = Color(0xffFBFBFB);
  static const Color greyD9D9D9 = Color(0xffD9D9D9);
  static const Color grey55D9D9D9 = Color(0x55D9D9D9);
  static const Color stepColorDisabled = Color(0xffC5CCC4);
  static const Color stepColorEnabled = Color(0xff5B6F70);
  static const Color greyButton = Color(0xFFF7F8F8);
  static const Color greyC5CCC4 = Color(0xFFC5CCC4);
  static const Color selectedDropdownBackground = Color(0x225B6F70);
  static const Color greenTicketResolved = Color(0xFF09CB29);


  static MaterialColor colorPrimary = MaterialColor(0xff1A2D31, colorSwathes);

  static Map<int, Color> colorSwathes = {
    50: const Color.fromRGBO(26, 45, 49, .1),
    100: const Color.fromRGBO(26, 45, 49, .2),
    200: const Color.fromRGBO(26, 45, 49, .3),
    300: const Color.fromRGBO(26, 45, 49, .4),
    400: const Color.fromRGBO(26, 45, 49, .5),
    500: const Color.fromRGBO(26, 45, 49, .6),
    600: const Color.fromRGBO(26, 45, 49, .7),
    700: const Color.fromRGBO(26, 45, 49, .8),
    800: const Color.fromRGBO(26, 45, 49, .9),
    900: const Color.fromRGBO(26, 45, 49, 1),
  };

  static Color textByTheme() => isDarkMode ? white : primary;

  static Color textByLightPrimary() => isDarkMode ? darkGreen : primary;

  static Color textGreyByTheme() => isDarkMode ? white : white;

  static Color searchFontByTheme() => isDarkMode ? primary : white;

  static Color buttonBGGreyByTheme() => isDarkMode ? primary : white;

  static Color imageColorByTheme() => isDarkMode ? primary : white;

  static Color drawerBgByTheme() => isDarkMode ? black : scaffoldBG;

  static Color textMainFontByTheme() => isDarkMode ? white : primary;

  static Color whiteBlackByTheme() => isDarkMode ? white : black;

  static Color textLightGreyByTheme() => isDarkMode ? white : grey5B5B5B;

  static Color darkByScaffoldTheme() => isDarkMode ? black : white;

  static Color scaffoldBGByTheme() => isDarkMode ? black : scaffoldBG;

  static Color greyScaffoldBGByTheme() => isDarkMode ? black : greyFBFBFB;

  static Color textDarkGreyByTheme() => isDarkMode ? grey5B5B5B : primary;

  static Color cardBGByTheme() => isDarkMode ? grey5B5B5B : white;

  static Color buttonFGByTheme(bool isOn) => isOn ? white : isDarkMode ? white : primary;

  static Color buttonBGByTheme(bool isOn) => isOn ? isDarkMode ? primary : white : isDarkMode ? primary : grey5B5B5B;

  static Color buttonBorderByTheme() => isDarkMode ? white : primary;

  static Color dividerByTheme() => isDarkMode ? white : grey5B5B5B;

  static Color dialogBGByTheme() => isDarkMode ? white : black;

  static Color textFieldTextByTheme() => isDarkMode ? primary : grey5B5B5B;

  static Color textFieldBorderColorByTheme() => isDarkMode ? primary : grey5B5B5B;

  static Color textFieldDisableBorderColorByTheme() => isDarkMode ? white : transparent;

  static Color suggestionTextByTheme() => isDarkMode ? primary : grey8A8A8A;

  static Color whiteBlackNewByTheme() => isDarkMode ? white : grey8A8A8A;

  static Color blackWhiteByTheme() => isDarkMode ? white : black;

  static Color blackNewLightPurpleByTheme() => isDarkMode ? black : primary;

  static Color darkPurpleWhiteByTheme() => isDarkMode ? white : primary;

  static Color primaryWhiteByTheme() => isDarkMode ? white : primary;

  static Color whiteGreyNewByTheme() => isDarkMode ? white : black;

  static Color greyTransparentByTheme() => isDarkMode ? transparent : grey8A8A8A;

  static Color greyNewWhiteByTheme() => isDarkMode ? white : grey8A8A8A;

  static Color darkGreyByTheme() => isDarkMode ? grey2B2B2B : greyF6F6F6;

  static Color lightGreyByTheme() => isDarkMode ? white : grey2B2B2B;

  static Color textWhiteByNewBlack() => isDarkMode ? white : black070707;

  static Color textWhiteByNewBlack2() => isDarkMode ? white : black162A33;

  static Color cardBGDarkGrey() => isDarkMode ? grey5B5B5B : greyF7F8F8;

  static Color textByLightGreen() => isDarkMode ? white : darkGreen ;

// static Color textByTheme() => isDarkMode ? white : primary;
}
