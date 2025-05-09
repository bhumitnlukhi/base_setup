import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/auth/mobile/reset_password_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/reset_password_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResetPassword extends StatelessWidget with BaseStatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const ResetPasswordMobile();
      },
      desktop: (BuildContext context) {
        return const ResetPasswordWeb();
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape ? const ResetPasswordWeb() : const ResetPasswordMobile();
      //     },
      //   );
      // },
    );
  }
}

