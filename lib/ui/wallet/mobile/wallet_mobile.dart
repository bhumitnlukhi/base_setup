import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletMobile extends ConsumerStatefulWidget {
  const WalletMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletMobile> createState() => _WalletMobileState();
}

class _WalletMobileState extends ConsumerState<WalletMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final walletWatch = ref.watch(walletController);
      //walletWatch.disposeController(isNotify : true);
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
