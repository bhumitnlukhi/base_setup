import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/agency_wallet_widget.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/vendor_wallet_widget.dart';

class WalletWeb extends ConsumerStatefulWidget {
  const WalletWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletWeb> createState() => _WalletWebState();
}

class _WalletWebState extends ConsumerState<WalletWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final walletWatch = ref.watch(walletController);
      walletWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Wallet
        CommonText(
          title: LocaleKeys.keyWallet.localized,
          textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 22.sp),
        ),

        SizedBox(
          height: context.height * 0.02,
        ),

        Expanded(child: Session.getUserType().toString()==UserType.VENDOR.name? const FadeBoxTransition(child: VendorWalletWidget()):const FadeBoxTransition(child: AgencyWalletWidget()))
      ],
    ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030);
  }
}
