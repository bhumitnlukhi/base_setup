import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentSuccessfulMobile extends ConsumerStatefulWidget {
  const PaymentSuccessfulMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<PaymentSuccessfulMobile> createState() => _PaymentSuccessfulMobileState();
}

class _PaymentSuccessfulMobileState extends ConsumerState<PaymentSuccessfulMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final paymentSuccessfulWatch = ref.watch(paymentSuccessfulController);
      //paymentSuccessfulWatch.disposeController(isNotify : true);
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
