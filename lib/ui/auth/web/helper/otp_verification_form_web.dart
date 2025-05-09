import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/signup_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationFormWeb extends ConsumerWidget with BaseConsumerWidget {
  final String? email;
  final ScreenName? screenName;

  OtpVerificationFormWeb({super.key, this.email, this.screenName});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final otpVerificationWatch = ref.watch(otpVerificationController);
    final signUpWatch = ref.watch(signUpController);
    final loginWatch = ref.watch(loginController);
    return SingleChildScrollView(
      child: Theme(
        data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Back Button
            InkWell(
              child: CommonSVG(strIcon: Assets.svgs.svgBackRounded.keyName, height: context.height * 0.077, width: context.width * 0.077),
              onTap: () {
                final otpVerificationWatch = ref.watch(otpVerificationController);
                otpVerificationWatch.counter?.cancel();
                ref.read(navigationStackController).pop();
              },
            ),
            SizedBox(
              height: 30.h,
            ),

            /// Title
            CommonText(
              title: LocaleKeys.keyOtpVerification.localized,
              textStyle: TextStyles.semiBold.copyWith(
                fontSize: 24.sp,
                color: AppColors.black272727,
              ),
            ),
            SizedBox(
              height: 25.h,
            ),

            /// Description
            CommonText(
              title: LocaleKeys.keyVerifyOtpDescription.localized,
              maxLines: 3,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 22.sp,
                color: AppColors.black272727,
              ),
            ),
            CommonText(
              title: email ?? '',
              textStyle: TextStyles.regular.copyWith(
                fontSize: 22.sp,
                color: AppColors.black272727,
              ),
            ),
            SizedBox(height: 50.h),
            FadeBoxTransition(
              child: Form(
                key: otpVerificationWatch.formKey,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,

                      /// OTP Form Fields
                      child: PinCodeTextField(
                        appContext: context,
                        autoDisposeControllers: false,
                        cursorColor: AppColors.black,
                        length: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                        validator: (value) {
                          return validateOtp(value);
                        },
                        textInputAction: TextInputAction.done,
                        controller: otpVerificationWatch.otpController,
                        keyboardType: TextInputType.number,
                        onChanged: (code) {
                          otpVerificationWatch.checkIfAllFieldsValid();
                        },
                        textStyle: TextStyles.regular.copyWith(
                          color: AppColors.black272727,
                          fontSize: 20.sp,
                        ),
                        onSubmitted: (value) async {
                          if (otpVerificationWatch.isAllFieldsValid) {
                            ///OTP Verified Api
                            await _otpVerifiedPasswordApi(ref, context);
                          }
                        },
                        onCompleted: (String? code) {
                          otpVerificationWatch.checkIfAllFieldsValid();
                        },
                        pinTheme: PinTheme(
                          borderRadius: BorderRadius.circular(10.r),
                          shape: PinCodeFieldShape.box,
                          activeColor: AppColors.textFieldBorderColor,
                          inactiveColor: AppColors.textFieldBorderColor,
                          selectedColor: AppColors.textFieldBorderColor,
                          activeFillColor: AppColors.textFieldBorderColor,
                          inactiveFillColor: AppColors.textFieldBorderColor,
                          fieldHeight: context.width * 0.035,
                          fieldWidth: context.width * 0.035,
                          activeBorderWidth: 1.w,
                          selectedBorderWidth: 1.w,
                          inactiveBorderWidth: 1.w,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),

            ///Edit Email Id Button
            RichText(
              text: TextSpan(
                text: LocaleKeys.keyNotYourEmail.localized,
                style: TextStyles.regular.copyWith(
                  fontSize: 20.sp,
                  color: AppColors.black,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.black,
                ),
                children: [
                  TextSpan(
                    text: LocaleKeys.keyEdit.localized,
                    style: TextStyles.regular.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.primary2,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary2,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        ref.read(navigationStackController).pop();
                      },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70.h,
            ),

            ///Resend OTP  Button
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: CommonButton(
                    onTap: () async {
                      if (otpVerificationWatch.counterSeconds == 0) {
                        if (!(loginWatch.isLogin)) {
                          ///Resend OTP Api
                          await otpVerificationWatch.sendOtpApi(
                            context,
                            email: signUpWatch.emailController.text.toLowerCase(),
                            mobileNo: signUpWatch.mobileNumberController.text,
                            userUuid: signUpWatch.signUpState.success?.data?.userUuid,
                          );
                          if (otpVerificationWatch.sendOtpState.success?.status == ApiEndPoints.apiStatus_200) {
                            otpVerificationWatch.counter?.cancel();
                            otpVerificationWatch.startCounter();
                            otpVerificationWatch.otpController.clear();
                            Future.delayed(const Duration(milliseconds: 10),(){
                              otpVerificationWatch.formKey.currentState?.reset();
                            });
                          }
                        } else {
                          ///Resend OTP Api
                          await otpVerificationWatch.resendOtpApi(context, email: email);
                          if (otpVerificationWatch.resendOtpState.success?.status == ApiEndPoints.apiStatus_200) {
                            if (otpVerificationWatch.counterSeconds == 0) {
                              otpVerificationWatch.counter?.cancel();
                              otpVerificationWatch.startCounter();
                              otpVerificationWatch.otpController.clear();
                              Future.delayed(const Duration(milliseconds: 10),(){
                                otpVerificationWatch.formKey.currentState?.reset();
                              });
                            }
                          }
                        }
                      }
                    },
                    isLoading: otpVerificationWatch.resendOtpState.isLoading || otpVerificationWatch.sendOtpState.isLoading,
                    height: 73.h,
                    buttonText: (otpVerificationWatch.counterSeconds == 0) ? LocaleKeys.keyResendCode.localized : '${LocaleKeys.keyResendCodeIn.localized} ${otpVerificationWatch.getCounterSeconds()}',
                    borderWidth: 1.w,
                    borderColor: otpVerificationWatch.counterSeconds == 0 ? AppColors.primary2 : AppColors.grey8F8F8F,
                    buttonTextStyle: TextStyles.regular.copyWith(
                      fontSize: 20.sp,
                      color: otpVerificationWatch.counterSeconds == 0 ? AppColors.primary2 : AppColors.clr707070,
                    ),
                    onValidateTap: () {
                      otpVerificationWatch.formKey.currentState?.validate();
                    },
                    buttonEnabledColor: AppColors.white,
                    buttonDisabledColor: AppColors.white,
                    isButtonEnabled: otpVerificationWatch.counterSeconds == 0,
                    loadingAnimationColor: AppColors.primary2,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
            SizedBox(height: 25.h),

            /// Verify OTP Button
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: CommonButton(
                    onTap: () async {
                      ///OTP Verified Api
                      await _otpVerifiedPasswordApi(ref, context);
                    },
                    isLoading: otpVerificationWatch.verifyOtpForSignUpState.isLoading || otpVerificationWatch.verifyOtpState.isLoading,
                    height: 73.h,
                    buttonText: LocaleKeys.keyVerify.localized,
                    buttonTextStyle: TextStyles.regular.copyWith(
                      fontSize: 20.sp,
                      color: otpVerificationWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                    ),
                    buttonEnabledColor: AppColors.black,
                    rightIcon: Icon(Icons.arrow_forward, color: otpVerificationWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E, size: 30.h),
                    isButtonEnabled: otpVerificationWatch.isAllFieldsValid,
                    onValidateTap: () {
                      otpVerificationWatch.formKey.currentState?.validate();
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: context.width * 0.060, vertical: context.height * 0.050),
      ),
    );
  }

  ///OTP Verified Api
  _otpVerifiedPasswordApi(WidgetRef ref, BuildContext context) async {
    final otpVerificationWatch = ref.watch(otpVerificationController);
    final loginWatch = ref.read(loginController);
    final signUpWatch = ref.read(signUpController);

    ///Come From Signup
    if (screenName == ScreenName.login) {
      await otpVerificationWatch.verifyOtpForSignUpApi(
        context,
        loginWatch.passwordController.text,
        isSignUp: false,
        uuid: loginWatch.loginState.success?.data?.userUuid,
      );
      if (otpVerificationWatch.verifyOtpForSignUpState.success?.status == ApiEndPoints.apiStatus_200) {
        /// Saving auth token
        Session.saveLocalData(keyUserAuthToken, otpVerificationWatch.verifyOtpForSignUpState.success?.data?.accessToken);
        Session.saveLocalData(keyUserUuid, otpVerificationWatch.verifyOtpForSignUpState.success?.data?.userUuid);
        Session.saveLocalData(keyUuid, otpVerificationWatch.verifyOtpForSignUpState.success?.data?.uuid);
        if (otpVerificationWatch.verifyOtpForSignUpState.success?.data?.entityType?.toUpperCase() == UserType.VENDOR.name) {
          ///Vendor Navigation
          ref.read(navigationStackController).pushRemoveUntil(const NavigationStackItem.vendorRegistrationForm(), const NavigationStackItem.login());
        } else {
          ///Agency Navigation
          ref.read(navigationStackController).pushRemoveUntil(const NavigationStackItem.agencyRegistrationForm(), const NavigationStackItem.login());
        }
      }
    } else if (!(loginWatch.isLogin)) {
      ///Verify signUP otp
      await otpVerificationWatch.verifyOtpForSignUpApi(
        context,
        isSignUp: true,
        signUpWatch.passwordController.text,
        uuid: signUpWatch.signUpState.success?.data?.userUuid,
      );
      if (otpVerificationWatch.verifyOtpForSignUpState.success?.status == ApiEndPoints.apiStatus_200) {
        /// Saving auth token
        Session.saveLocalData(keyUserAuthToken, otpVerificationWatch.verifyOtpForSignUpState.success?.data?.accessToken);
        Session.saveLocalData(keyUserUuid, otpVerificationWatch.verifyOtpForSignUpState.success?.data?.userUuid);
        Session.saveLocalData(keyUuid, otpVerificationWatch.verifyOtpForSignUpState.success?.data?.uuid);
        if (otpVerificationWatch.verifyOtpForSignUpState.success?.data?.entityType?.toUpperCase() == UserType.VENDOR.name) {
          ///Vendor Navigation
          ref.read(navigationStackController).pushRemoveUntil(const NavigationStackItem.vendorRegistrationForm(), const NavigationStackItem.login());
        } else {
          ///Agency Navigation
          ref.read(navigationStackController).pushRemoveUntil(const NavigationStackItem.agencyRegistrationForm(), const NavigationStackItem.login());
        }
      }
    } else {
      await otpVerificationWatch.verifyOtpApi(context, email ?? ref.read(forgotPasswordController).emailController.text);
      if (otpVerificationWatch.verifyOtpState.success?.status == ApiEndPoints.apiStatus_200) {
        setCookie(keyResetPasswordOtp, otpVerificationWatch.otpController.text);
        await Session.saveLocalData(keyIsVerifiedForResetPassword, true);
        ref.read(navigationStackController).pushRemoveUntil(const NavigationStackItem.resetPassword(), const NavigationStackItem.login());
      } else {
        otpVerificationWatch.otpController.text = '';
      }
    }
  }
}
