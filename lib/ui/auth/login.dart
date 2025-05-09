import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/auth/mobile/login_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/login_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> with BaseConsumerStatefulWidget {
  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const LoginMobile();
      },
      desktop: (BuildContext context) {
        return const LoginWeb();
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape ? const LoginWeb() : const LoginMobile();
      //     },
      //   );
      // },
    );
  }


  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
        } else {
          EasyDebounce.debounce('loginDebounce', const Duration(milliseconds: 50), () {
            final loginWatch = ref.read(loginController);
            if(loginWatch.waitingDialog.currentContext != null) {Navigator.pop(loginWatch.waitingDialog.currentContext!);}

          });
        }
      }
    });
    super.didChangeDependencies();
  }
}

