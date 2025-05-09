import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/add_contact_us_widget.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/common_selection_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class SelectionWidget extends ConsumerWidget {
  const SelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final startJourneyWatch = ref.watch(startJourneyController);
    return Container(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  title: LocaleKeys.keyStartYourDigitalJourney.localized,
                  fontSize: 26.sp,
                  fontWeight: TextStyles.fwSemiBold,
                ),

                SizedBox(
                  height: context.height * 0.005,
                ),

                CommonText(
                  title: LocaleKeys.keyStartYourDigitalJourneyDescription.localized,
                  fontSize: 18.sp,
                  maxLines: 2,
                ),

                SizedBox(
                  height: context.height * 0.025,
                ),

                /// continue as guest
                CommonSelectionWidget(
                  icon: Assets.svgs.svgAgency.keyName,
                  title: LocaleKeys.keyContinueAsAgency.localized,
                  description: LocaleKeys.keyStartYourDigitalJourneyDescription.localized,
                  type: UserType.AGENCY,
                ),

                SizedBox(
                  height: context.height * 0.040,
                ),

                /// continue as vendor
                CommonSelectionWidget(
                  icon: Assets.svgs.svgVendor.keyName,
                  title: LocaleKeys.keyContinueAsVendor.localized,
                  description: LocaleKeys.keyStartYourDigitalJourneyDescription.localized,
                  type: UserType.VENDOR,
                ),
              ],
            ).paddingSymmetric(horizontal: context.width * 0.060),
          ),
          Container(
            padding: EdgeInsets.only(left: 30.w, top: 36.h, right: 30.w, bottom: 36.h),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.clr5A5A5A),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        title: LocaleKeys.keyStillHaveQuestions.localized,
                        textStyle: TextStyles.medium.copyWith(fontSize: 20.sp, color: AppColors.white),
                      ),
                      CommonText(
                        title: LocaleKeys.keyContactUsContent.localized,
                        textStyle: TextStyles.light.copyWith(fontSize: 16.sp, color: AppColors.clrD4D4D4),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30.w,
                ),
                CommonButton(
                  height: 50.h,
                  width: 170.w,
                  buttonText: LocaleKeys.keyContactUs.localized,
                  onTap: () async {
                    showWidgetDialog(context, const AddContactUsWidget(), () {});
                  },
                  backgroundColor: AppColors.white,
                  isButtonEnabled: true,
                  buttonEnabledColor: AppColors.white,
                  buttonTextColor: AppColors.black,
                  isLoading: false,
                  rightIcon: CommonSVG(
                    strIcon: Assets.svgs.svgRightArrow.path,
                    svgColor: AppColors.black,
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(horizontal: context.width * 0.030),
        ],
      ).paddingSymmetric(vertical: context.height * 0.050),
    );
  }
}
