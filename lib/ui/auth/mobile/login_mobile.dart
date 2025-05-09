import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginMobile extends ConsumerStatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends ConsumerState<LoginMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final loginWatch = ref.watch(loginController);
      //loginWatch.disposeController(isNotify : true);
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
