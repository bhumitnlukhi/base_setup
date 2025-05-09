import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class AdsMobile extends ConsumerStatefulWidget {
  const AdsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsMobile> createState() => _AdsMobileState();
}

class _AdsMobileState extends ConsumerState<AdsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final adsWatch = ref.watch(adsController);
      //adsWatch.disposeController(isNotify : true);
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
