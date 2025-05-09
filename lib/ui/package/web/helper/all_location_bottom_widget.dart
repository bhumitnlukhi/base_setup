import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/all_locations_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/custom_date_picker.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AllLocationBottomWidget extends ConsumerWidget with BaseConsumerWidget {
  final Function()? onProceedTap;
  final bool? isForOwn;

  const AllLocationBottomWidget({Key? key, this.onProceedTap,this.isForOwn})
      : super(key: key);

  @override
  Widget buildPage(BuildContext context, ref) {
    final allLocationWatch = ref.watch(allLocationsController);
    final selectDestinationWatch = ref.watch(selectDestinationController);
    DestinationData? destinationData = selectDestinationWatch.selectedDestination;

    return FadeBoxTransition(
      child: Form(
        key: allLocationWatch.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Left date picker widget
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Select Date Issue
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          title: LocaleKeys.keySelectDate.localized,
                          textStyle: TextStyles.regular.copyWith(
                            fontSize: 22.sp,
                            color: AppColors.black171717,
                          ),
                        ).paddingOnly(bottom: context.height * 0.02),

                        /// Start date
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CommonInputFormField(
                                  textEditingController:allLocationWatch.startDateCtr ,
                                  hintText: LocaleKeys.keyStartDate.localized,
                                  readOnly: true,
                                  validator: (value){
                                    return validateText(value, LocaleKeys.keyStartRequiredValidation.localized,);
                                  },
                                  isEnable: true,
                                  enableInteractiveSelection: false,
                                  suffixWidget: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height*0.005),
                                    child: PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints.expand(
                                        width: context.width * 0.5,
                                        height: context.height * 0.5,
                                      ),
                                      enabled: true,
                                      tooltip: '',
                                      clipBehavior: Clip.hardEdge,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.r),
                                        ),
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: CustomDatePicker(
                                                selectDateOnTap: true,
                                                width: context.width * 0.5,
                                                height: context.height * 0.5,
                                                initialDate: allLocationWatch.startDate??getCurrentTimeZone(destinationData?.timeZone??''),
                                                firstDate: getCurrentTimeZone(destinationData?.timeZone??''),
                                                getDateCallback: (DateTime? selectedDate,
                                                    {bool? isOkPressed}) {
                                                  allLocationWatch.updateStartEndDate(true, selectedDate);
                                                },
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      child: CommonSVG(
                                        strIcon: Assets.svgs.svgCalendar.keyName,
                                        width: context.width*0.024,
                                        height: context.width*0.024,
                                        boxFit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  textInputType: TextInputType.datetime,
                                ).paddingOnly(right: context.width*0.015),
                              ),
                              /// End date
                              Expanded(
                                child: CommonInputFormField(
                                  textEditingController:allLocationWatch.endDateCtr ,
                                  hintText: LocaleKeys.keyEndDate.localized,
                                  readOnly: true,
                                  validator: (value){
                                    return validateText(value, LocaleKeys.keyEndDateRequiredValidation.localized,);
                                  },
                                  isEnable:allLocationWatch.startDate!=null?true:false,
                                  enableInteractiveSelection: false,
                                  suffixWidget: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: context.width * 0.005, vertical: context.height*0.005),
                                    child: PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints.expand(
                                        width: context.width * 0.5,
                                        height: context.height * 0.5,
                                      ),
                                      enabled: true,
                                      tooltip: '',
                                      clipBehavior: Clip.hardEdge,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25.r),
                                        ),
                                      ),
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: CustomDatePicker(
                                                selectDateOnTap: true,
                                                height: context.height * 0.5,
                                                width: context.width * 0.5,
                                                initialDate: allLocationWatch.endDate??allLocationWatch.startDate,
                                                firstDate: allLocationWatch.startDate,
                                                getDateCallback: (DateTime? selectedDate,
                                                    {bool? isOkPressed}) {
                                                  allLocationWatch.updateStartEndDate(false, selectedDate);
                                                },
                                              ),
                                            ),
                                          ),
                                        ];
                                      },
                                      child: CommonSVG(
                                        strIcon: Assets.svgs.svgCalendar.keyName,
                                        width: context.width*0.024,
                                        height: context.width*0.024,
                                        boxFit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  textInputType: TextInputType.datetime,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).paddingOnly(right: context.width*0.015),
                  ),
                  ///Price Widget
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// title
                        CommonText(
                          title: LocaleKeys.keySelectDesiredBudgetMsg.localized,
                          textStyle: TextStyles.regular
                              .copyWith(fontSize: 22.sp, color: AppColors.black171717),
                        ).paddingOnly(bottom: context.height * 0.02),

                        /// Amount
                        CommonInputFormField(
                          hintText: LocaleKeys.keyAmount.localized,
                          textInputAction: TextInputAction.done,
                          prefixText: '${Session.getCurrency()} ',
                          maxLength: amountMaxLength,
                          textInputType: TextInputType.number,
                          textEditingController: allLocationWatch.priceCtr,
                          validator: (value){
                            return validateAmount(value,  LocaleKeys.keyAmountRequiredValidation.localized,);
                          },
                          textInputFormatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            allLocationWatch.updateUI();
                            return validateAmount(value, LocaleKeys.keyAmountRequiredValidation.localized,);
                          },
                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
            const Expanded(
                flex: 1,
                child: SizedBox()),
            // const Spacer(),
            /// Right price widget
            Expanded(
              child: Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: context.width*0.15,
                    child: RichText(
                      text: TextSpan(
                        text: LocaleKeys.keyTotalPayble.localized,
                        style: TextStyles.regular.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.black171717.withOpacity(0.8),
                        ),
                        children: [
                          TextSpan(
                            text: ' ${Session.getCurrency()} ${allLocationWatch.priceCtr.text.toString()}',
                            style: TextStyles.semiBold.copyWith(
                              fontSize: 18.sp,
                              color: AppColors.black171717.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// payment button
                  CommonButton(
                    height: 49.h,
                    buttonTextStyle: TextStyles.regular.copyWith(
                      color: AppColors.white,
                      fontSize: 16.sp,
                    ),
                    isLoading: allLocationWatch.packageLimitState.isLoading,
                    buttonText: LocaleKeys.keyProceedToCheckout.localized,
                    isButtonEnabled: true,
                    onTap: (){
                      if(allLocationWatch.formKey.currentState?.validate()??false){
                        onProceedTap?.call();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
