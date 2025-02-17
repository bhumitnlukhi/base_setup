import 'package:flutter_base_setup/ui/splash/mobile/splash_mobile.dart';
import 'package:flutter_base_setup/ui/splash/web/splash_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {

  ///Init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   Future.delayed(const Duration(milliseconds: 500), () {
    //     // ref.read(navigationStackController).push(const NavigationStackItem.step1());
    //   });
    // });
  }

  ///Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context){
          return const SplashMobile();
        },
        desktop: (BuildContext context){
          return const SplashWeb();
        }
    );
    // return Scaffold(
    //   body: Center(
    //     child: Text(
    //       "Welcome to our application",
    //       style: TextStyles.semiBold.copyWith(fontSize: 20.sp),
    //     ),
    //   ),
    // );
  }
}
