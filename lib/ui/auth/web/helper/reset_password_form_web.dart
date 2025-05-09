import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/reset_password_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ResetPasswordFormWeb extends ConsumerWidget with BaseConsumerWidget {
  const ResetPasswordFormWeb({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final resetPasswordWatch = ref.watch(resetPasswordController);
    return FadeBoxTransition(
      child: SingleChildScrollView(
        child: Form(
          key: resetPasswordWatch.formKey,
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back Button
                InkWell(
                  child: CommonSVG(strIcon: Assets.svgs.svgBackRounded.keyName, height: context.height * 0.077, width: context.width * 0.077),
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                ),
                SizedBox(
                  height: 23.h,
                ),

                /// Title
                CommonText(
                  title: LocaleKeys.keyResetPassword.localized,
                  textStyle: TextStyles.semiBold.copyWith(
                    fontSize: 24.sp,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(
                  height: 25.h,
                ),

                /// Description
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: CommonText(
                        title: LocaleKeys.keyEnterPasswordAndConfirm.localized,
                        textStyle: TextStyles.regular.copyWith(
                          fontSize: 22.sp,
                          color: AppColors.black272727,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),

                /// Enter New Password Field
                CommonInputFormField(
                  obscureText: resetPasswordWatch.isShowPassword,
                  textEditingController: resetPasswordWatch.newPasswordController,
                  hintText: LocaleKeys.keyNewPassword.localized,
                  maxLength: 16,
                  textInputAction: TextInputAction.next,
                  validator: (password) {
                    return null;

                    // return validateNewPassword(password);
                  },
                  onChanged: (password) {
                    resetPasswordWatch.checkIfAllFieldsValid();
                  },
                  onFieldSubmitted: (value) {
                    context.nextField;
                  },
                  suffixWidget: IconButton(
                    onPressed: () {
                      resetPasswordWatch.changePasswordVisibility();
                    },
                    icon: CommonSVG(
                      strIcon: resetPasswordWatch.isShowPassword ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName,
                      height: context.height * 0.024,
                      width: context.width * 0.024,
                      boxFit: BoxFit.scaleDown,
                    ),
                  ).paddingOnly(right: 20.w),
                ),
                Visibility(
                    visible: resetPasswordWatch.newPasswordController.text.isNotEmpty && !((resetPasswordWatch.newPasswordController.text.length>=8 && resetPasswordWatch.newPasswordController.text.length<=16 ) &&
                        RegExp(r'[a-z]').hasMatch(resetPasswordWatch.newPasswordController.text) &&
                        RegExp(r'[A-Z]').hasMatch(resetPasswordWatch.newPasswordController.text) &&
                        RegExp(r'[0-9]').hasMatch(resetPasswordWatch.newPasswordController.text) &&
                        RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(resetPasswordWatch.newPasswordController.text)),
                    child: passwordValidation(resetPasswordWatch.newPasswordController)),


                SizedBox(
                  height: 25.h,
                ),

                /// Confirm New Password Field
                CommonInputFormField(
                  obscureText: resetPasswordWatch.isShowConfirmPassword,
                  textEditingController: resetPasswordWatch.confirmPasswordController,
                  maxLength: 16,
                  hintText: LocaleKeys.keyConfirmPassword.localized,
                  textInputAction: TextInputAction.done,
                  onChanged: (email) {
                    resetPasswordWatch.checkIfAllFieldsValid();
                  },
                  validator: (password) {
                    return null;

                    // if (password != null && password.length > 7 && password != resetPasswordWatch.newPasswordController.text) {
                    //   return LocaleKeys.keyConfirmPasswordMustAsPassword.localized;
                    // } else {
                    //   return validateConfirmPassword(password, resetPasswordWatch.newPasswordController.text);
                    // }
                  },
                  onFieldSubmitted: (value) async {
                    ///Reset OTP Api
                    await _resetPasswordApi(ref, context);
                  },
                  suffixWidget: IconButton(
                    onPressed: () {
                      resetPasswordWatch.changeConfirmPasswordVisibility();
                    },
                    icon: CommonSVG(
                      strIcon: resetPasswordWatch.isShowConfirmPassword ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName,
                      boxFit: BoxFit.scaleDown,
                      height: context.height * 0.024,
                      width: context.width * 0.024,
                    ),
                  ).paddingOnly(right: 20.w),
                ),

                Visibility(
                  visible: resetPasswordWatch.confirmPasswordController.text.isNotEmpty && !(resetPasswordWatch.newPasswordController.text==resetPasswordWatch.confirmPasswordController.text),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CommonSVG(strIcon: (resetPasswordWatch.confirmPasswordController.text==resetPasswordWatch.newPasswordController.text && resetPasswordWatch.confirmPasswordController.text.isNotEmpty)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
                      CommonText(title: LocaleKeys.keyConfirmPasswordMatch.localized,textStyle: TextStyles.regular.copyWith(
                          fontSize: 14.sp,
                          color: resetPasswordWatch.confirmPasswordController.text==resetPasswordWatch.newPasswordController.text?AppColors.black:AppColors.clr8D8D8D
                      ),),
                    ],
                  ).paddingOnly(bottom: 6.h,top: 6.h),
                ),

                SizedBox(
                  height: 60.h,
                ),

                /// Reset Password Button
                CommonButton(
                  onTap: () async {
                    ///Reset OTP Api
                    await _resetPasswordApi(ref, context);
                  },
                  onValidateTap: () {
                    resetPasswordWatch.formKey.currentState?.validate();
                  },
                  isLoading: resetPasswordWatch.resetPasswordState.isLoading,
                  height: 73.h,
                  buttonTextStyle: TextStyles.regular.copyWith(
                    fontSize: 18.sp,
                    color: resetPasswordWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                  ),
                  buttonEnabledColor: AppColors.black,
                  buttonDisabledColor: AppColors.buttonDisabledColor,
                  buttonText: LocaleKeys.keySubmit.localized,
                  rightIcon: Icon(
                    Icons.arrow_forward,
                    size: 30.h,
                    color: resetPasswordWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                  ),
                  isButtonEnabled: resetPasswordWatch.isAllFieldsValid,
                ),
              ],
            ).paddingSymmetric(horizontal: context.width * 0.060, vertical: context.height * 0.050),
          ),
        ),
      ),
    );
  }

  ///Reset OTP Api
  _resetPasswordApi(WidgetRef ref, BuildContext context) async {
    final resetPasswordWatch = ref.watch(resetPasswordController);
    final forgotPasswordWatch = ref.watch(forgotPasswordController);
    final otpWatch = ref.watch(otpVerificationController);
    forgotPasswordWatch.emailController.text = getCookie(keyResetPasswordEmail) ?? '';
    otpWatch.otpController.text = getCookie(keyResetPasswordOtp) ?? '';
    await resetPasswordWatch.resetPasswordApi(context, email: forgotPasswordWatch.emailController.text, otp: otpWatch.otpController.text);
    if (resetPasswordWatch.resetPasswordState.success?.status == ApiEndPoints.apiStatus_200) {
      clearWebCookies();
      await Session.saveLocalData(keyIsVerifiedForResetPassword, false);
      ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.login());
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
