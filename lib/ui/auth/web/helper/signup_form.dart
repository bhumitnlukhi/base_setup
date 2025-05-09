import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/signup_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/country_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/auth/web/helper/cms_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final signUpWatch = ref.watch(signUpController);
      final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
      signUpWatch.disposeController(isNotify: true);
      await agencyRegistrationFormWatch.countryListApi(context);
      agencyRegistrationFormWatch.disposeCountryValue();
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final signUpWatch = ref.watch(signUpController);
        final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
        return FadeBoxTransition(
          child: Form(
            key: signUpWatch.signUpFormKey,
            child: agencyRegistrationFormWatch.countryState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.height * 0.01,
                        ),

                        ///Name
                        CommonInputFormField(
                          textEditingController: signUpWatch.nameController,
                          hintText: Session.getUserType().toString() == UserType.VENDOR.name ? LocaleKeys.keyName.localized : LocaleKeys.keyAgencyName.localized,
                          textInputType: TextInputType.name,
                          onChanged: (value) {
                            signUpWatch.checkIfAllFieldsValid(ref);
                          },
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return validateText(value, Session.getUserType().toString() == UserType.VENDOR.name ? LocaleKeys.keyNameRequired.localized : LocaleKeys.keyAgencyNameValidation.localized);
                          },
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow( regExpBlocEmoji),
                            LengthLimitingTextInputFormatter(maxAddressLength)],
                          onFieldSubmitted: (value) {
                            context.nextField;
                          },
                        ),

                        SizedBox(
                          height: context.height * 0.03,
                        ),

                        ///Enter Email Field
                        CommonInputFormField(
                          textEditingController: signUpWatch.emailController,
                          hintText: LocaleKeys.keyEmailId.localized,
                          textInputType: TextInputType.emailAddress,
                          onChanged: (value) {
                            signUpWatch.checkIfAllFieldsValid(ref);
                          },
                          textInputFormatter: [
                            FilteringTextInputFormatter.deny(constEmailRegex), // Prevents spaces
                            LengthLimitingTextInputFormatter(maxEmailLength),
                            convertInputToSmallCase()
                          ],
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return validateEmail(value);
                          },
                          onFieldSubmitted: (value) {
                            context.nextField;
                          },
                        ),

                        SizedBox(
                          height: context.height * 0.03,
                        ),

                        ///Enter Mobile Number Field
                        CommonInputFormField(
                          textEditingController: signUpWatch.mobileNumberController,
                          hintText: LocaleKeys.keyMobileNumber.localized,
                          textInputType: TextInputType.phone,
                          onChanged: (value) {
                            signUpWatch.checkIfAllFieldsValid(ref);
                          },
                          textInputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(contactNumberLength),
                          ],
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return validateMobile(value);
                          },
                          onFieldSubmitted: (value) {
                            context.nextField;
                          },
                        ),

                        SizedBox(
                          height: context.height * 0.03,
                        ),

                        ///Country Api
                        CommonDropdownInputFormField<CountryDto>(
                          menuItems: agencyRegistrationFormWatch.countryState.success?.data,
                          items: (agencyRegistrationFormWatch.countryState.success?.data)
                              ?.map(
                                (item) => DropdownMenuItem<CountryDto>(
                                  value: item,
                                  child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                ),
                              )
                              .toList(),
                          // height: context.height * 0.049,
                          contentPadding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 5.w),
                          defaultValue: agencyRegistrationFormWatch.selectedCountry,
                          hintText: LocaleKeys.keyCountry.localized,
                          onChanged: (value) async {
                            agencyRegistrationFormWatch.updateCountry(value);
                            signUpWatch.checkIfAllFieldsValid(ref);
                          },
                          validator: (value) {
                            return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyCountryRequired.localized);
                          },
                        ),

                        SizedBox(
                          height: context.height * 0.03,
                        ),

                        /// Enter Password Field
                        CommonInputFormField(
                          obscureText: signUpWatch.isShowPassword,
                          textEditingController: signUpWatch.passwordController,
                          hintText: LocaleKeys.keyPassword.localized,
                          maxLength: 16,
                          textInputAction: TextInputAction.next,
                          validator: (password) {
                            return null;

                            // return validatePassword(password);
                          },
                          onChanged: (password) {
                            signUpWatch.checkIfAllFieldsValid(ref);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(signUpWatch.passwordFocusNode);
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              signUpWatch.changePasswordVisibility();
                            },
                            icon: CommonSVG(
                              strIcon: signUpWatch.isShowPassword ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName,
                              boxFit: BoxFit.scaleDown,
                              height: context.height * 0.024,
                              width: context.width * 0.024,
                            ),
                          ).paddingOnly(right: 20.w),
                        ),
                        Visibility(
                            visible: signUpWatch.passwordController.text.isNotEmpty && !((signUpWatch.passwordController.text.length>=8 && signUpWatch.passwordController.text.length<=16 ) &&
                                RegExp(r'[a-z]').hasMatch(signUpWatch.passwordController.text) &&
                                RegExp(r'[A-Z]').hasMatch(signUpWatch.passwordController.text) &&
                                RegExp(r'[0-9]').hasMatch(signUpWatch.passwordController.text) &&
                                RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(signUpWatch.passwordController.text)),
                            child: passwordValidation(signUpWatch.passwordController)),

                        SizedBox(
                          height: context.height * 0.03,
                        ),

                        /// Confirm Password Field
                        CommonInputFormField(
                          focusNode: signUpWatch.passwordFocusNode,
                          obscureText: signUpWatch.isShowConfirmPassword,
                          textEditingController: signUpWatch.confirmPasswordController,
                          maxLength: 16,
                          hintText: LocaleKeys.keyConfirmPassword.localized,
                          textInputAction: TextInputAction.done,
                          onChanged: (email) {
                            signUpWatch.checkIfAllFieldsValid(ref);
                          },
                          validator: (password) {
                            return null;

                            // if (password != null && password.length > 7 && password != signUpWatch.passwordController.text) {
                            //   return LocaleKeys.keyConfirmPasswordMustAsPassword.localized;
                            // } else {
                            //   return validateConfirmPassword(password, signUpWatch.passwordController.text);
                            // }
                          },
                          onFieldSubmitted: (value) async {
                            await _signUpApi(ref, context);
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              signUpWatch.changeConfirmPasswordVisibility();
                            },
                            icon: CommonSVG(
                              strIcon: signUpWatch.isShowConfirmPassword ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName,
                              boxFit: BoxFit.scaleDown,
                              height: context.height * 0.024,
                              width: context.width * 0.024,
                            ),
                          ).paddingOnly(right: 20.w),
                        ),

                        Visibility(
                          visible: signUpWatch.confirmPasswordController.text.isNotEmpty && !(signUpWatch.passwordController.text==signUpWatch.confirmPasswordController.text),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CommonSVG(strIcon: (signUpWatch.confirmPasswordController.text==signUpWatch.passwordController.text && signUpWatch.confirmPasswordController.text.isNotEmpty)?Assets.svgs.svgGreenRightArrow.keyName:Assets.svgs.svgGreyDot.keyName,height: 12.h,width: 12.h,boxFit: BoxFit.scaleDown,).paddingOnly(right: 5.w),
                              CommonText(title: LocaleKeys.keyConfirmPasswordMatch.localized,textStyle: TextStyles.regular.copyWith(
                                  fontSize: 14.sp,
                                  color: signUpWatch.confirmPasswordController.text==signUpWatch.passwordController.text?AppColors.black:AppColors.clr8D8D8D
                              ),),
                            ],
                          ).paddingOnly(bottom: 6.h,top: 6.h),
                        ),

                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                signUpWatch.updateTermsAndCondition();
                              },
                              child: Icon(
                                !signUpWatch.isAcceptTermsAndCondition ? Icons.check_box_outline_blank : Icons.check_box_outlined,
                                size: 30.h,
                                color: AppColors.black,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${LocaleKeys.keyIHaveReadAndAgreedToThe.localized} ',
                                style: TextStyles.regular.copyWith(fontSize: 16.sp),
                                children: [
                                  TextSpan(
                                    text: LocaleKeys.keyTermsAndCondition.localized,
                                    style: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.blue, decoration: TextDecoration.underline),
                                    children: [
                                      TextSpan(
                                        text: ' ${LocaleKeys.keyAnd.localized} ',
                                        style: TextStyles.regular.copyWith(fontSize: 16.sp, decoration: TextDecoration.none),
                                        children: [
                                          TextSpan(
                                            text: LocaleKeys.keyPrivacyPolicy.localized,
                                            style: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.blue, decoration: TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                await signUpWatch.cmsAPI(context, cmsType: CmsType.privacyPolicy.name).then((value) {
                                                  if (value.success?.status == ApiEndPoints.apiStatus_200) {
                                                    showCMSDialog(
                                                        context,
                                                        SizedBox(
                                                          height: 600.h,
                                                          width: 800.w,
                                                          child: SingleChildScrollView(
                                                            child: CMSWidget(
                                                              title: CmsType.privacyPolicy.name,
                                                              content: value.success?.data?.fieldValue ?? '',
                                                            ),
                                                          ),
                                                        ),
                                                        () {});
                                                  }
                                                });
                                              },
                                          ),
                                        ],
                                      ),
                                    ],
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await signUpWatch.cmsAPI(context, cmsType: CmsType.termsAndCondition.name).then((value) {
                                          if (value.success?.status == ApiEndPoints.apiStatus_200) {
                                            showCMSDialog(
                                                context,
                                                SizedBox(
                                                  height: 600.h,
                                                  width: 800.w,
                                                  child: SingleChildScrollView(
                                                    child: CMSWidget(
                                                      title: 'Terms And Condition',
                                                      content: value.success?.data?.fieldValue ?? '',
                                                    ),
                                                  ),
                                                ),
                                                () {});
                                          }
                                        });
                                      },
                                  ),
                                ],
                              ),
                            ).paddingOnly(left: 10.w),
                          ],
                        ).paddingOnly(top: 16.h)
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  _signUpApi(WidgetRef ref, BuildContext context) async {
    final signUpWatch = ref.watch(signUpController);
    // final otpVerificationWatch = ref.watch(otpVerificationController);
    final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
    if (signUpWatch.signUpFormKey.currentState!.validate()) {
      await signUpWatch.signUpApi(context, countryUuid: agencyRegistrationFormWatch.selectedCountry?.uuid ?? '');
      if (signUpWatch.signUpState.success?.status == ApiEndPoints.apiStatus_200) {
        // await otpVerificationWatch.sendOtpApi(context,
        //   email: signUpWatch.emailController.text.toLowerCase(),
        //   mobileNo: signUpWatch.mobileNumberController.text,
        //   userUuid: signUpWatch.signUpState.success?.data?.userUuid,
        // );
        // if(otpVerificationWatch.sendOtpState.success?.status==ApiEndPoints.apiStatus_200){
        ref.read(navigationStackController).push(NavigationStackItem.otpVerification(email: signUpWatch.emailController.text));
        // }
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
