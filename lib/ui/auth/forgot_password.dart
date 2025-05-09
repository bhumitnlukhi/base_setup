import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/auth/mobile/forgot_password_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/forgot_password_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ForgotPassword extends StatelessWidget with BaseStatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const ForgotPasswordMobile();
      },
      desktop: (BuildContext context) {
        return const ForgotPasswordWeb();
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape ? const ForgotPasswordWeb() : const ForgotPasswordMobile();
      //     },
      //   );
      // },
    );
  }
}

