import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationMobile extends ConsumerStatefulWidget {
  final String? email;
  const OtpVerificationMobile({Key? key,this.email}) : super(key: key);

  @override
  ConsumerState<OtpVerificationMobile> createState() =>
      _OtpVerificationMobileState();
}

class _OtpVerificationMobileState extends ConsumerState<OtpVerificationMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final otpVerificationWatch = ref.watch(otpVerificationController);
      //otpVerificationWatch.disposeController(isNotify : true);
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
    return Container();
  }


}
