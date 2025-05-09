import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdsDetailsMobile extends ConsumerStatefulWidget {
  const AdsDetailsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsDetailsMobile> createState() => _AdsDetailsMobileState();
}

class _AdsDetailsMobileState extends ConsumerState<AdsDetailsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final adsDetailsWatch = ref.watch(adsDetailsController);
      //adsDetailsWatch.disposeController(isNotify : true);
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
