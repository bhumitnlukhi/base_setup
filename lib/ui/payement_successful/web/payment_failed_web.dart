import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/response/payment_fail_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class PaymentFailedWeb extends ConsumerStatefulWidget {
  final FailPaymentResponseModel? failPaymentResponseModel;
  const PaymentFailedWeb({Key? key,this.failPaymentResponseModel}) : super(key: key);

  @override
  ConsumerState<PaymentFailedWeb> createState() => _PaymentFailedWebState();
}

class _PaymentFailedWebState extends ConsumerState<PaymentFailedWeb> with BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3),(){
        ref.read(navigationStackController).pop();
      });
      //paymentCancelWatch.disposeController(isNotify : true);
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
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r), color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            Assets.anim.animPaymentFailed.keyName,
            height: context.height * 0.4,
            width: context.width * 0.4,
          ),
          SizedBox(
            height: context.height * 0.05,
          ),
          CommonText(
            title: LocaleKeys.keyPaymentFailed.localized,
            textStyle: TextStyles.medium.copyWith(fontSize: 24.sp),
          ),
          SizedBox(
            height: context.height * 0.05,
          ),
          CommonText(
            title: LocaleKeys.keyWeAreSorry.localized,
            maxLines: 4,
            textStyle: TextStyles.regular.copyWith(fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),
          CommonText(
            title: widget.failPaymentResponseModel?.message??'',
            maxLines: 4,
            textStyle: TextStyles.regular.copyWith(fontSize: 20.sp),
            textAlign: TextAlign.center,
          ),

        ],
      ).paddingSymmetric(horizontal: context.width*0.05,vertical: context.height*0.05),
    );
  }


}
