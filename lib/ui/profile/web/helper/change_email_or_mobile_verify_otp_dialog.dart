import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeEmailOrPhoneVerifyOtpDialog extends ConsumerWidget with BaseConsumerWidget {
  final bool? isEmail;
  final Function() onEditTap;

  ChangeEmailOrPhoneVerifyOtpDialog({
    super.key,
    required this.isEmail,
    required this.onEditTap,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: context.height * 0.020,
        ),

        ///OTP Verify Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.keyOtpVerify.localized,
              style: TextStyles.regular.copyWith(
                fontSize: 24.sp,
                color: AppColors.black171717,
              ),
            ),
            InkWell(
              onTap: () {
                profileWatch.counter?.cancel();
                profileWatch.changeEmailOrMobileOtpController.clear();
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgCrossRounded.keyName,
                height: context.height * 0.060,
                width: context.width * 0.060,
              ),
            ),
          ],
        ),

        SizedBox(
          height: context.height * 0.020,
        ),

        ///We have sent a code to your Email Id or Mobile Number
        RichText(
          text: TextSpan(
            text: '${LocaleKeys.keyWeHaveSentYouAnOtp.localized} ${isEmail == true ? LocaleKeys.keyEmailId.localized : LocaleKeys.keyMobileNumber.localized} ',
            style: TextStyles.regular.copyWith(
              fontSize: 18.sp,
              color: AppColors.black171717,
            ),
            children: [
              TextSpan(
                text: isEmail == true ? profileWatch.newEmailController.text : profileWatch.newMobileController.text,
                style: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.black171717,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.black171717,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: context.height * 0.030,
        ),

        /// OTP Text Field
        Form(
          key: profileWatch.emailVerifyOtpKey,
          child: PinCodeTextField(
            appContext: context,
            autoDisposeControllers: false,
            cursorColor: AppColors.black171717,
            length: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              return validateOtp(value);
            },
            controller: profileWatch.changeEmailOrMobileOtpController,
            keyboardType: TextInputType.number,
            onChanged: (code) {
              profileWatch.checkIfOtpValid();
            },
            textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 20.sp),
            onCompleted: (String? code) {},
            pinTheme: PinTheme(
              borderRadius: BorderRadius.circular(10.r),
              shape: PinCodeFieldShape.box,
              fieldWidth: context.width * 0.04,
              fieldHeight: context.height * 0.1,
              activeColor: AppColors.textFieldBorderColor,
              inactiveColor: AppColors.textFieldBorderColor,
              selectedColor: AppColors.textFieldBorderColor,
              fieldOuterPadding: EdgeInsets.zero,
              activeBorderWidth: 1.w,
              selectedBorderWidth: 1.w,
              inactiveBorderWidth: 1.w,
            ),
          ),
        ),

        SizedBox(
          height: context.height * 0.020,
        ),

        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Resend OTP Button
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    if (profileWatch.counterSeconds == 0) {
                      profileWatch.startCounter();
                      profileWatch.changeEmailOrMobileOtpController.clear();
                      Future.delayed(const Duration(milliseconds: 100), () {
                        profileWatch.emailVerifyOtpKey.currentState?.reset();
                      });
                      ///Send OTP Api
                      if (isEmail == true) {
                        await profileWatch.sendOtpApi(context, email: profileWatch.newEmailController.text);
                      } else {
                        await profileWatch.sendOtpApi(context, mobileNo: profileWatch.newMobileController.text);
                      }
                    }
                  },
                  child: CommonText(
                    title: '${(profileWatch.counterSeconds == 0) ? LocaleKeys.keyResendCode.localized : LocaleKeys.keyResendCodeIn.localized} ${(profileWatch.counterSeconds == 0) ? '' : profileWatch.getCounterSeconds()}',
                    textStyle: TextStyles.medium.copyWith(color: (profileWatch.counterSeconds == 0) ? AppColors.blue009AF1 : AppColors.grey8D8C8C, decorationColor: (profileWatch.counterSeconds == 0) ? AppColors.blue009AF1 : AppColors.grey8D8C8C, decoration: TextDecoration.underline, fontSize: 18.sp),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),

              ///Edit Email Button or Mobile Number
              Expanded(
                flex: 2,
                child: RichText(
                  text: TextSpan(
                    text: isEmail == true ? LocaleKeys.keyNotYourEmailId.localized : LocaleKeys.keyNotYourMobileNo.localized,
                    style: TextStyles.medium.copyWith(color: AppColors.black171717, fontSize: 18.sp),
                    children: [
                      TextSpan(
                        text: ' ${LocaleKeys.keyEdit.localized}',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onEditTap();
                          },
                        style: TextStyles.medium.copyWith(color: AppColors.blue009AF1, decorationColor: AppColors.blue009AF1, decoration: TextDecoration.underline, fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        ///Submit OTP Button
        CommonButton(
          onTap: () async {
            if (isEmail == true) {
              ///Update Email Api
              await updateEmailApi(context, ref);
            } else {
              ///Update Mobile Api
              await updateMobileApi(context, ref);
            }
          },
          onValidateTap: () {
            profileWatch.emailVerifyOtpKey.currentState?.validate();
          },
          width: context.width * 0.1,
          height: context.height * 0.080,
          buttonTextStyle: TextStyles.regular.copyWith(
            fontSize: 18.sp,
            color: profileWatch.isEmailVerifyOtpValid ? AppColors.white : AppColors.black,
          ),
          isLoading: profileWatch.updateEmailOrMobileState.isLoading,
          buttonText: LocaleKeys.keySubmit.localized,
          isButtonEnabled: profileWatch.isEmailVerifyOtpValid,
        )
      ],
    );
  }

  ///Update Email Api
  updateEmailApi(BuildContext context, WidgetRef ref) async {
    final profileWatch = ref.watch(profileController);

    ///Update Email Api
    await profileWatch.updateEmailMobileApi(context: context, isEmail: true, email: profileWatch.newEmailController.text, otp: profileWatch.changeEmailOrMobileOtpController.text, password: profileWatch.emailPasswordController.text);
    if (profileWatch.updateEmailOrMobileState.success?.status == ApiEndPoints.apiStatus_200 && context.mounted) {
      if (context.mounted) {
        Navigator.of(context).pop();

        showCommonAnimationDialog(
          context: context,
          keySuccess: profileWatch.successDialogKey,
          animation: Assets.anim.animChangeEmailSuccess.keyName,
          animationWidget: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Lottie.asset(
                  Assets.anim.animChangeEmailSuccess.keyName,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ).paddingOnly(right: 10.w),
          title: LocaleKeys.keyChangeEmailSuccessfully.localized,
          titleWidget: SizedBox(
            width: context.width * 0.17,
            child: CommonText(
              title:
              LocaleKeys.keyChangeEmailSuccessfully.localized,
              maxLines: 3,
              textStyle: TextStyles.semiBold.copyWith(
                fontSize: 34.sp,
                color: AppColors.black,
              ),
            ),
          ),
          descriptionWidget: SizedBox(
            child: CommonText(
              title: '',
              textStyle: TextStyles.light.copyWith(
                fontSize: 24.sp,
                color: AppColors.grey8D8C8C,
              ),
              maxLines: 2,
            ),
          ),
          description:'',
          buttonText: LocaleKeys.keyClose.localized,
          buttonTextStyle: TextStyles.regular.copyWith(
            fontSize: 23.sp,
            color: AppColors.white,
          ),
          item: const NavigationStackItem.profile(),
        );
      }
    }
  }

  ///Update Mobile Api
  updateMobileApi(BuildContext context, WidgetRef ref) async {
    final profileWatch = ref.watch(profileController);

    ///Update Mobile Api
    await profileWatch.updateEmailMobileApi(context: context, isEmail: false, mobileNo: profileWatch.newMobileController.text, otp: profileWatch.changeEmailOrMobileOtpController.text, password: profileWatch.mobilePasswordController.text);
    if (profileWatch.updateEmailOrMobileState.success?.status == ApiEndPoints.apiStatus_200 && context.mounted) {
      if (context.mounted) {
        Navigator.pop(profileWatch.changeEmailDialogKey.currentContext!);
        Navigator.pop(profileWatch.sendOtpDialogKey.currentContext!);
        showCommonAnimationDialog(
          context: context,
          keySuccess: profileWatch.successDialogKey,
          animation: Assets.anim.animChangeEmailSuccess.keyName,
          animationWidget: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                flex: 4,
                child: Lottie.asset(
                  Assets.anim.animChangeEmailSuccess.keyName,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ).paddingOnly(right: 10.w),
          title: LocaleKeys.keyChangeMobileSuccessfully.localized,
          titleWidget: SizedBox(
            width: context.width * 0.17,
            child: CommonText(
              title: LocaleKeys.keyChangeMobileSuccessfully.localized,
              maxLines: 5,
              textStyle: TextStyles.semiBold.copyWith(
                fontSize: 34.sp,
                color: AppColors.black,
              ),
            ),
          ),
          descriptionWidget: SizedBox(
            child: CommonText(
              title: '',
              textStyle: TextStyles.light.copyWith(
                fontSize: 24.sp,
                color: AppColors.grey8D8C8C,
              ),
              maxLines: 2,
            ),
          ),
          description: '',
          buttonText: LocaleKeys.keyClose.localized,
          buttonTextStyle: TextStyles.regular.copyWith(
            fontSize: 23.sp,
            color: AppColors.white,
          ),
          item: const NavigationStackItem.profile(),
        );
      }
    }
  }
}
