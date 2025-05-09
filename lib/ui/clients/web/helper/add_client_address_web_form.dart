import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/clients/add_edit_clients_controller.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/countrt_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/state_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AddClientAddressWebForm extends ConsumerWidget with BaseConsumerWidget {
  final bool? isEdit;

  const AddClientAddressWebForm({super.key, this.isEdit});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final addEditClientsWatch = ref.watch(addEditClientsController);
    final clientWatch = ref.watch(clientsController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Address
        CommonText(
          title: LocaleKeys.keyAddress.localized,
          textStyle: TextStyles.regular.copyWith(fontSize: 22.sp, color: AppColors.black171717.withOpacity(0.5)),
        ),

        SizedBox(
          height: context.height * 0.02,
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///House Name
            Expanded(
                child: CommonInputFormField(
              textEditingController: addEditClientsWatch.houseNameController,
              hintText: LocaleKeys.keyHouseName.localized,
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
                return validateText(value, LocaleKeys.keyHouseNameRequired.localized);
              },
              onFieldSubmitted: (value) {
                context.nextField;
              },
              contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
              hintTextStyle: TextStyles.regular.copyWith(
                fontSize: 18.sp,
                color: AppColors.grey8D8C8C,
              ),
            )),

            SizedBox(
              width: context.width * 0.020,
            ),

            ///Street Name
            Expanded(
                child: CommonInputFormField(
              textEditingController: addEditClientsWatch.streetNameController,
              hintText: LocaleKeys.keyStreetName.localized,
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
                return validateText(value, LocaleKeys.keyStreetNameRequired.localized);
              },
              onFieldSubmitted: (value) {
                context.nextField;
              },
              contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029, horizontal: context.width * 0.01),
              hintTextStyle: TextStyles.regular.copyWith(
                fontSize: 18.sp,
                color: AppColors.grey8D8C8C,
              ),
            ))
          ],
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Address 1
        CommonInputFormField(
          textEditingController: addEditClientsWatch.address1Controller,
          hintText: LocaleKeys.keyAddressLine1.localized,
          textInputType: TextInputType.name,
          fieldTextStyle: TextStyles.regular.copyWith(
            fontSize: 18.sp,
            color: AppColors.black272727,
          ),
          onChanged: (value) {
            addEditClientsWatch.checkIfAllFieldsValid();
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
          hintTextStyle: TextStyles.regular.copyWith(
            fontSize: 18.sp,
            color: AppColors.grey8D8C8C,
          ),
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Address 2
        CommonInputFormField(
          textEditingController: addEditClientsWatch.address2Controller,
          hintText: LocaleKeys.keyAddressLine2.localized,
          textInputType: TextInputType.name,
          fieldTextStyle: TextStyles.regular.copyWith(
            fontSize: 18.sp,
            color: AppColors.black272727,
          ),
          textInputFormatter: [
            LengthLimitingTextInputFormatter(maxAddressContentLength),
          ],
          onChanged: (value) {
            addEditClientsWatch.checkIfAllFieldsValid();
          },
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateText(value, LocaleKeys.keyAddressLine2Required.localized);
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

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Country and State
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Country
            Expanded(
              child: CommonDropdownInputFormField<CountryData>(
                isEnabled: false,
                menuItems: clientWatch.countryList,
                items: (clientWatch.countryList)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text((item.name ?? ''), style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                      ),
                    )
                    .toList(),
                contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                defaultValue: addEditClientsWatch.selectedCountry,
                hintText: LocaleKeys.keyCountry.localized,
                onChanged: (value) {
                  addEditClientsWatch.updateCountry(value!);
                  clientWatch.stateListApi(context, countryId: addEditClientsWatch.selectedCountry?.uuid ?? '');
                },
                hintTextStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.grey8D8C8C,
                ),
                textStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.black272727,
                ),
                validator: (value) {
                  return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyCountryRequired.localized);
                },
              ),
            ),

            SizedBox(
              width: context.width * 0.020,
            ),

            ///State
            Expanded(
              child: CommonDropdownInputFormField<StateData>(
                menuItems: clientWatch.stateList,
                isEnabled: isEdit == true ? false : true,
                items: (clientWatch.stateList)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text((item.name ?? ''), style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                      ),
                    )
                    .toList(),
                contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                defaultValue: addEditClientsWatch.selectedState,
                hintText: LocaleKeys.keyState.localized,
                onChanged: (value) {
                  addEditClientsWatch.updateState(value!);
                  clientWatch.cityListApi(context, countryId: addEditClientsWatch.selectedCountry?.uuid ?? '', stateId: addEditClientsWatch.selectedState?.uuid ?? '');
                },
                hintTextStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.grey8D8C8C,
                ),
                textStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.black272727,
                ),
                validator: (value) {
                  return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyStateRequired.localized);
                },
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
              child: CommonDropdownInputFormField<CityData>(
                isEnabled: isEdit == true ? false : true,
                menuItems: clientWatch.cityList,
                items: (clientWatch.cityList)
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text((item.name ?? ''), style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                      ),
                    )
                    .toList(),
                contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.029),
                defaultValue: addEditClientsWatch.selectedCity,
                hintText: LocaleKeys.keyCity.localized,
                onChanged: (value) {
                  addEditClientsWatch.updateCity(value);
                },
                textStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.black272727,
                ),
                hintTextStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.grey8D8C8C,
                ),
                validator: (value) {
                  return validateTextIgnoreLength(value?.name ?? '', LocaleKeys.keyCityRequired.localized);
                },
              ),
            ),

            SizedBox(
              width: context.width * 0.020,
            ),

            ///Landmark
            Expanded(
              child: CommonInputFormField(
                textEditingController: addEditClientsWatch.landMarkController,
                hintText: LocaleKeys.keyLandMark.localized,
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
                  return validateText(value, LocaleKeys.keyLandMarkRequired.localized);
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
          ],
        ),
        SizedBox(
          height: context.height * 0.03,
        ),

        ///Postal code
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CommonInputFormField(
                textEditingController: addEditClientsWatch.postCodeController,
                hintText: LocaleKeys.keyPostCode.localized,
                textInputType: TextInputType.name,
                fieldTextStyle: TextStyles.regular.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.black272727,
                ),
                onChanged: (value) {
                  addEditClientsWatch.checkIfAllFieldsValid();
                },
                maxLength: postCodeLength,
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
            const Spacer()
          ],
        ),

        SizedBox(
          height: context.height * 0.04,
        ),
      ],
    );
  }
}
