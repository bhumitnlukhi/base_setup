import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectClientMobile extends ConsumerStatefulWidget {
  const SelectClientMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectClientMobile> createState() => _SelectClientMobileState();
}

class _SelectClientMobileState extends ConsumerState<SelectClientMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final selectClientWatch = ref.watch(selectClientController);
      //selectClientWatch.disposeController(isNotify : true);
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
