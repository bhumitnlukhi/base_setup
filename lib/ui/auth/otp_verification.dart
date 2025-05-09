import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/auth/mobile/otp_verification_mobile.dart';
import 'package:odigo_vendor/ui/auth/web/otp_verification_web.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class OtpVerification extends StatelessWidget with BaseStatelessWidget {
  final String? email;
  final ScreenName? screenName;

  OtpVerification({Key? key, this.email, this.screenName}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return OtpVerificationMobile(
          email: email,
        );
      },
      desktop: (BuildContext context) {
        return OtpVerificationWeb(email: email, screenName: screenName);
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape ? OtpVerificationWeb(email: email) : OtpVerificationMobile(email: email,);
      //     },
      //   );
      // },
    );
  }
}
