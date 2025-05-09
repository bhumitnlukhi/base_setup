import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/start_journey/start_journey_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/delegate.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AddContactUsWidget extends ConsumerStatefulWidget {
  const AddContactUsWidget({super.key});

  @override
  ConsumerState<AddContactUsWidget> createState() => _AddContactUsWidgetState();
}

class _AddContactUsWidgetState extends ConsumerState<AddContactUsWidget> {
  /// Form Key
  final formKey = GlobalKey<FormState>();

  /// TextEditing Controller
  final TextEditingController nameCTR = TextEditingController();
  final TextEditingController emailCTR = TextEditingController();
  final TextEditingController mobileNumberCTR = TextEditingController();
  final TextEditingController descriptionCTR = TextEditingController();

  /// Main Build
  @override
  Widget build(BuildContext context) {
    final startJourneyWatch = ref.watch(startJourneyController);
    return SizedBox(
      width: 700.w,
      height: 600.h,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    title: LocaleKeys.keyContactDetails.localized,
                    textStyle: TextStyles.semiBold.copyWith(fontSize: 26.sp, color: AppColors.black),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CommonSVG(
                      strIcon: Assets.svgs.svgClose.path,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Expanded(
                    child: CommonInputFormField(
                      textEditingController: nameCTR,
                      hintText: LocaleKeys.keyName.localized,
                      textInputType: TextInputType.name,
                      onChanged: (value) {
                        // agencyRegistrationFormWatch.checkIfAllFieldsValid();
                      },
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return validateText(value, LocaleKeys.keyNameIsRequired.localized);
                      },
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(maxAddressLength),
                      ],
                      onFieldSubmitted: (value) {
                        context.nextField;
                      },
                      contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                    ),
                  ),

                  SizedBox(
                    width: 13.w,
                  ),

                  /// Name
                  Expanded(
                    child: CommonInputFormField(
                      textEditingController: mobileNumberCTR,
                      hintText: LocaleKeys.keyContactNumber.localized,
                      textInputType: TextInputType.phone,
                      onChanged: (value) {
                        // agencyRegistrationFormWatch.checkIfAllFieldsValid();
                      },
                      onFieldSubmitted: (value) {
                        context.nextField;
                      },
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(contactNumberLength),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return validateMobile(value);
                      },
                      contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                    ),
                  ),
                ],
              ).paddingOnly(top: 31.h),

              /// Email
              CommonInputFormField(
                textEditingController: emailCTR,
                hintText: LocaleKeys.keyEmailId.localized,
                textInputType: TextInputType.emailAddress,
                onChanged: (value) {
                  // signUpWatch.checkIfAllFieldsValid(ref);
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
              ).paddingOnly(top: 27.h),

              /// Description
              CommonInputFormField(
                textEditingController: descriptionCTR,
                hintText: LocaleKeys.keyDescription.localized,
                textInputType: TextInputType.multiline,
                onChanged: (value) {
                  startJourneyWatch.updateDescription(value);
                },
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(400),
                ],
                maxLines: 5,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  return validateDescriptionText(value, LocaleKeys.keyDescriptionIsRequired.localized);
                },
                onFieldSubmitted: (value) {},
              ).paddingOnly(top: 27.h),

              CommonText(title: '${startJourneyWatch.strDescription.length}/400').paddingOnly(top: 5.h, right: 5.w).alignAtCenterRight(),

              CommonButton(
                onTap: () async {
                  bool? isValidate = formKey.currentState?.validate();

                  if (isValidate != null && isValidate) {
                    await startJourneyWatch.addContactUsAPI(context, name: nameCTR.text, description: descriptionCTR.text, mobileNumber: mobileNumberCTR.text, email: emailCTR.text);
                    if (context.mounted) {
                      Navigator.of(context).pop();

                      if (startJourneyWatch.addContactUsState.success?.status == ApiEndPoints.apiStatus_200) {
                        showMessageDialog(globalNavigatorKey.currentContext!, LocaleKeys.keyContactUsSuccessContent.localized, () {
                          Navigator.of(globalNavigatorKey.currentContext!).pop();
                        });
                      }
                    }
                  }
                },
                buttonText: LocaleKeys.keySubmit.localized,
                isLoading: startJourneyWatch.addContactUsState.isLoading,
                height: 50.h,
                width: 150.w,
                isButtonEnabled: true,
              ).alignAtCenterRight().paddingOnly(top: 50.h),
            ],
          ).paddingOnly(left: 33.w, top: 27.h, right: 26.w, bottom: 27.h),
        ),
      ),
    );
  }
}
