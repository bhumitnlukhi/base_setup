import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientAdListMobile extends ConsumerStatefulWidget {
  const ClientAdListMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ClientAdListMobile> createState() => _ClientListMobileState();
}

class _ClientListMobileState extends ConsumerState<ClientAdListMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final clientListWatch = ref.watch(clientListController);
      //clientListWatch.disposeController(isNotify : true);
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
