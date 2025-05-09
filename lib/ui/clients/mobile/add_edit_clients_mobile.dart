import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditClientsMobile extends ConsumerStatefulWidget {
  const AddEditClientsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AddEditClientsMobile> createState() =>
      _AddEditClientsMobileState();
}

class _AddEditClientsMobileState extends ConsumerState<AddEditClientsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final addEditClientsWatch = ref.watch(addEditClientsController);
      //addEditClientsWatch.disposeController(isNotify : true);
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
