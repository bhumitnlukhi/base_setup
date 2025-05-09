import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_reason_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/ticket_detail_dialog_widget.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CreateTicketStatusFormWidget extends ConsumerWidget with BaseConsumerWidget {
  final int index;
  final BuildContext mainClassCntx;
  final String? ticketStatus;
  final Function onDialogPopCall;
  const CreateTicketStatusFormWidget({Key? key, required this.mainClassCntx,required this.index, this.ticketStatus, required this.onDialogPopCall}) : super(key: key);

  @override
  Widget buildPage(BuildContext context, ref) {
    final ticketManagementWatch = ref.watch(ticketManagementController);
    return  Form(
      key:ticketManagementWatch.formKey,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ///Reason Selection Dropdown
              CommonDropdownInputFormField<ReasonData>(
                defaultValue: ticketManagementWatch.selectedReason,
                menuItems:ticketManagementWatch.ticketReasonListState.success?.data,
                items: (ticketManagementWatch.ticketReasonListState.success?.data)?.map(
                      (item) => DropdownMenuItem<ReasonData>(
                    value: item,
                    child: Text((item.reason ?? '').capsFirstLetterOfSentence, style: TextStyles.medium.copyWith(color: AppColors.black,fontSize: 18.sp)),
                  ),
                )
                    .toList(),
                hintText: LocaleKeys.keyReason.localized,
                validator: (ReasonData? value){
                  if(value == null){
                    return LocaleKeys.keyTicketReasonRequired.localized;
                  }else{
                    return null;
                  }
                },
                onChanged: (value){
                  ticketManagementWatch.updateSelectedTicketReasonStatus(value);
                  ticketManagementWatch.validateUpdateFormForCreateTicket(index,message: ticketManagementWatch.ctrMessage.text);
                  // ticketManagementWatch.ctrMessage.clear();
                },),

              SizedBox(height: 30.h,),

              /// Comment Field
              CommonInputFormField(
                  textEditingController: ticketManagementWatch.ctrMessage,
                  isEnable:true,
                  validator: (value){
                    return validateText(value, LocaleKeys.keyMessageMustBeRequired.localized);
                  },
                  onChanged: (value){
                    ticketManagementWatch.validateUpdateFormForCreateTicket(index,message: value);
                  },
                  textInputType: TextInputType.multiline,
                  labelText:LocaleKeys.keyMessage.localized,
                  hintText:LocaleKeys.keyMessage.localized,
                  hintTextStyle: TextStyles.regular.copyWith(color: AppColors.clr8D8D8D,fontSize: 14.sp),
                  maxLines: 5,
                  textInputFormatter: [LengthLimitingTextInputFormatter(200),],
                  textInputAction: TextInputAction.newline).paddingOnly(bottom: 20.h),

              /// Add Button
              CommonButton(
                  buttonText: LocaleKeys.keySubmit.localized,
                  height: context.height * 0.060,
                  width: context.width * 0.090,
                  buttonTextSize: 12.sp,
                  isButtonEnabled: ticketManagementWatch.isALLFieldsValidForCreateTicket && ticketManagementWatch.ctrMessage.text.isNotEmpty,
                  isLoading: ticketManagementWatch.addTicketState.isLoading,
                  onTap: () async {
                    if(ticketManagementWatch.formKey.currentState?.validate() ??false) {

                      ticketManagementWatch.createTicketApi(context).then((value){
                        if(ticketManagementWatch.addTicketState.success?.status == ApiEndPoints.apiStatus_200){
                          ticketManagementWatch.ticketListApi(context, false);
                          if(ticketManagementWatch.dailog1Key.currentContext != null){
                            Navigator.of(ticketManagementWatch.dailog1Key.currentContext!).pop();
                            // onDialogPopCall.call();
                            showCommonWebDialog(
                                context: context,
                                keyBadge: ticketManagementWatch.dailog2Key,
                                width: 0.300,
                                // height: maincontext.height * 0.650,
                                dialogBody:const SuccessTicketDialog()

                            );
                          }
                        }
                      });
                    }
                  }
              )
            ],
          ),
          // DialogProgressBar(isLoading: ticketManagementWatch.ticketReasonListState.isLoading)
        ],
      ),
    );
  }
}

class SuccessTicketDialog extends StatelessWidget with BaseStatelessWidget{
  const SuccessTicketDialog({super.key});

  @override
  Widget buildPage(BuildContext context) {

    return Consumer(
      builder: (ctx,ref,_) {
        final ticketManagementWatch = ref.watch(ticketManagementController);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: context.height * 0.030,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(ticketManagementWatch.dailog2Key.currentContext!).pop();
                    },
                    child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName).paddingOnly(right: context.width * 0.020))
              ],
            ),
            Lottie.asset(
              Assets.anim.animCreateTicketSuccess.keyName,
              height: context.height * 0.300,
              width: context.width * 0.200,
            ),
            CommonText(title: LocaleKeys.keyTicketSuccessfullySend.localized, textStyle: TextStyles.medium),
            SizedBox(height: context.height * 0.010),
            CommonText(title: LocaleKeys.keyTicketSuccessMessage.localized, textStyle: TextStyles.regular, maxLines: 2,),
            SizedBox(height: context.height * 0.030),
            CommonButton(
              buttonText: LocaleKeys.keyShowDetails.localized,
              buttonTextSize: 12.sp,
              isLoading: ticketManagementWatch.ticketDetailState.isLoading,
              height: context.height * 0.050,
              width: context.width * 0.100,
              onTap: () async {
              await ticketManagementWatch.ticketDetailApi(context, ticketUuid: ticketManagementWatch.addTicketState.success?.data?.uuid??'').then((value) {
                if(value.success?.status == ApiEndPoints.apiStatus_200){
                  if(ticketManagementWatch.dailog2Key.currentContext != null){
                    Navigator.of(ticketManagementWatch.dailog2Key.currentContext!).pop();
                    /// Ticket Details Widget
                    showCommonWebDialog(
                      // height: context.height * 0.850,
                        height: 0.85,
                        width:0.7,
                        context: context,
                        keyBadge: ticketManagementWatch.ticketDetailDialogKey,
                        dialogBody: const TicketDetailDialog()
                    );
                  }
                }
              },);


              },
              isButtonEnabled: true,
              buttonTextColor: AppColors.white,
              backgroundColor: AppColors.contentColorBlue,
            ),
            SizedBox(height: context.height * 0.030,),
          ],
        );
      }
    );
  }
}
