import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditAgencyProfileDetailMobile extends ConsumerStatefulWidget {
  const EditAgencyProfileDetailMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditAgencyProfileDetailMobile> createState() => _EditAgencyProfileDetailMobileState();
}

class _EditAgencyProfileDetailMobileState extends ConsumerState<EditAgencyProfileDetailMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final editAgencyProfileDetailWatch = ref.watch(editAgencyProfileDetailController);
      //editAgencyProfileDetailWatch.disposeController(isNotify : true);
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
