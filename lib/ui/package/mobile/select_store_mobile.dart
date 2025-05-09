import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectStoreMobile extends ConsumerStatefulWidget {
  const SelectStoreMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectStoreMobile> createState() => _SelectStoreMobileState();
}

class _SelectStoreMobileState extends ConsumerState<SelectStoreMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final selectStoreWatch = ref.watch(selectStoreController);
      //selectStoreWatch.disposeController(isNotify : true);
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
