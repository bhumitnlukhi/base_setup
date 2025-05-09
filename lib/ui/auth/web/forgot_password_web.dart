import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigo_vendor/ui/auth/web/helper/forgot_password_form_web.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/robot_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class ForgotPasswordWeb extends ConsumerStatefulWidget {
  const ForgotPasswordWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordWeb> createState() => _ForgotPasswordWebState();
}

class _ForgotPasswordWebState extends ConsumerState<ForgotPasswordWeb> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final forgotPasswordWatch = ref.watch(forgotPasswordController);
      forgotPasswordWatch.disposeController(isNotify : true);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          ///Common Left Widget for Auth module
          child: RobotWidget(),
        ),
        Expanded(
          child: ForgotPasswordFormWeb(),
        ),
      ],
    );
  }


}
