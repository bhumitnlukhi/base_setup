import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileMobile extends ConsumerStatefulWidget {
  const ProfileMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends ConsumerState<ProfileMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final profileWatch = ref.watch(profileController);
      //profileWatch.disposeController(isNotify : true);
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
