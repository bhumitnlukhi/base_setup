import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class WaitingDialog extends StatelessWidget {
  const WaitingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
     mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: context.height * 0.02,
        ),

        Lottie.asset(
          Assets.anim.animWaitingStatus.keyName,
          height: context.height * 0.250,
          width: context.height * 0.250,
        ),
        SizedBox(
          height: context.height * 0.02,
        ),

        ///Please Wait Till Approval
        CommonText(
          title: LocaleKeys.keyPleaseWaitTillAdminApproval.localized,
          textAlign: TextAlign.center,
          textStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 18.sp),
          maxLines: 4,
        ),

        SizedBox(
          height: context.height * 0.02,
        ),

        ///Under Review
        CommonText(
          title: LocaleKeys.keyApplicationUnderReview.localized,
          textAlign: TextAlign.center,
          textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 14.sp),
          maxLines: 4,
        ),

        SizedBox(
          height: context.height * 0.02,
        ),

      ],
    );
  }
}
