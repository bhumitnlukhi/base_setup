import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ChangePasswordDialog extends ConsumerWidget with BaseConsumerWidget {
  const ChangePasswordDialog({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: context.height*0.020
        ),

        ///Changed Password Title and Cross ICon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.keyChangePassword.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 24.sp,
                color: AppColors.black171717,
              ),
            ),
            InkWell(
              onTap: () {
                profileWatch.clearFormData();
                profileWatch.disposeKeys();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgCrossRounded.keyName,
                height: context.height*0.060,
                width: context.width*0.060,
              ),
            ),
          ],
        ),

        SizedBox(
          height: context.height*0.030
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: profileWatch.changePasswordKey,
              child: Column(
                children: [

                  ///Current Password Field
                  CommonInputFormField(
                    obscureText: profileWatch.isShowCurrentPassword,
                    textEditingController: profileWatch.oldPasswordController,
                    hintText: LocaleKeys.keyOldPassword.localized,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      context.nextField;
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    onChanged: (value) {
                      profileWatch.checkIfPasswordValid();
                    },
                    suffixWidget: IconButton(
                      onPressed: () {
                        profileWatch.changeCurrentPasswordVisibility();
                      },
                      icon: CommonSVG(
                        height: context.height*0.024,
                        width: context.width*0.024,
                        boxFit: BoxFit.scaleDown,
                        strIcon: profileWatch.isShowCurrentPassword ? Assets.svgs.svgPasswordUnhide.keyName :Assets.svgs.svgPasswordHide.keyName,
                      ),
                    ).paddingOnly(right: 20.w),
                    validator: (value) {
                      return null;

                      ///Confirm whether entered Password is same as previous Password
                      //return profileWatch.verifyOldPassword();
                      // return validateOldPassword(value);
                    },
                  ).paddingSymmetric(vertical: context.height*0.015),
                  Visibility(
                      visible: profileWatch.oldPasswordController.text.isNotEmpty && !((profileWatch.oldPasswordController.text.length>=8 && profileWatch.oldPasswordController.text.length<=16 ) &&
                          RegExp(r'[a-z]').hasMatch(profileWatch.oldPasswordController.text) &&
                          RegExp(r'[A-Z]').hasMatch(profileWatch.oldPasswordController.text) &&
                          RegExp(r'[0-9]').hasMatch(profileWatch.oldPasswordController.text) &&
                          RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(profileWatch.oldPasswordController.text)),
                      child: passwordValidation(profileWatch.oldPasswordController)),

                  ///New Password Field
                  CommonInputFormField(
                    obscureText: profileWatch.isShowNewPassword,
                    textEditingController: profileWatch.newPasswordController,
                    hintText: LocaleKeys.keyNewPassword.localized,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      context.nextField;
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    onChanged: (value) {
                      profileWatch.checkIfPasswordValid();
                    },
                    suffixWidget: IconButton(
                      onPressed: () {
                        profileWatch.changeNewPasswordVisibility();
                      },
                      icon: CommonSVG(
                        height: context.height*0.024,
                        width: context.width*0.024,
                        boxFit: BoxFit.scaleDown,
                        strIcon: profileWatch.isShowNewPassword ? Assets.svgs.svgPasswordUnhide.keyName :Assets.svgs.svgPasswordHide.keyName,
                      ),
                    ).paddingOnly(right: 20.w),
                    validator: (value) {
                      return null;

                      // if (validatePassword(value) == null) {
                      //   return profileWatch
                      //       .checkIfNewPasswordIsNotSameAsOldPassword();
                      // }
                      // return validateNewPassword(value);
                    },
                  ).paddingSymmetric(vertical: context.height*0.015),
                  Visibility(
                      visible: profileWatch.newPasswordController.text.isNotEmpty && !((profileWatch.newPasswordController.text.length>=8 && profileWatch.newPasswordController.text.length<=16 ) &&
                          RegExp(r'[a-z]').hasMatch(profileWatch.newPasswordController.text) &&
                          RegExp(r'[A-Z]').hasMatch(profileWatch.newPasswordController.text) &&
                          RegExp(r'[0-9]').hasMatch(profileWatch.newPasswordController.text) &&
                          RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(profileWatch.newPasswordController.text))
                      ,
                      child: passwordValidation(profileWatch.newPasswordController)),

                  ///Re Enter Password Field
                  CommonInputFormField(
                    obscureText: profileWatch.isShowConfirmPassword,
                    textEditingController:
                        profileWatch.confirmNewPasswordController,
                    hintText: LocaleKeys.keyConfirmPassword.localized,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      hideKeyboard(context);
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    onChanged: (value) {
                      profileWatch.checkIfPasswordValid();
                    },
                    suffixWidget: IconButton(
                      onPressed: () {
                        profileWatch.changeConfirmPasswordVisibility();
                      },
                      icon: CommonSVG(
                        height: context.height*0.024,
                        width: context.width*0.024,
                        boxFit: BoxFit.scaleDown,
                        strIcon: profileWatch.isShowConfirmPassword ?  Assets.svgs.svgPasswordUnhide.keyName :Assets.svgs.svgPasswordHide.keyName,
                      ),
                    ).paddingOnly(right: 20.w),
                    validator: (value) {
                      return null;

                      // return profileWatch
                      //         .checkIfNewPasswordIsSameAsConfirmPassword()
                      //     ? validateText(value,LocaleKeys.keyConfirmPasswordIsRequired.localized)
                      //     : LocaleKeys
                      //         .keyNewPasswordAndConfirmPassword.localized;
                    },
                  ).paddingSymmetric(vertical: context.height*0.015),
                  Visibility(
                    visible: profileWatch.confirmNewPasswordController.text.isNotEmpty && !(profileWatch.newPasswordController.text==profileWatch.confirmNewPasswordController.text),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonSVG(strIcon: (profileWatch.confirmNewPasswordController.text==profileWatch.newPasswordController.text && profileWatch.confirmNewPasswordController.text.isNotEmpty)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
                        CommonText(title: LocaleKeys.keyConfirmPasswordMatch.localized,textStyle: TextStyles.regular.copyWith(
                            fontSize: 14.sp,
                            color: profileWatch.confirmNewPasswordController.text==profileWatch.newPasswordController.text?AppColors.black:AppColors.clr8D8D8D
                        ),),
                      ],
                    ).paddingOnly(bottom: 6.h,top: 6.h),
                  ),

                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: context.height*0.015
        ),

        ///Save Button
        CommonButton(
          onTap: () async {
            ///Change Password Api
            await changePasswordApi(context,ref);
          },
          onValidateTap: (){
            profileWatch.changePasswordKey.currentState?.validate();
          },
          width: context.width * 0.1,
          height: context.height*0.080,
          isLoading: profileWatch.changePasswordState.isLoading,
          buttonText: LocaleKeys.keySave.localized,
          buttonTextStyle: TextStyles.regular.copyWith(
            color: profileWatch.isPasswordFieldsValid
                ? AppColors.white
                : AppColors.black171717,
              fontSize: 18.sp
          ),
          buttonTextSize: 18.sp,
          isButtonEnabled: profileWatch.isPasswordFieldsValid,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.width*0.025,
      vertical: context.height*0.03,
    );
  }

  ///Change Password Api
  changePasswordApi(BuildContext context,WidgetRef ref) async{
    final profileWatch = ref.watch(profileController);
    ///Change Password Api
    await profileWatch.changePassword(context);
    if(profileWatch.changePasswordState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted){
      if(context.mounted){
        Navigator.pop(context);
        ///Success Dialog
        showCommonAnimationDialog(
          context: context,
          keySuccess: profileWatch.successDialogKey,
          animation: Assets.anim.animChangePasswordSuccess.keyName,
          title:
          LocaleKeys.keyChangePasswordSuccessfully.localized,
          titleWidget: SizedBox(
            width: context.width * 0.15,
            child: CommonText(
              title: LocaleKeys.keyChangePasswordSuccessfully.localized,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 24.sp,
                color: AppColors.black,
              ),
              maxLines: 6,
            ),
          ),
          description:'',
          descriptionWidget: const SizedBox(
          ),
          buttonText: LocaleKeys.keyClose.localized,
          buttonTextStyle: TextStyles.regular.copyWith(
            fontSize: 14.sp,
            color: AppColors.white,
          ),
        );
      }
    }
  }

  Widget passwordValidation(TextEditingController passwordController){
    return Column(

      children: [

        ///Length
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(strIcon: passwordController.text.length>=8 && passwordController.text.length<=16?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
            CommonText(title: LocaleKeys.keyMustHaveLength.localized,textStyle: TextStyles.regular.copyWith(
                fontSize: 14.sp,
                color: passwordController.text.length>=8 && passwordController.text.length<=16?AppColors.black:AppColors.clr8D8D8D
            ),),
          ],
        ).paddingOnly(bottom: 6.h,top: 6.h),

        ///Lower case
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(strIcon: RegExp(r'[a-z]').hasMatch(passwordController.text)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
            CommonText(
              title: LocaleKeys.keyContainLower.localized,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 14.sp,
                color: RegExp(r'[a-z]').hasMatch(passwordController.text)
                    ? AppColors.black:AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6.w),

        ///Upper Case
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(strIcon: RegExp(r'[A-Z]').hasMatch(passwordController.text)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
            CommonText(
              title: LocaleKeys.keyContainUpper.localized,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 14.sp,
                color: RegExp(r'[A-Z]').hasMatch(passwordController.text)
                    ?AppColors.black:AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6.w),

        ///Numeric
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(strIcon: RegExp(r'[0-9]').hasMatch(passwordController.text)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
            CommonText(
              title: LocaleKeys.keyContainNumeric.localized,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 14.sp,
                color: RegExp(r'[0-9]').hasMatch(passwordController.text)
                    ?AppColors.black:AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6.w),

        /// Must contain at least one special character (e.g. !@#...-)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonSVG(strIcon: RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(passwordController.text)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
            CommonText(
              title: LocaleKeys.keyContainSpecialCharacter.localized,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 14.sp,
                color: RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(passwordController.text)
                    ?AppColors.black:AppColors.clr8D8D8D,
              ),
            ),
          ],
        ).paddingOnly(bottom: 6.w),
      ],
    );
  }

}
