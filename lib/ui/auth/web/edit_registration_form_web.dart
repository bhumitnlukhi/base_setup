import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/edit_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/auth/web/helper/edit_vendor_image_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';

class EditRegistrationFormWeb extends ConsumerStatefulWidget {
  const EditRegistrationFormWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<EditRegistrationFormWeb> createState() => _EditRegistrationFormWebState();
}

class _EditRegistrationFormWebState extends ConsumerState<EditRegistrationFormWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    final profileWatch = ref.read(profileController);
    final editRegistrationFormWatch = ref.read(editRegistrationFormController);
    profileWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await profileWatch.getProfileDetail(context);
      editRegistrationFormWatch.setNameValue(profileWatch.profileDetailState.success?.data?.name);
      editRegistrationFormWatch.disposeController();
      if(mounted){
        await profileWatch.getVendorDocumentsApi(context);
      }
      await editRegistrationFormWatch.addCloudImage(ref);
    });
    super.initState();
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final editRegistrationFormWatch = ref.watch(editRegistrationFormController);
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: context.height * 0.03,
        ),
        ///Top Widget
        CommonTitleBackWidget(
          title: LocaleKeys.keyEditProfile.localized,
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Owners Name
        profileWatch.getVendorDocumentsState.isLoading || profileWatch.profileDetailState.isLoading
            ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.black,
                  ),
                ),
              )
            : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: editRegistrationFormWatch.formKey,
                      child: CommonInputFormField(
                        textEditingController: editRegistrationFormWatch.ownerNameController,
                        hintText: LocaleKeys.keyOwnersName.localized,
                        textInputType: TextInputType.name,
                        onChanged: (value) {
                          editRegistrationFormWatch.checkIfAllFieldsValid();
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
                    ),

                    SizedBox(
                      height: context.height * 0.03,
                    ),

                    const EditVendorImageWidget(),

                    ///Image Validation
                    editRegistrationFormWatch.isImageValidate?CommonText(
                      title: LocaleKeys.keyImageValidation.localized,
                      textStyle: TextStyles.regular.copyWith(color: AppColors.errorColor, fontSize: 16.sp),
                    ).paddingOnly(top: context.height * 0.02):const Offstage(),

                    const Spacer(),

                    ///Save Button
                    CommonButton(
                      onTap: () async {
                        editRegistrationFormWatch.checkImageValidation();
                        if(editRegistrationFormWatch.isImageValidate==false && profileWatch.isLoading == false){
                          await _saveButtonApi();
                        }
                      },
                      width: context.width * 0.1,
                      height: context.height * 0.080,
                      isLoading: editRegistrationFormWatch.updateVendorState.isLoading  || editRegistrationFormWatch.uploadVendorDocumentState.isLoading,
                      buttonText: LocaleKeys.keySave.localized,
                      buttonTextStyle: TextStyles.regular.copyWith(
                        color: editRegistrationFormWatch.isAllFieldsValid ? AppColors.white : AppColors.black171717,
                      ),
                      buttonEnabledColor: AppColors.black,
                      isButtonEnabled: editRegistrationFormWatch.isAllFieldsValid,
                    ),
                  ],
                ),
              ),
      ],
    ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.035);
  }

  _saveButtonApi() async{
    final editRegistrationFormWatch = ref.watch(editRegistrationFormController);
    // final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
    final profileWatch = ref.watch(profileController);
    profileWatch.updateLoading(true);
    if(editRegistrationFormWatch.documentListForRemove?.isNotEmpty==true){
      await editRegistrationFormWatch.deleteVendorDocumentApi(context);
    }
    if(mounted){
      await editRegistrationFormWatch.uploadVendorDocumentApi(context,
          uuid: Session.getUuid().toString());
    }
    if (editRegistrationFormWatch.uploadVendorDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
      if(mounted){
        await editRegistrationFormWatch.updateVendorApi(context);
      }
      if (editRegistrationFormWatch.updateVendorState.success?.status == ApiEndPoints.apiStatus_200) {
        ref.read(navigationStackController).pop();
        if(mounted){
          profileWatch.getProfileDetail(context);
        }
        if(mounted){
          await profileWatch.getVendorDocumentsApi(context);
        }
      }
    }
    profileWatch.updateLoading(false);

  }
}
