
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_setup/framework/controller/dark_mode/theme_mode_controller.dart';
import 'package:flutter_base_setup/framework/dependency_injection/inject.dart';
import 'package:flutter_base_setup/ui/routing/delegate.dart';
import 'package:flutter_base_setup/ui/routing/parser.dart';
import 'package:flutter_base_setup/ui/routing/stack.dart';
import 'package:flutter_base_setup/ui/utils/const/app_constants.dart';
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';
import 'package:flutter_base_setup/ui/utils/widgets/common_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureMainDependencies(environment: Env.dev);

  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');

  /// Theme For Status Bar & Navigation Bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    /// The color of top status bar.
    ///
    /// Only honored in Android version M and greater.
    statusBarColor: Colors.transparent,

    /// The brightness of the top status bar icons.
    ///
    /// Only honored in Android version M and greater.
    statusBarIconBrightness: Brightness.dark,

    /// The brightness of top status bar.
    ///
    /// Only honored in iOS.
    statusBarBrightness: Brightness.dark,

    /// The color of the system bottom navigation bar.
    ///
    /// Only honored in Android versions O and greater.
    systemNavigationBarColor: AppColors.black,

    /// The brightness of the system navigation bar icons.
    ///
    /// Only honored in Android versions O and greater.
    /// When set to [Brightness.light], the system navigation bar icons are light.
    /// When set to [Brightness.dark], the system navigation bar icons are dark.
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(
    child: EasyLocalization(supportedLocales: const <Locale>[
      Locale('en'),
    ], useOnlyLangCode: true, path: 'lang', child: const MyApp()),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  /// init method
  @override
  void initState() {
    super.initState();
    // _newLocaleDelegate = const AppTranslationsDelegate(newLocale: Locale("en"));
    // application.onLocaleChanged = onLocaleChange;
    // onLocaleChange(const Locale("en", ""));
    // getSelectedLanguage(() => {});

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final darkModeWatch = ref.watch(darkProvider);
      //
      // ///Dark Mode Object
      // var brightness = SchedulerBinding.instance.window.platformBrightness;
      // bool isDarkMode = Session.getIsAppThemeDark() ?? (brightness == Brightness.dark);
      // darkModeWatch.updateIsDarkMode(false, false);
    });
  }

  /// dispose method
  @override
  void dispose() {
    Hive.box('userBox').compact();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeModeController = ref.watch(themeModeProvider);

    /// Theme For Status Bar & Navigation Bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      /// The color of top status bar.
      ///
      /// Only honored in Android version M and greater.
      statusBarColor: Colors.transparent,

      /// The brightness of the top status bar icons.
      ///
      /// Only honored in Android version M and greater.
      statusBarIconBrightness:
      AppColors.isDarkMode ? Brightness.light : Brightness.dark,

      /// The brightness of top status bar.
      ///
      /// Only honored in iOS.
      statusBarBrightness:
      AppColors.isDarkMode ? Brightness.dark : Brightness.light,

      /// The color of the system bottom navigation bar.
      ///
      /// Only honored in Android versions O and greater.
      systemNavigationBarColor:
      AppColors.isDarkMode ? AppColors.white : AppColors.black,

      /// The brightness of the system navigation bar icons.
      ///
      /// Only honored in Android versions O and greater.
      /// When set to [Brightness.light], the system navigation bar icons are light.
      /// When set to [Brightness.dark], the system navigation bar icons are dark.
      systemNavigationBarIconBrightness:
      AppColors.isDarkMode ? Brightness.light : Brightness.dark,
    ));

    return ScreenUtilInit(
        designSize: const Size(375, 815),
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: appName,
            themeMode: themeModeController.themeMode,
            // theme: ThemeStyle.themeData(darkModeWatch.darkTheme, context),
            supportedLocales: EasyLocalization.of(context)!.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: EasyLocalization.of(context)!.locale,
            // home: const SplashScreen(),
            routerDelegate: getIt<MainRouterDelegate>(
                param1: ref.read(navigationStackController)),
            routeInformationParser: getIt<MainRouterInformationParser>(
                param1: ref, param2: context),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppBar(
          title: 'Home',
          isLeadingEnable: false,
        ),
        // appBar: AppBar(
        //   title: Text(widget.title),
        // ),
        body: Container(
          color: AppColors.white,
          child: Center(
            child: Text(
              'Welcome',
              style: TextStyles.bold.copyWith(fontSize: 22.sp),
            ),
          ),
        ));
  }
}
