import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/profile/web/helper/change_password_dialog.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_initial_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ProfileCenterInfoWidget extends ConsumerWidget with BaseConsumerWidget {
  const ProfileCenterInfoWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context ,ref) {
    final profileWatch = ref.watch(profileController);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
             children: [
               ///Initial
               CommonInitialText(
                 text:  '${profileWatch.profileDetailState.success?.data?.name}'.toUpperCase(),
               ).paddingOnly(right: context.width * 0.01),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   ///Name
                   CommonText(
                     title: '${profileWatch.profileDetailState.success?.data?.name?.capitalizeFirstLetterOfSentence}',
                     textStyle: TextStyles.medium.copyWith(
                       color: AppColors.black171717,
                       fontSize: 18.sp,
                     ),
                     maxLines: 3,
                   ).paddingOnly(bottom: context.height * 0.007),

                   /// Entity type
                   CommonText(
                     title: profileWatch.profileDetailState.success?.data?.entityType==UserType.VENDOR.name?LocaleKeys.keyVendor.localized:LocaleKeys.keyAgency.localized,
                     textStyle: TextStyles.regular.copyWith(
                       color: AppColors.grey7E7E7E,
                       fontSize: 16.sp,
                     ),
                   ).paddingOnly(bottom: context.height * 0.02),
                 ],
               ).paddingOnly(right: context.width * 0.03),
             ],
           ),

            Row(
              children: [
                ///Change Password
                CommonButton(
                  height: context.height * 0.060,
                  width: context.width * 0.120,
                  buttonText: LocaleKeys.keyChangePassword.localized,
                  buttonEnabledColor: AppColors.blue009AF1,
                  buttonTextStyle: TextStyles.regular.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.white
                  ),
                  onTap: (){
                    showCommonWebDialog(
                      keyBadge: profileWatch.sendOtpDialogKey,
                      context: context,
                      dialogBody: const ChangePasswordDialog(),
                        height: 0.65,
                        width: 0.5
                    );
                  },
                  isButtonEnabled: true,
                ).paddingOnly(right: context.width * 0.020),

                ///Edit Profile Button
                CommonButton(
                  height: context.height * 0.060,
                  // width: context.width * 0.100,
                  leftIcon:CommonSVG(
                    strIcon: Assets.svgs.svgEdit.keyName,
                    svgColor: AppColors.white,
                    height:context.width*0.017,
                    width: context.width*0.017,
                  ) ,
                  buttonText: LocaleKeys.keyEditProfile.localized,
                  buttonEnabledColor: AppColors.black171717,
                  buttonTextStyle: TextStyles.regular.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.white
                  ),
                  onTap: (){
                    Session.getUserType()==UserType.VENDOR.name?ref.read(navigationStackController).push(const NavigationStackItem.editVendor()):ref.read(navigationStackController).push(const NavigationStackItem.editAgency());
                  },
                  isButtonEnabled: true,
                )
              ],
            ),

          ],
        ),
        Divider(
          color: AppColors.clr707070.withOpacity(0.4),
        ).paddingSymmetric(vertical: context.height * 0.020),
      ],
    );
  }
}
