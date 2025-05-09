import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditAdsMobile extends ConsumerStatefulWidget {
  const AddEditAdsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditAdsMobile> createState() => _AddEditAdsMobileState();
}

class _AddEditAdsMobileState extends ConsumerState<AddEditAdsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditAdsWatch = ref.watch(addEditAdsController);
      //addEditAdsWatch.disposeController(isNotify : true);
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
