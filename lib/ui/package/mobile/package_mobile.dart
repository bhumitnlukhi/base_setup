import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageMobile extends ConsumerStatefulWidget {
  const PackageMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<PackageMobile> createState() => _PackageMobileState();
}

class _PackageMobileState extends ConsumerState<PackageMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final packageWatch = ref.watch(packageController);
      //packageWatch.disposeController(isNotify : true);
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
