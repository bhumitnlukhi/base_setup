import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/signup_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/vendor_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/add_edit_store_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/auth/web/helper/store_destinations_table_widget.dart';
import 'package:odigo_vendor/ui/auth/web/helper/vendor_signup_image_selection_widget.dart';
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
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class VendorRegistrationFormWeb extends ConsumerStatefulWidget {
  const VendorRegistrationFormWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<VendorRegistrationFormWeb> createState() => _VendorRegistrationFormWebState();
}

class _VendorRegistrationFormWebState extends ConsumerState<VendorRegistrationFormWeb> with BaseConsumerStatefulWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
      vendorRegistrationFormWatch.disposeController(isNotify: true);
      await vendorRegistrationFormWatch.destinationListApi(context,isFromSignUp: true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
    final addEditStoreWatch = ref.watch(addEditStoreController);
    final loginWatch = ref.watch(loginController);
    final signUpWatch = ref.watch(signUpController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Back Button
        InkWell(
          child: CommonSVG(strIcon: Assets.svgs.svgBackRounded.keyName, height: context.height * 0.077, width: context.width * 0.077),
          onTap: () {
            ///For Clear Token
            Session.userBox.clear();
            Session.saveLocalData(keyUserType, UserType.VENDOR);
            ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.startJourney());
            ref.read(navigationStackController).push(const NavigationStackItem.login());
            signUpWatch.disposeController(isNotify: true);
            loginWatch.disposeController(isNotify: true);
          },
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Registration Form Title
        CommonText(
          title: LocaleKeys.keyRegistrationForm.localized,
          textStyle: TextStyles.semiBold.copyWith(fontSize: 26.sp, color: AppColors.black),
        ),

        SizedBox(
          height: context.height * 0.01,
        ),

        ///Fill Up The Registration Form To Create The Account Title
        CommonText(
          title: LocaleKeys.keyFillUpTheRegistrationFormToCreateTheAccount.localized,
          textStyle: TextStyles.regular.copyWith(fontSize: 21.sp, color: AppColors.black),
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        Expanded(
          child: vendorRegistrationFormWatch.destinationState.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.black))
              : SingleChildScrollView(
                  child: FadeBoxTransition(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Upload Documents Required
                        CommonText(
                          title: LocaleKeys.keyUploadDocumentsRequired.localized,
                          textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.clr8D8D8D),
                        ),
                    
                        SizedBox(
                          height: context.height * 0.02,
                        ),
                    
                        ///Image Selection Widget
                        const VendorSignUpImageSelectionWidget(),
                    
                        ///Image Validation
                        vendorRegistrationFormWatch.isImageValidate?CommonText(
                          title: LocaleKeys.keyImageValidation.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.errorColor, fontSize: 16.sp),
                        ).paddingOnly(top: context.height * 0.02):const Offstage(),
                    
                        SizedBox(
                          height: context.height * 0.04,
                        ),
                    
                        ///Store and Destinations Row
                        FadeBoxTransition(
                          child: Form(
                            key: vendorRegistrationFormWatch.storeAndDestinationFormKey,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Destinations
                                      Expanded(
                                        child: CommonDropdownInputFormField<DestinationData>(
                                          menuItems: vendorRegistrationFormWatch.destinationState.success?.data,
                                          items: (vendorRegistrationFormWatch.destinationState.success?.data)
                                              ?.map(
                                                (item) => DropdownMenuItem<DestinationData>(
                                                  value: item,
                                                  child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                                ),
                                              )
                                              .toList(), // height: context.height * 0.049,
                                          contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                                          defaultValue: vendorRegistrationFormWatch.selectedDestination,
                                          hintText: LocaleKeys.keySelectDestination.localized,
                                          onChanged: (value) async {
                                            vendorRegistrationFormWatch.updateDestinations(value);
                                            addEditStoreWatch.storeListApi(context, pageSize: pageSize100000, destinationUuid: vendorRegistrationFormWatch.selectedDestination?.uuid??'');
                                            // await vendorRegistrationFormWatch.storeListApi(context, destinationUuid: vendorRegistrationFormWatch.selectedDestination?.uuid??'');
                                          },
                                          validator: (value) {
                                            return validateTextIgnoreLength(value?.name, LocaleKeys.keyDestinationsValidations.localized);
                                          },
                                        ).paddingOnly(right: context.width * 0.020),
                                      ),
                          
                                      ///Stores
                                      Expanded(
                                        child: IgnorePointer(
                                          ignoring: addEditStoreWatch.storeListState.isLoading,
                                          child: CommonDropdownInputFormField<StoreListData>(
                                            menuItems: addEditStoreWatch.storeListState.success?.data,
                                            items: (addEditStoreWatch.storeListState.success?.data)
                                                ?.map(
                                                  (item) => DropdownMenuItem<StoreListData>(
                                                    value: item,
                                                    child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                                  ),
                                                )
                                                .toList(), // height: context.height * 0.049,
                                            contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                                            defaultValue: vendorRegistrationFormWatch.selectedStore,
                                            hintText: LocaleKeys.keySelectStore.localized,
                                            onChanged: (value) {
                                              vendorRegistrationFormWatch.updateStore(value);
                                            },
                                            validator: (value) {
                                              return validateTextIgnoreLength(value?.name, LocaleKeys.keyStoresValidations.localized);
                                            },
                                          ).paddingOnly(right: context.width * 0.020),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          
                                ///Add Button
                                CommonButton(
                                  buttonText: LocaleKeys.keyAdd.localized,
                                  isButtonEnabled: true,
                                  height: context.height*0.07,
                                  width: context.width*0.095,
                                  buttonEnabledColor: AppColors.blue,
                                  buttonTextSize: 18.sp,
                                  onTap: () {
                                    if (vendorRegistrationFormWatch.storeAndDestinationFormKey.currentState?.validate() == true) {
                                      vendorRegistrationFormWatch.addDestinationAndStoreValue(vendorRegistrationFormWatch.selectedDestination, vendorRegistrationFormWatch.selectedStore, context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        ///Destination Validation
                        vendorRegistrationFormWatch.isStoreAndDestinationValidate?CommonText(
                          title: LocaleKeys.keyStoreValidation.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.errorColor, fontSize: 16.sp),
                        ).paddingOnly(top: context.height * 0.02):const Offstage(),

                        SizedBox(
                          height: context.height * 0.04,
                        ),

                        ///Table
                        vendorRegistrationFormWatch.destinationStoreList.isEmpty ? const Offstage() : const StoreDestinationsTableWidget(),

                        vendorRegistrationFormWatch.destinationStoreList.isEmpty
                            ? const Offstage()
                            : SizedBox(
                                height: context.height * 0.04,
                              ),

                        ///Sign Up
                        CommonButton(
                          onTap: () async {
                            ///Check Validation
                            vendorRegistrationFormWatch.checkImageValidation();
                            vendorRegistrationFormWatch.checkStoreAndDestinationValidation();

                            if(vendorRegistrationFormWatch.isStoreAndDestinationValidate==false && vendorRegistrationFormWatch.isImageValidate==false){
                              ///Upload Document Api
                              await vendorRegistrationFormWatch.uploadVendorDocumentApi(context, uuid:Session.getUuid().toString()/*otpVerificationWatch.verifyOtpForSignUpState.success?.data?.uuid ?? ''*/);
                              if (vendorRegistrationFormWatch.uploadVendorDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
                                ///Upload Store Api
                                await vendorRegistrationFormWatch.uploadOdigoStoreApi(context, vendorUuid: Session.getUuid().toString()/*otpVerificationWatch.verifyOtpForSignUpState.success?.data?.uuid ?? ''*/);
                                if (vendorRegistrationFormWatch.uploadOdigoState.success?.status == ApiEndPoints.apiStatus_200) {
                                  if(Session.getAccountStatus()==AccountStatus.ACTIVE.name){
                                    ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                                  }
                                  else{
                                    Session.userBox.clear();
                                    Session.saveLocalData(keyUserType, UserType.VENDOR);
                                      showCommonWebDialog(
                                        keyBadge: vendorRegistrationFormWatch.waitingDialog,
                                        context: context,
                                        width: 0.5,
                                        height: 0.45,
                                        barrierDismissible: false,
                                        dialogBody:
                                        const WaitingDialog(),
                                      );
                                    Future.delayed(const Duration(seconds: 3),()async{
                                      Navigator.pop(vendorRegistrationFormWatch.waitingDialog.currentContext!);
                                      Session.saveLocalData(keyUserType, UserType.VENDOR.name);
                                      Session.saveLocalData(keyIsSignUpPending,false);
                                      Session.saveLocalData(keyIsRegistrationPending,false);
                                      ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.login());
                                      loginWatch.disposeController(isNotify: true);
                                    });
                                  }
                                }
                              }
                            }

                          },
                          onValidateTap: () {
                            //resetPasswordWatch.formKey.currentState?.validate();
                          },
                          isLoading: vendorRegistrationFormWatch.uploadVendorDocumentState.isLoading || vendorRegistrationFormWatch.uploadOdigoState.isLoading,
                          height: context.height*0.07,
                          width: context.width*0.150,
                          buttonTextStyle: TextStyles.regular.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.white,
                          ),
                          buttonEnabledColor: AppColors.black,
                          buttonDisabledColor: AppColors.buttonDisabledColor,
                          buttonText: LocaleKeys.keySignup.localized,
                          rightIcon: Icon(
                            Icons.arrow_forward,
                            size: 30.h,
                            color: AppColors.white,
                          ),
                          isButtonEnabled: true,
                        ),
                      ],
                    ),
                  ),
                ),
        )
      ],
    ).paddingSymmetric(horizontal: context.width * 0.05, vertical: context.height * 0.05);
  }
}
