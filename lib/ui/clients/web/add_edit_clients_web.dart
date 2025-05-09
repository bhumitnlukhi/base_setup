import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/clients/add_edit_clients_controller.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/business_category_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/countrt_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/state_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/clients/web/helper/add_client_address_web_form.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';

class AddEditClientsWeb extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String clientId;
  final int? index;

  const AddEditClientsWeb({Key? key, this.isEdit, this.index, required this.clientId}) : super(key: key);

  @override
  ConsumerState<AddEditClientsWeb> createState() => _AddEditClientsWebState();
}

class _AddEditClientsWebState extends ConsumerState<AddEditClientsWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final addEditClientsWatch = ref.watch(addEditClientsController);
      final clientWatch = ref.watch(clientsController);

      addEditClientsWatch.disposeController(isNotify: true);
      clientWatch.disposeController(isNotify: true);
      addEditClientsWatch.clearData();

      await clientWatch.businessCategoryListApi(context);
      if (mounted) {
        await clientWatch.countryListApi(context);
      }

      if (clientWatch.countryList.isNotEmpty) {
        int countryDataIndex = clientWatch.countryList.indexWhere((element) => element.uuid == Session.getAgencyCountryUuid());
        if (countryDataIndex != -1) {
          addEditClientsWatch.updateCountry(clientWatch.countryList[countryDataIndex]);

          if(mounted){
            await clientWatch.stateListApi(context,
                countryId: addEditClientsWatch.selectedCountry?.uuid);
          }
        }
      }
      if (widget.isEdit == true) {
        if (mounted) {
          await clientWatch.stateListApi(context);
          if (mounted) {
            await clientWatch.cityListApi(context);
          }
          if(mounted){
            await clientWatch.clientDetailsApi(context, widget.clientId).then(
              (value) {
                if (value.success?.status == ApiEndPoints.apiStatus_200) {
                  clientWatch.updateClientDetailState(true);

                  addEditClientsWatch.clientNameController.text =
                      value.success?.data?.name ?? '';
                  addEditClientsWatch.houseNameController.text =
                      value.success?.data?.houseNumber ?? '';
                  addEditClientsWatch.streetNameController.text =
                      value.success?.data?.streetName ?? '';
                  addEditClientsWatch.address1Controller.text =
                      value.success?.data?.addressLine1 ?? '';
                  addEditClientsWatch.address2Controller.text =
                      value.success?.data?.addressLine2 ?? '';
                  addEditClientsWatch.postCodeController.text =
                      value.success?.data?.postalCode ?? '';
                  addEditClientsWatch.landMarkController.text =
                      value.success?.data?.landmark ?? '';

                  addEditClientsWatch.checkIfAllFieldsValid();

                  ///category dropdown filler
                  BusinessCategoryData? businessData = clientWatch
                      .businessCategoryListState.success?.data
                      ?.firstWhereOrNull((element) =>
                          element.uuid ==
                          value.success?.data?.businessCategory?.uuid);
                  if (businessData != null) {
                    addEditClientsWatch.updateCategory(businessData);
                  }

                  ///country dropdown filler
                  CountryData? countryData = clientWatch
                      .countryListState.success?.data
                      ?.firstWhereOrNull((element) =>
                          element.uuid == value.success?.data?.countryUuid);
                  if (countryData != null) {
                    addEditClientsWatch.updateCountry(countryData);
                  }

                  ///state dropdown filler
                  StateData? stateData = clientWatch
                      .stateListState.success?.data
                      ?.firstWhereOrNull((element) =>
                          element.uuid == value.success?.data?.stateUuid);
                  if (stateData != null) {
                    addEditClientsWatch.updateState(stateData);
                  }

                  ///city dropdown filler
                  CityData? cityData = clientWatch.cityListState.success?.data
                      ?.firstWhereOrNull((element) =>
                          element.uuid == value.success?.data?.cityUuid);
                  if (cityData != null) {
                    addEditClientsWatch.updateCity(cityData);
                  }

                  clientWatch.updateClientDetailState(false);
                }
              },
            );
          }
        }
      }
      //addEditClientsWatch.disposeController(isNotify : true);
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
    final clientWatch = ref.watch(clientsController);
    return Stack(
      children: [
        _bodyWidget(),
        DialogProgressBar(isLoading: clientWatch.countryListState.isLoading || clientWatch.businessCategoryListState.isLoading || ( clientWatch.isEditing && widget.isEdit == true))
      ],
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final addEditClientsWatch = ref.watch(addEditClientsController);
    final selectClientWatch = ref.watch(selectClientController);
    final clientWatch = ref.watch(clientsController);
    return Form(
      key: addEditClientsWatch.formKey,
      child: FadeBoxTransition(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonBackTopWidget(
              title: widget.isEdit ?? false ? LocaleKeys.keyEditClient.localized : LocaleKeys.keyCreateClient.localized,
              onTap: () {
                ref.read(navigationStackController).pop();
              },
            ).paddingOnly(bottom: context.height * 0.034),
            SizedBox(height: context.height * 0.030),
           /* clientWatch.isEditing && widget.isEdit == true
                ? const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                    color: AppColors.black,
                  )))
                : */Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              title: LocaleKeys.keyClientDetails.localized,
                              textStyle: TextStyles.regular.copyWith(fontSize: 22.sp, color: AppColors.black171717.withOpacity(0.5)),
                            ),

                            SizedBox(
                              height: context.height * 0.02,
                            ),

                            ///client name, category
                            FadeBoxTransition(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///client name
                                  Expanded(
                                    child: CommonInputFormField(
                                      textEditingController: addEditClientsWatch.clientNameController,
                                      hintText: LocaleKeys.keyClientName.localized,
                                      textInputType: TextInputType.name,
                                      fieldTextStyle: TextStyles.regular.copyWith(
                                        fontSize: 18.sp,
                                        color: AppColors.black272727,
                                      ),
                                      onChanged: (value) {
                                        addEditClientsWatch.checkIfAllFieldsValid();
                                      },
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        return validateText(value, LocaleKeys.keyClientNameRequired.localized);
                                      },
                                      onFieldSubmitted: (value) {
                                        context.nextField;
                                      },
                                      contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
                                      hintTextStyle: TextStyles.regular.copyWith(
                                        fontSize: 18.sp,
                                        color: AppColors.grey8D8C8C,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: context.width * 0.020,
                                  ),

                                  ///category dropdown
                                  Expanded(
                                    child: IgnorePointer(
                                      ignoring: (widget.isEdit == true),
                                      child: CommonDropdownInputFormField<BusinessCategoryData>(
                                        menuItems: clientWatch.categoryList,
                                        items: (clientWatch.categoryList)
                                            .map(
                                              (item) => DropdownMenuItem(
                                                value: item,
                                                child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                              ),
                                            )
                                            .toList(),
                                        contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                                        defaultValue: addEditClientsWatch.selectedCategory,
                                        hintText: LocaleKeys.keyCategory.localized,
                                        onChanged: (value) {
                                          addEditClientsWatch.updateCategory(value!);
                                        },
                                        validator: (value) {
                                          return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyCategoryRequired.localized);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: context.height * 0.03,
                            ),

                            FadeBoxTransition(
                                child: AddClientAddressWebForm(
                              isEdit: widget.isEdit,
                            )),

                            SizedBox(
                              height: context.height * 0.04,
                            ),

                            /// save button
                            CommonButton(
                              isButtonEnabled: true,
                              isLoading: addEditClientsWatch.clientAddState.isLoading,
                              buttonText: LocaleKeys.keySave.localized,
                              buttonEnabledColor: AppColors.blue009AF1,
                              width: context.width * 0.090,
                              height: context.height * 0.055,
                              buttonTextSize: 14.sp,
                              onTap: () {
                                final bool? result = addEditClientsWatch.formKey.currentState?.validate();
                                if (result == true) {
                                  if (widget.isEdit == true) {
                                    addEditClientsWatch.addClientApi(context, isEdit: true, clientId: widget.clientId, ref: ref, index: widget.index).then(
                                      (value) async {
                                        if (value.success?.status == ApiEndPoints.apiStatus_200) {
                                          await selectClientWatch.clientListApi(context, true);
                                          ref.read(navigationStackController).pop();
                                        }
                                      },
                                    );
                                  } else {
                                    addEditClientsWatch.addClientApi(context, isEdit: false).then(
                                      (value) async {
                                        if (value.success?.status == ApiEndPoints.apiStatus_200) {
                                          await selectClientWatch.clientListApi(context, true);
                                          ref.read(navigationStackController).pop();
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                            ).alignAtBottomRight().paddingOnly(bottom: context.height * 0.030)
                          ],
                        ),
                      ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
                    ),
                  ),
          ],
        ).paddingAll(context.height * 0.025),
      ),
    );
  }
}
