import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllLocationsMobile extends ConsumerStatefulWidget {
  const AllLocationsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AllLocationsMobile> createState() => _AllLocationsMobileState();
}

class _AllLocationsMobileState extends ConsumerState<AllLocationsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final allLocationsWatch = ref.watch(allLocationsController);
      //allLocationsWatch.disposeController(isNotify : true);
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
