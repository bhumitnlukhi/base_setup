import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/country_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/state_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/auth/web/helper/agency_signup_image_selection_widget.dart';
import 'package:odigo_vendor/ui/auth/web/helper/waiting_dialog.dart';
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
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AgencyRegistrationFormWidget extends StatelessWidget with BaseStatelessWidget {
  final bool? isEdit;

  const AgencyRegistrationFormWidget({super.key, this.isEdit});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
        final profileWatch = ref.watch(profileController);
        final loginWatch = ref.watch(loginController);
        return agencyRegistrationFormWatch.countryState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    FadeBoxTransition(
                      child: Form(
                        key: agencyRegistrationFormWatch.agencyRegistrationFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: context.height * 0.01,
                            ),

                            ///Agency Name
                            (isEdit ?? false)
                                ? CommonInputFormField(
                                    textEditingController: agencyRegistrationFormWatch.nameController,
                                    hintText: LocaleKeys.keyAgencyName.localized,
                                    textInputType: TextInputType.name,
                                    onChanged: (value) {
                                      agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                    },
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      return validateText(value, LocaleKeys.keyNameRequired.localized);
                                    },
                                    textInputFormatter: [
                                      FilteringTextInputFormatter.allow( regExpBlocEmoji),
                                      LengthLimitingTextInputFormatter(maxAddressLength),
                                    ],
                                    onFieldSubmitted: (value) {
                                      context.nextField;
                                    },
                                    contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                                  )
                                : const SizedBox(),

                            (isEdit ?? false)
                                ? SizedBox(
                                    height: context.height * 0.03,
                                  )
                                : const SizedBox(),

                            ///Owners Name
                            CommonInputFormField(
                              textEditingController: agencyRegistrationFormWatch.ownerNameController,
                              hintText: LocaleKeys.keyOwnersName.localized,
                              textInputType: TextInputType.name,
                              onChanged: (value) {
                                agencyRegistrationFormWatch.checkIfAllFieldsValid();
                              },
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return validateText(value, LocaleKeys.keyOwnersNameRequired.localized);
                              },
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow( regExpBlocEmoji),
                                LengthLimitingTextInputFormatter(maxAddressLength),
                              ],
                              onFieldSubmitted: (value) {
                                context.nextField;
                              },
                              contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            ///Upload Documents Required
                            CommonText(
                              title: LocaleKeys.keyUploadDocumentsRequired.localized,
                              textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.clr8D8D8D),
                            ),

                            SizedBox(
                              height: context.height * 0.02,
                            ),

                            const AgencySignUpImageSelectionWidget(),

                            ///Image Validation
                            agencyRegistrationFormWatch.isImageValidate
                                ? CommonText(
                                    title: LocaleKeys.keyImageValidation.localized,
                                    textStyle: TextStyles.regular.copyWith(color: AppColors.errorColor, fontSize: 16.sp),
                                  ).paddingOnly(top: context.height * 0.02)
                                : const Offstage(),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            ///Address
                            CommonText(
                              title: LocaleKeys.keyAddress.localized,
                              textStyle: TextStyles.regular.copyWith(fontSize: 22.sp, color: AppColors.black171717),
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///House Name
                                Expanded(
                                    child: CommonInputFormField(
                                  textEditingController: agencyRegistrationFormWatch.houseNameController,
                                  hintText: LocaleKeys.keyHouseName.localized,
                                  textInputType: TextInputType.name,
                                  onChanged: (value) {
                                    agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                  },
                                  textInputFormatter: [
                                    LengthLimitingTextInputFormatter(maxAddressLength),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    return validateTextIgnoreLength(value, LocaleKeys.keyHouseNameRequired.localized);
                                  },
                                  onFieldSubmitted: (value) {
                                    context.nextField;
                                  },
                                  contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                                ).paddingOnly(right: context.width * 0.020)),

                                ///Street Name
                                Expanded(
                                    child: CommonInputFormField(
                                  textEditingController: agencyRegistrationFormWatch.streetNameController,
                                  hintText: LocaleKeys.keyStreetName.localized,
                                  textInputType: TextInputType.name,
                                  onChanged: (value) {
                                    agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                  },
                                  textInputFormatter: [
                                    LengthLimitingTextInputFormatter(maxAddressLength),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    return validateText(value, LocaleKeys.keyStreetNameRequired.localized);
                                  },
                                  onFieldSubmitted: (value) {
                                    context.nextField;
                                  },
                                  contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                                ))
                              ],
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            ///Address 1
                            CommonInputFormField(
                              textEditingController: agencyRegistrationFormWatch.address1Controller,
                              hintText: LocaleKeys.keyAddressLine1.localized,
                              textInputType: TextInputType.name,
                              onChanged: (value) {
                                agencyRegistrationFormWatch.checkIfAllFieldsValid();
                              },
                              textInputFormatter: [
                                LengthLimitingTextInputFormatter(maxAddressContentLength),
                              ],
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return validateText(value, LocaleKeys.keyAddressLine1Required.localized);
                              },
                              onFieldSubmitted: (value) {
                                context.nextField;
                              },
                              contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            ///Address 2
                            CommonInputFormField(
                              textEditingController: agencyRegistrationFormWatch.address2Controller,
                              hintText: LocaleKeys.keyAddressLine2.localized,
                              textInputType: TextInputType.name,
                              onChanged: (value) {
                                agencyRegistrationFormWatch.checkIfAllFieldsValid();
                              },
                              textInputFormatter: [
                                LengthLimitingTextInputFormatter(maxAddressContentLength),
                              ],
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return validateText(value, LocaleKeys.keyAddressLine2Required.localized);
                              },
                              onFieldSubmitted: (value) {
                                context.nextField;
                              },
                              contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            ///Country and State
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Country
                                Expanded(
                                  child: CommonDropdownInputFormField<CountryDto>(
                                    isEnabled: false,
                                    menuItems: agencyRegistrationFormWatch.countryState.success?.data,
                                    items: (agencyRegistrationFormWatch.countryState.success?.data)
                                        ?.map(
                                          (item) => DropdownMenuItem<CountryDto>(
                                            value: item,
                                            child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                          ),
                                        )
                                        .toList(),
                                    height: context.height * 0.049,
                                    contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                                    defaultValue: agencyRegistrationFormWatch.selectedCountry,
                                    hintText: LocaleKeys.keyCountry.localized,
                                    onChanged: (value) async {
                                      agencyRegistrationFormWatch.updateCountry(value);
                                      agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                      await agencyRegistrationFormWatch.stateListApi(context, countryUuid: agencyRegistrationFormWatch.selectedCountry?.uuid);
                                    },
                                    validator: (value) {
                                      return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyCountryRequired.localized);
                                    },
                                  ).paddingOnly(right: context.width * 0.020),
                                ),

                                ///State
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: agencyRegistrationFormWatch.state.isLoading,
                                    child: CommonDropdownInputFormField<StateDto>(
                                      isEnabled: isEdit == true ? false : true,
                                      menuItems: agencyRegistrationFormWatch.state.success?.data,
                                      items: (agencyRegistrationFormWatch.state.success?.data)
                                          ?.map(
                                            (item) => DropdownMenuItem<StateDto>(
                                              value: item,
                                              child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                            ),
                                          )
                                          .toList(),
                                      // height: context.height * 0.049,
                                      contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                                      defaultValue: agencyRegistrationFormWatch.selectedState,
                                      hintText: LocaleKeys.keyState.localized,
                                      onChanged: (value) async {
                                        agencyRegistrationFormWatch.updateState(value);
                                        agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                        await agencyRegistrationFormWatch.cityListApi(context, countryUuid: agencyRegistrationFormWatch.selectedCountry?.uuid, stateUuid: agencyRegistrationFormWatch.selectedState?.uuid);
                                      },
                                      validator: (value) {
                                        return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyStateRequired.localized);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            ///City and PostCode
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///City
                                Expanded(
                                  child: IgnorePointer(
                                    ignoring: agencyRegistrationFormWatch.cityState.isLoading,
                                    child: CommonDropdownInputFormField<CityDto>(
                                      isEnabled: isEdit == true ? false : true,
                                      menuItems: agencyRegistrationFormWatch.cityState.success?.data,
                                      items: (agencyRegistrationFormWatch.cityState.success?.data)
                                          ?.map(
                                            (item) => DropdownMenuItem<CityDto>(
                                              value: item,
                                              child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                            ),
                                          )
                                          .toList(),
                                      // height: context.height * 0.049,
                                      contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                                      defaultValue: agencyRegistrationFormWatch.selectedCity,
                                      hintText: LocaleKeys.keyCity.localized,
                                      onChanged: (value) {
                                        agencyRegistrationFormWatch.updateCity(value);
                                        agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                      },
                                      validator: (value) {
                                        return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyCityRequired.localized);
                                      },
                                    ).paddingOnly(right: context.width * 0.020),
                                  ),
                                ),

                                ///PostCode
                                Expanded(
                                  child: CommonInputFormField(
                                    contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                                    textEditingController: agencyRegistrationFormWatch.postCodeController,
                                    hintText: LocaleKeys.keyPostCode.localized,
                                    textInputType: TextInputType.name,
                                    maxLength: postCodeLength,
                                    onChanged: (value) {
                                      agencyRegistrationFormWatch.checkIfAllFieldsValid();
                                    },
                                    textInputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      return validatePostalCode(value, LocaleKeys.keyPostCodeRequired.localized);
                                    },
                                    onFieldSubmitted: (value) {
                                      context.nextField;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: context.height * 0.04,
                            ),

                            ///Sign Up
                            CommonButton(
                              onTap: () async {
                                ///Check Validation
                                agencyRegistrationFormWatch.checkImageValidation();
                                if (agencyRegistrationFormWatch.isImageValidate == false) {
                                  ///Upload Document Api
                                  if (agencyRegistrationFormWatch.documentListForRemove?.isNotEmpty == true && isEdit == true) {
                                    await agencyRegistrationFormWatch.deleteAgencyDocumentApi(context);
                                  }
                                  if(context.mounted){
                                    await agencyRegistrationFormWatch
                                        .uploadAgencyDocumentApi(context,
                                            uuid: Session.getUuid().toString());
                                  }
                                  if (agencyRegistrationFormWatch.uploadAgencyDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
                                    ///Upload Store Api
                                    if(context.mounted){
                                      await agencyRegistrationFormWatch
                                          .agencyRegistrationApi(context);
                                    }
                                    if (agencyRegistrationFormWatch.agencyRegistrationState.success?.status == ApiEndPoints.apiStatus_200) {
                                      if (isEdit == true) {
                                        if(context.mounted){
                                          await agencyRegistrationFormWatch
                                              .updateAgencyNameAPI(context);
                                        }
                                        if (agencyRegistrationFormWatch.updateAgencyRegistrationState.success?.status == ApiEndPoints.apiStatus_200) {
                                          if (isEdit == true) {
                                            ref.read(navigationStackController).pop();
                                          } else {
                                            if (Session.getAccountStatus() == AccountStatus.ACTIVE.name) {
                                              ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                                            } else {
                                              Session.userBox.clear();
                                              Session.saveLocalData(keyUserType, UserType.AGENCY);
                                              if(context.mounted){
                                                showCommonWebDialog(
                                                  keyBadge:
                                                      agencyRegistrationFormWatch
                                                          .waitingDialog,
                                                  context: context,
                                                  width: 0.5,
                                                  height: 0.45,
                                                  barrierDismissible: false,
                                                  dialogBody:
                                                      const WaitingDialog(),
                                                );
                                              }
                                              Future.delayed(const Duration(seconds: 3), () async {
                                                Navigator.pop(agencyRegistrationFormWatch.waitingDialog.currentContext!);
                                                ref.read(navigationStackController).pop();
                                                loginWatch.disposeController(isNotify: true);
                                              });
                                            }
                                          }
                                        }
                                      } else {
                                        if (isEdit == true) {
                                          ref.read(navigationStackController).pop();
                                        } else {
                                          if (Session.getAccountStatus() == AccountStatus.ACTIVE.name) {
                                            ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                                          } else {
                                            Session.userBox.clear();
                                            Session.saveLocalData(keyUserType, UserType.AGENCY);
                                            if(context.mounted){
                                              showCommonWebDialog(
                                                keyBadge:
                                                    agencyRegistrationFormWatch
                                                        .waitingDialog,
                                                context: context,
                                                width: 0.5,
                                                height: 0.45,
                                                barrierDismissible: false,
                                                dialogBody:
                                                    const WaitingDialog(),
                                              );
                                            }
                                            Future.delayed(const Duration(seconds: 3), () async {
                                              Navigator.pop(agencyRegistrationFormWatch.waitingDialog.currentContext!);
                                              ref.read(navigationStackController).pop();
                                              loginWatch.disposeController(isNotify: true);
                                            });
                                          }
                                        }
                                      }
                                    }
                                  }
                                  if (isEdit == true) {
                                    if(context.mounted){
                                      profileWatch.getProfileDetail(context);
                                    }
                                    if(context.mounted){
                                      await profileWatch
                                          .getAgencyDocumentsApi(context);
                                    }
                                    if(context.mounted){
                                      await agencyRegistrationFormWatch
                                          .getAgencyDetailApi(context);
                                    }
                                  }
                                }
                              },
                              onValidateTap: () {
                                ///Check Validation
                                agencyRegistrationFormWatch.checkImageValidation();
                                agencyRegistrationFormWatch.agencyRegistrationFormKey.currentState?.validate();
                              },
                              isLoading: agencyRegistrationFormWatch.uploadAgencyDocumentState.isLoading || agencyRegistrationFormWatch.agencyRegistrationState.isLoading || agencyRegistrationFormWatch.deleteAgencyDocumentState.isLoading,
                              height: 73.h,
                              buttonTextStyle: TextStyles.regular.copyWith(
                                fontSize: 18.sp,
                                color: agencyRegistrationFormWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                              ),
                              buttonEnabledColor: AppColors.black,
                              buttonDisabledColor: AppColors.buttonDisabledColor,
                              buttonText: LocaleKeys.keySubmit.localized,
                              rightIcon: Icon(
                                Icons.arrow_forward,
                                size: 30.h,
                                color: agencyRegistrationFormWatch.isAllFieldsValid ? AppColors.white : AppColors.clr7E7E7E,
                              ),
                              isButtonEnabled: agencyRegistrationFormWatch.isAllFieldsValid,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
