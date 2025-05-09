import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/wallet/mobile/wallet_mobile.dart';
import 'package:odigo_vendor/ui/wallet/web/wallet_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const WalletMobile();
      },
      desktop: (BuildContext context) {
        return const WalletWeb();
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape ? const WalletWeb() : const WalletMobile();
      //     },
      //   );
      // },
    );
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        if (context.isWebScreen) {
          // EasyDebounce.debounce(showStoreDetailsDialogDebounce, const Duration(milliseconds: 100), () {

          //   if (widget.storeUuid != null) {
          //     storeWatch.showStoreDetailsDialog(context, ref, storeUuid: widget.storeUuid!);
          //   }
          // });
        } else {
          EasyDebounce.debounce('usersDebounce', const Duration(milliseconds: 50), () {
            final walletWatch = ref.read(walletController);
            if(walletWatch.addFundDialogKey.currentContext != null) {Navigator.pop(walletWatch.addFundDialogKey.currentContext!);}
            if(walletWatch.addFundAgencyDialogKey.currentContext != null) {Navigator.pop(walletWatch.addFundAgencyDialogKey.currentContext!);}

          });
        }
      }
    });
    super.didChangeDependencies();
  }


}
