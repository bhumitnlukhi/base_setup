import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
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
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AddFundDialog extends StatelessWidget with BaseStatelessWidget {
  final GlobalKey<FormState> formKey;

  AddFundDialog({super.key, required this.formKey});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final walletWatch = ref.watch(walletController);
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Top Widget
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Add Fund
                  CommonText(
                    title: LocaleKeys.keyAddFund.localized,
                    textStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 22.sp),
                  ),

                  ///Cross Button
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CommonSVG(
                      strIcon: Assets.svgs.svgCrossRounded.keyName,
                      height: context.height * 0.06,
                      width: context.width * 0.06,
                    ),
                  )
                ],
              ),

              const Spacer(),

              ///Amount Field
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
              ),

              const Spacer(
                flex: 2,
              ),

              ///Save Button
              CommonButton(
                onTap: () async {
                  bool? isValidate = formKey.currentState?.validate();

                  if (isValidate != null && isValidate) {
                    await walletWatch.addWalletAmountApi(context, clientMasterUuid: null).then((value) async {
                      if (walletWatch.addWalletAmountState.success?.status == ApiEndPoints.apiStatus_200) {
                        openUrlInExistingTab(walletWatch.addWalletAmountState.success?.data);
                        // Navigator.pop(context);
                        // ref.read(navigationStackController).push(const NavigationStackItem.paymentCancel());
                        // walletWatch.disposeController(isNotify: true);
                        // await walletWatch.vendorDetailApi(context);
                        // await walletWatch.transactionHistoryListApi(context, false);
                      }
                    });
                  }
                },
                isLoading: walletWatch.addWalletAmountState.isLoading,
                width: context.width * 0.1,
                height: context.height * 0.070,
                buttonText: LocaleKeys.keyPayNow.localized,
                buttonTextStyle: TextStyles.regular.copyWith(
                  color: walletWatch.isAllFieldValid ? AppColors.white : AppColors.black,
                ),
                isButtonEnabled: walletWatch.isAllFieldValid,
              ),
            ],
          ),
        );
      },
    );
  }
}
