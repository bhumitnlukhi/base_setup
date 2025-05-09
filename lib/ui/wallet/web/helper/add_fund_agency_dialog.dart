import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_radio_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/slide_left_transition.dart';

class AddFundAgency extends ConsumerWidget with BaseConsumerWidget {
  final GlobalKey<FormState> formKey;

  const   AddFundAgency({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget buildPage(BuildContext context, ref) {
    final walletWatch = ref.watch(walletController);
    // final selectClientWatch = ref.watch(selectClientController);

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText(
                title: LocaleKeys.keyAddFund.localized,
                textStyle: TextStyles.medium.copyWith(fontSize: 22.sp),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CommonSVG(
                  strIcon: Assets.svgs.svgClose.keyName,
                ).paddingOnly(bottom: context.height * 0.03),
              ),
            ],
          ),
          // CommonText(
          //   title: LocaleKeys.keyAdsFor.localized,
          //   textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.clr707070),
          // ).paddingOnly(bottom: context.height * 0.025),

          SizedBox(
            height: 50.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return SlideLeftTransition(
                        delay: 100,
                        child: Column(
                          children: [
                            /// Change package creation for  Radio Buttons
                            CommonRadioButton(
                              value: walletWatch.agencyPurchasePackageDialogList[index].localized,
                              groupValue: walletWatch.addFundFor.localized,
                              onTap: () {
                                walletWatch.changeSelectedAgencyPurchasePackageFor(walletWatch.agencyPurchasePackageDialogList[index]);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => SizedBox(
                          width: context.width * 0.03,
                        ),
                    itemCount: walletWatch.agencyPurchasePackageDialogList.length)
              ],
            ),
          ),

          Visibility(
            visible: walletWatch.addFundFor != LocaleKeys.keyForYourself,
            child: CommonDropdownInputFormField<ClientData>(
              // menuItems: destinationWatch.destination,
              menuItems: walletWatch.clientListForDropDown,
              items: (walletWatch.clientListForDropDown)
                  .map(
                    (item) => DropdownMenuItem<ClientData>(
                      value: item,
                      child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 18.sp)),
                    ),
                  )
                  .toList(),
              // height: context.height * 0.049,
              contentPadding: EdgeInsets.symmetric(vertical: context.height * 0.023),
              defaultValue: walletWatch.selectedClient,
              hintText: LocaleKeys.keyClient.localized,
              onChanged: (ClientData? value) {
                walletWatch.updateSelectedClient(value);
              },
              validator: (value) {
                return validateTextIgnoreLength(value?.name.toString(), LocaleKeys.keyClientName.localized);
              },
            ).paddingOnly(bottom: context.height * 0.02),
          ),

          ///amount Field
          CommonInputFormField(
            textEditingController: walletWatch.amountController,
            hintText: LocaleKeys.keyAmount.localized,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {},
            onChanged: (value) {
              walletWatch.checkFieldValid();
            },
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxWalletAmount),
            ],
            maxLength: maxWalletAmount,
            prefixWidget: CommonText(
              title: Session.getCurrency(),
              textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
            ).paddingSymmetric(vertical: 18.h, horizontal: 12.w),
            validator: (value) {
              return validatePrice(value, LocaleKeys.keyAmountIsRequired.localized);
            },
          ).paddingOnly(bottom: context.height * 0.02),

          SizedBox(
            height: context.height * 0.020,
          ),
          CommonButton(
            isLoading: walletWatch.addWalletAmountState.isLoading,
            isButtonEnabled: walletWatch.addFundFor == LocaleKeys.keyForYourself ? walletWatch.isAllFieldValid : (walletWatch.isAllFieldValid && walletWatch.selectedClient != null),
            buttonText: LocaleKeys.keyPayNow.localized,
            onTap: () async {
              bool? isValidate = formKey.currentState?.validate();
              showLog('isValidate isValidate $isValidate ${walletWatch.amountController.text.isNotEmpty}');
              if (isValidate != null && isValidate) {
                if (walletWatch.amountController.text.isNotEmpty) {
                  await walletWatch.addWalletAmountApi(context, clientMasterUuid: walletWatch.addFundFor == LocaleKeys.keyForYourself ? null : walletWatch.selectedClient?.uuid ?? '').then((value) async {
                    if (walletWatch.addWalletAmountState.success?.status == ApiEndPoints.apiStatus_200) {
                      // Navigator.pop(context);
                      // walletWatch.vendorDetailApi(context);
                      //  walletWatch.transactionHistoryListApi(context, false);
                      // selectClientWatch.clientListApi(context, false).then((value){
                      //   walletWatch.updateClientList(selectClientWatch.clientList);
                      // });
                      openUrlInExistingTab(walletWatch.addWalletAmountState.success?.data);
                    }
                  });
                }
              }
            },
            buttonTextSize: 14.sp,
            width: context.width * 0.08,
            height: context.height * 0.06,
          ),
        ],
      ),
    );
  }
}
