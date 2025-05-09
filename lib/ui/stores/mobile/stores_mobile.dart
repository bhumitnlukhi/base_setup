import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoresMobile extends ConsumerStatefulWidget {
  const StoresMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<StoresMobile> createState() => _StoresMobileState();
}

class _StoresMobileState extends ConsumerState<StoresMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final storesWatch = ref.watch(storesController);
      //storesWatch.disposeController(isNotify : true);
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
