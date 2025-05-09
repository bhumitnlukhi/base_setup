import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartJourneyMobile extends ConsumerStatefulWidget {
  const StartJourneyMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<StartJourneyMobile> createState() => _StartJourneyMobileState();
}

class _StartJourneyMobileState extends ConsumerState<StartJourneyMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final startJourneyWatch = ref.watch(startJourneyController);
      //startJourneyWatch.disposeController(isNotify : true);
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
