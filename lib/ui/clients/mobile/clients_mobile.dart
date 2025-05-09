import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientsMobile extends ConsumerStatefulWidget {
  const ClientsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ClientsMobile> createState() => _ClientsMobileState();
}

class _ClientsMobileState extends ConsumerState<ClientsMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final clientsWatch = ref.watch(clientsController);
      //clientsWatch.disposeController(isNotify : true);
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
