import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageDetailMobile extends ConsumerStatefulWidget {
  const PackageDetailMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<PackageDetailMobile> createState() =>
      _PackageDetailMobileState();
}

class _PackageDetailMobileState extends ConsumerState<PackageDetailMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final packageDetailWatch = ref.watch(packageDetailController);
      //packageDetailWatch.disposeController(isNotify : true);
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
