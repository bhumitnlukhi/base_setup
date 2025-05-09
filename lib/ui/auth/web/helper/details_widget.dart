import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/signup_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/auth/web/helper/login_form_web.dart';
import 'package:odigo_vendor/ui/auth/web/helper/signup_form.dart';
import 'package:odigo_vendor/ui/auth/web/helper/tab_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/language_selection_dropdown.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final loginWatch = ref.watch(loginController);
        final signUpWatch = ref.watch(signUpController);
        final otpVerificationWatch = ref.watch(otpVerificationController);
        return Stack(
          children: [
            Container(
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            if (ref.read(navigationStackController).items.length > 1) {
                              ref.read(navigationStackController).pop();
                            }
                          },
                          child: Visibility(
                            visible: ref.read(navigationStackController).items.length > 1,
                            child: CommonSVG(
                              strIcon: Assets.svgs.svgBackRounded.keyName,
                              height: context.height * 0.077,
                              width: context.width * 0.077,
                              isRotate: true,
                            ),
                          )),
                      const Spacer(),
                      const Spacer(),
                      const Expanded(flex: 2, child: FadeBoxTransition(child: LanguageSelectionDropdown())),
                    ],
                  ),

                  SizedBox(height: context.height * 0.04),

                  CommonText(
                    title: loginWatch.isLogin ? LocaleKeys.keyLoginIntoYourAccount.localized : LocaleKeys.keySignupIntoYourAccount.localized,
                    fontSize: 26.sp,
                    fontWeight: TextStyles.fwSemiBold,
                  ),

                  SizedBox(height: context.height * 0.01),

                  CommonText(title: loginWatch.isLogin ? LocaleKeys.keyWelcomeBackSelectMethodToLogIn.localized : LocaleKeys.keyWelcomeBackSelectMethodToSignUp.localized, fontSize: 21.sp),

                  SizedBox(
                    height: context.height * 0.033,
                  ),

                  const FadeBoxTransition(child: TabWidget()),

                  SizedBox(
                    height: context.height * 0.05,
                  ),

                  /// put condition here for login or signup form
                  Expanded(child: loginWatch.isLogin ? const LoginFormWeb() : const SignupForm()),

                  SizedBox(
                    height: context.height * 0.04,
                  ),

                  /// Login and SignUp Button
                  CommonButton(
                    height: 73.h,
                    buttonText: loginWatch.isLogin ? LocaleKeys.keyLogin.localized : LocaleKeys.keySubmit.localized,
                    buttonEnabledColor: AppColors.black,
                    buttonDisabledColor: AppColors.clrF7F7FC,
                    isButtonEnabled: loginWatch.isAllFieldsValid || signUpWatch.isAllFieldsValid,
                    buttonTextStyle: TextStyles.regular.copyWith(
                      fontSize: 18.sp,
                      color: loginWatch.isAllFieldsValid || signUpWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                    ),
                    rightIcon: Icon(
                      Icons.arrow_forward,
                      color: loginWatch.isAllFieldsValid || signUpWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                      size: 30.h,
                    ),
                    isLoading: loginWatch.loginState.isLoading || signUpWatch.signUpState.isLoading || otpVerificationWatch.sendOtpState.isLoading,
                    onTap: () async {
                      if (loginWatch.isLogin) {
                        ///For Login
                        await _loginApi(ref, context);
                      } else {
                        ///For Sign Up
                        if (signUpWatch.isAcceptTermsAndCondition) {
                          await _signUpApi(ref, context);
                        } else {
                          showMessageDialog(context, LocaleKeys.keyPleaseAcceptTermsAndConditionAndPrivacyPolicy.localized, () {
                            Navigator.of(context).pop();
                          });
                        }
                      }
                    },
                    onValidateTap: () {
                      if (loginWatch.isLogin) {
                        ///For Login
                        loginWatch.formKey.currentState?.validate();
                      } else {
                        ///For Sign Up
                        signUpWatch.signUpFormKey.currentState?.validate();
                      }
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: context.width * 0.060, vertical: context.height * 0.050),
            ),
            DialogProgressBar(isLoading: signUpWatch.cmsState.isLoading)
          ],
        );
      },
    );
  }

  _loginApi(WidgetRef ref, BuildContext context) async {
    final loginWatch = ref.watch(loginController);

    await loginWatch.loginApi(context, ref: ref);
  }

  ///Sign Up Api
  _signUpApi(WidgetRef ref, BuildContext context) async {
    final signUpWatch = ref.watch(signUpController);
    // final otpVerificationWatch = ref.watch(otpVerificationController);
    final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
    await signUpWatch.signUpApi(context, countryUuid: agencyRegistrationFormWatch.selectedCountry?.uuid ?? '');
    if (signUpWatch.signUpState.success?.status == ApiEndPoints.apiStatus_200) {
      // await otpVerificationWatch.sendOtpApi(context,
      //   email: signUpWatch.emailController.text.toLowerCase(),
      //   mobileNo: signUpWatch.mobileNumberController.text,
      //   userUuid: signUpWatch.signUpState.success?.data?.uuid,
      // );
      if (signUpWatch.signUpState.success?.status == ApiEndPoints.apiStatus_200) {
        ref.read(navigationStackController).push(NavigationStackItem.otpVerification(email: signUpWatch.emailController.text));
      }
    }
  }
}
