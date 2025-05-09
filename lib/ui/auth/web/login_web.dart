import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/ui/auth/web/helper/details_widget.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/robot_widget.dart';

class LoginWeb extends ConsumerStatefulWidget {
  const LoginWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends ConsumerState<LoginWeb> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final loginWatch = ref.watch(loginController);
      final otpWatch = ref.watch(otpVerificationController);
      loginWatch.disposeController(isNotify : true);
      otpWatch.disposeController(isNotify: true);
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
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return const Row(
      children: [
        Expanded(child: RobotWidget()),
        Expanded(child: DetailsWidget())
      ],
    );
  }


}
