import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/forgot_password_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ForgotPasswordFormWeb extends ConsumerWidget with BaseConsumerWidget {
  const ForgotPasswordFormWeb({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final forgotPasswordWatch = ref.watch(forgotPasswordController);
    return FadeBoxTransition(
      child: Form(
        key: forgotPasswordWatch.formKey,
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Back Button
                InkWell(
                  child: CommonSVG(strIcon: Assets.svgs.svgBackRounded.keyName, height: context.height * 0.077, width: context.width * 0.077),
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                ),
                SizedBox(
                  height: 35.h,
                ),

                ///Page Title
                CommonText(
                  title: LocaleKeys.keyForgotPassword.localized,
                  textStyle: TextStyles.semiBold.copyWith(fontSize: 24.sp, color: AppColors.black),
                ),
                SizedBox(
                  height: 25.h,
                ),

                ///Description
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CommonText(
                        title: LocaleKeys.keyEnterYourEmail.localized,
                        maxLines: 3,
                        textStyle: TextStyles.regular.copyWith(fontSize: 21.sp, color: AppColors.black272727),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),

                /// Email Form Field
                CommonInputFormField(
                  textEditingController: forgotPasswordWatch.emailController,
                  hintText: LocaleKeys.keyEmailId.localized,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (value) {
                    forgotPasswordWatch.checkIfAllFieldsValid();
                  },
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    return validateEmail(value);
                  },
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(maxEmailLength),
                    FilteringTextInputFormatter.deny(constEmailRegex),
                    convertInputToSmallCase()
                  ],
                  onFieldSubmitted: (value) async {
                    ///Forgot Password Api
                    await _forgotPasswordApi(ref, context);
                  },
                ),
                SizedBox(
                  height: 70.h,
                ),

                ///Reset Password Button
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CommonButton(
                        height: 73.h,
                        buttonText: LocaleKeys.keyResetPassword.localized,
                        buttonEnabledColor: AppColors.black,
                        buttonDisabledColor: AppColors.buttonDisabledColor,
                        isButtonEnabled: forgotPasswordWatch.isAllFieldsValid,
                        buttonTextStyle: TextStyles.regular.copyWith(
                          fontSize: 20.sp,
                          color: forgotPasswordWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                        ),
                        rightIcon: Icon(
                          Icons.arrow_forward,
                          size: 30.h,
                          color: forgotPasswordWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                        ),
                        isLoading: forgotPasswordWatch.forgotPasswordState.isLoading,
                        onTap: () async {
                          ///Forgot Password Api
                          await _forgotPasswordApi(ref, context);
                        },
                        onValidateTap: () {
                          forgotPasswordWatch.formKey.currentState?.validate();
                        },
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: context.width * 0.060, vertical: context.height * 0.050),
          ),
        ),
      ),
    );
  }

  ///Forgot Password Api
  _forgotPasswordApi(WidgetRef ref, BuildContext context) async {
    final forgotPasswordWatch = ref.watch(forgotPasswordController);
    await forgotPasswordWatch.forgotPasswordApi(context);
    if (forgotPasswordWatch.forgotPasswordState.success?.status == ApiEndPoints.apiStatus_200) {
      /// Set Cookie For Email
      setCookie(keyResetPasswordEmail, forgotPasswordWatch.emailController.text);
      await Session.saveLocalData(keyIsVerifiedForResetPassword, false);
      ref.read(navigationStackController).push(NavigationStackItem.otpVerification(email: forgotPasswordWatch.emailController.text));
    }
  }
}
