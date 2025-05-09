import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditStoreMobile extends ConsumerStatefulWidget {
  const AddEditStoreMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditStoreMobile> createState() => _AddEditStoreMobileState();
}

class _AddEditStoreMobileState extends ConsumerState<AddEditStoreMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditStoreWatch = ref.watch(addEditStoreController);
      //addEditStoreWatch.disposeController(isNotify : true);
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
