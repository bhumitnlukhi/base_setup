import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ChangeEmailDialog extends ConsumerWidget with BaseConsumerWidget {
  final Function() onTap;

  const ChangeEmailDialog({
    super.key,
    required this.onTap,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(
        //   height: context.height * 0.010,
        // ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ///Change Email title
            CommonText(
              title: LocaleKeys.keyChangeEmail.localized,
              textStyle: TextStyles.regular.copyWith(
                fontSize: 24.sp,
                color: AppColors.black171717,
              ),
            ),

            ///Crossed Icon
            InkWell(
              onTap: () {
                profileWatch.clearFormData();
                profileWatch.disposeKeys();
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

        SizedBox(height: context.height * 0.05,),
        // const Spacer(),

        ///Form
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ///Form
            Form(
              key: profileWatch.changeEmailKey,
              child: Column(
                children: [

                  ///New Email Field
                  CommonInputFormField(
                    textEditingController: profileWatch.newEmailController,
                    hintText: LocaleKeys.keyNewEmail.localized,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      context.nextField;
                    },
                    onChanged: (value) {
                      profileWatch.checkIfEmailValid();
                    },
                    textInputFormatter: [
                      FilteringTextInputFormatter.deny(constEmailRegex),
                      LengthLimitingTextInputFormatter(maxEmailLength),
                      convertInputToSmallCase()
                    ],
                    validator: (value) {
                      return validateEmail(value);
                    },
                  ),

                  SizedBox(
                    height: context.height * 0.030,
                  ),

                  ///New Password Field
                  CommonInputFormField(
                    obscureText: profileWatch.isShowNewPassword,
                    textEditingController: profileWatch.emailPasswordController,
                    maxLength: 16,
                    hintText: LocaleKeys.keyCurrentPassword.localized,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.deny(RegExp('[ ]')),
                    ],
                    validator: (password) {
                      return validateCurrentPassword(password);
                    },
                    onChanged: (password) {
                      profileWatch.checkIfEmailValid();
                    },
                    suffixWidget: IconButton(
                      onPressed: () {
                        profileWatch.changePasswordVisibility();
                      },
                      icon: CommonSVG(
                        height: context.height * 0.024,
                        width: context.width * 0.024,
                        boxFit: BoxFit.scaleDown,
                        strIcon: profileWatch.isShowNewPassword ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.height * 0.05,),
        // const Spacer(),

        ///Change Email
        CommonButton(
          onTap: () async {
            onTap();
          },
          isLoading: profileWatch.checkPasswordState.isLoading || profileWatch.sendOtpState.isLoading,
          width: context.width * 0.1,
          height: context.height * 0.080,
          buttonText: LocaleKeys.keySave.localized,
          buttonTextStyle: TextStyles.regular.copyWith(color: profileWatch.isEmailFieldsValid ? AppColors.white : AppColors.black171717, fontSize: 18.sp),
          buttonTextSize: 18.sp,
          onValidateTap: () {
            profileWatch.changeEmailKey.currentState?.validate();
          },
          isButtonEnabled: profileWatch.isEmailFieldsValid,
        ),
      ],
    ).paddingSymmetric(
      horizontal: context.height * 0.050,
      vertical: context.height * 0.030,
    );
  }
}
