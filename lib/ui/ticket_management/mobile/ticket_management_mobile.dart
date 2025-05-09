import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketManagementMobile extends ConsumerStatefulWidget {
  const TicketManagementMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<TicketManagementMobile> createState() =>
      _TicketManagementMobileState();
}

class _TicketManagementMobileState
    extends ConsumerState<TicketManagementMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final ticketManagementWatch = ref.watch(ticketManagementController);
      //ticketManagementWatch.disposeController(isNotify : true);
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
