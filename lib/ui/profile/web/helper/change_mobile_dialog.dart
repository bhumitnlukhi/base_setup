import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';


class ChangeMobileDialog extends ConsumerWidget with BaseConsumerWidget {
  const ChangeMobileDialog({
    super.key,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
      final profileWatch = ref.watch(profileController);

      return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.h,
          ),

          ///Change Mobile Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                title: LocaleKeys.keyChangeMobile.localized,
                textStyle: TextStyles.regular.copyWith(
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
                child:  CommonSVG(
                  strIcon: Assets.svgs.svgCrossRounded.keyName,
                  height: context.height*0.060,
                  width: context.width*0.060,
                ),
              ),
            ],
          ),

          ///Mobile Number Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Form(
                key: profileWatch.changeMobileKey,
                child: Column(
                  children: [
                    CommonInputFormField(
                      textEditingController: profileWatch.newMobileController,
                      hintText: LocaleKeys.keyNewMobile.localized,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(contactNumberLength),
                      ],
                      onFieldSubmitted: (value) {
                        context.nextField;
                      },
                      onChanged: (value) {
                        profileWatch.validateNewMobile();
                      },
                      validator: (value) {
                        return validateMobile(value);
                      },
                    ),

                    SizedBox(
                      height: context.height * 0.030,
                    ),

                    ///New Password Field
                    // CommonInputFormField(
                    //   obscureText: profileWatch.isShowNewPassword,
                    //   textEditingController: profileWatch.mobilePasswordController,
                    //   maxLength: 16,
                    //   hintText: LocaleKeys.keyCurrentPassword.localized,
                    //   textInputAction: TextInputAction.next,
                    //   textInputFormatter: [
                    //     FilteringTextInputFormatter.deny(RegExp('[ ]')),
                    //   ],
                    //   validator: (password) {
                    //     return validateCurrentPassword(password);
                    //   },
                    //   onChanged: (password) {
                    //     profileWatch.validateNewMobile();
                    //   },
                    //   suffixWidget: IconButton(
                    //     onPressed: () {
                    //       profileWatch.changePasswordVisibility();
                    //     },
                    //     icon: CommonSVG(
                    //       height: context.height*0.024,
                    //       width: context.width*0.024,
                    //       boxFit: BoxFit.scaleDown,
                    //       strIcon: profileWatch.isShowNewPassword ?  Assets.svgs.svgPasswordUnhide.keyName :Assets.svgs.svgPasswordHide.keyName,
                    //     ),
                    //   ).paddingOnly(right: 20.w),
                    // ),

                    // SizedBox(
                    //   height: context.height * 0.015,
                    // ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),

          ///Change Verify
          CommonButton(
            onTap: ()async {
              await updateMobileApi(context, ref);
            },
            isLoading:profileWatch.updateEmailOrMobileState.isLoading,
            width: context.width * 0.1,
            height: context.height*0.080,
            buttonText: LocaleKeys.keySave.localized,
            buttonTextStyle: TextStyles.regular.copyWith(
              color: profileWatch.isNewMobileValid
                  ? AppColors.white
                  : AppColors.black171717,
              fontSize: 18.sp
            ),
            onValidateTap: (){
              profileWatch.changeMobileKey.currentState?.validate();
            },
            buttonTextSize: 18.sp,
            isButtonEnabled: profileWatch.isNewMobileValid,
          ),
        ],
      ).paddingSymmetric(
        horizontal: 50.w,
        vertical: 30.h,
      ),
    );
  }

  ///Send Otp
  // sendOTPApi(BuildContext context,WidgetRef ref) async{
  //   final profileWatch = ref.watch(profileController);
  //   if(profileWatch.profileDetailState.success?.data?.contactNumber==profileWatch.newMobileController.text){
  //     showCommonErrorDialog(context: context, message: LocaleKeys.keyOldMobileAndNewValidation.localized);
  //   }else{
  //     ///Check Password Api
  //     await profileWatch.checkPassword(context, profileWatch.mobilePasswordController.text);
  //     if (profileWatch.checkPasswordState.success?.status == ApiEndPoints.apiStatus_200 && context.mounted) {
  //
  //       ///Send Otp Api
  //       await profileWatch.sendOtpApi(context,mobileNo: profileWatch.newMobileController.text);
  //       if(profileWatch.sendOtpState.success?.status==ApiEndPoints.apiStatus_200){
  //         profileWatch.startCounter();
  //         if (context.mounted) {
  //           showCommonWebDialog(
  //             keyBadge: profileWatch.sendOtpDialogKey,
  //             context: context,
  //             height:0.65,
  //             width: 0.5,
  //             dialogBody: ChangeEmailOrPhoneVerifyOtpDialog(isEmail: false).paddingSymmetric(
  //               horizontal: context.width * 0.03,
  //               vertical: context.height * 0.03,
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   }
  // }

  ///Update Mobile Api
  updateMobileApi(BuildContext context,WidgetRef ref) async{
    final profileWatch = ref.watch(profileController);

    ///Update Mobile Api
    await profileWatch.updateEmailMobileApi(context:context,isEmail: false, mobileNo:profileWatch.newMobileController.text,otp: profileWatch.changeEmailOrMobileOtpController.text, password: profileWatch.mobilePasswordController.text);
    if(profileWatch.updateEmailOrMobileState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted){
      if(context.mounted){
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
          title: LocaleKeys.keyChangeMobileSuccessfully.localized,
          titleWidget: SizedBox(
            width: context.width * 0.17,
            child: CommonText(
              title:
              LocaleKeys.keyChangeMobileSuccessfully.localized,
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

}
