import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectDestinationMobile extends ConsumerStatefulWidget {
  const SelectDestinationMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectDestinationMobile> createState() =>
      _SelectDestinationMobileState();
}

class _SelectDestinationMobileState
    extends ConsumerState<SelectDestinationMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final selectDestinationWatch = ref.watch(selectDestinationController);
      //selectDestinationWatch.disposeController(isNotify : true);
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
