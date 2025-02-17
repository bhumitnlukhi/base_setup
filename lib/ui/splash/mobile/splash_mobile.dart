import 'package:flutter_base_setup/ui/utils/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashMobile extends ConsumerStatefulWidget {
  const SplashMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashMobile> createState() => _SplashMobileState();
}

class _SplashMobileState extends ConsumerState<SplashMobile> {

  ///Init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 500), () {
        // ref.read(navigationStackController).push(const NavigationStackItem.step1());
      });
    });
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
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to our application',
          style: TextStyles.semiBold.copyWith(fontSize: 20.sp),
        ),
      ),
    );
  }
}
