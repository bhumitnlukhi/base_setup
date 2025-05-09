import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/reset_password_controller.dart';
import 'package:odigo_vendor/ui/auth/web/helper/reset_password_form_web.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/robot_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';

class ResetPasswordWeb extends ConsumerStatefulWidget {
  const ResetPasswordWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<ResetPasswordWeb> createState() => _ResetPasswordWebState();
}

class _ResetPasswordWebState extends ConsumerState<ResetPasswordWeb> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final resetPasswordWatch = ref.watch(resetPasswordController);
      resetPasswordWatch.disposeController(isNotify : true);
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
    return const Row(
      children: [
        Expanded(child: RobotWidget()),
        Expanded(child: ResetPasswordFormWeb()),
      ],
    );
  }


}
