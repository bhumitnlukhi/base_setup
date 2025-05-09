import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/auth/web/helper/otp_verification_form_web.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/robot_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';

class OtpVerificationWeb extends ConsumerStatefulWidget {
  final String? email;
  final ScreenName? screenName;

  const OtpVerificationWeb({Key? key, this.email, this.screenName}) : super(key: key);

  @override
  ConsumerState<OtpVerificationWeb> createState() => _OtpVerificationWebState();
}

class _OtpVerificationWebState extends ConsumerState<OtpVerificationWeb> {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final otpVerificationWatch = ref.watch(otpVerificationController);
      // final loginWatch = ref.watch(loginController);
      final forgotPasswordWatch = ref.read(forgotPasswordController);
      otpVerificationWatch.disposeController(isNotify: true);
      forgotPasswordWatch.emailController.text = getCookie(keyResetPasswordEmail) ?? '';
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final forgotPasswordWatch = ref.watch(forgotPasswordController);
    return Row(
      children: [
        const Expanded(child: RobotWidget()),
        Expanded(
            child: OtpVerificationFormWeb(
          email: (widget.email != null && widget.email != '') ? widget.email : forgotPasswordWatch.emailController.text,
          screenName: widget.screenName,
        ))
      ],
    );
  }
}
