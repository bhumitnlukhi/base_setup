import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/create_ticket_form_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/custom_date_picker.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_searchbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';

class TicketManagementTopRowWidget extends ConsumerWidget with BaseConsumerWidget {
  final BuildContext mainClassCntx;
  const TicketManagementTopRowWidget(this.mainClassCntx, {required this.link, super.key});

  final LayerLink link;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Consumer(
        builder: (maincontext, ref, widget) {
          final ticketManagementWatch = ref.watch(ticketManagementController);
          return Column(
            children: [
              /// Top Text And Export button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    title: LocaleKeys.keyTicketManagement.localized,
                    fontSize: 20.sp,
                    clrfont: AppColors.black,
                  ),
                  Row(
                    children: [
                      /// Search
                      CommonSearchBar(
                        controller: ticketManagementWatch.ctrSearch,
                        width: context.width*0.219,
                        height: context.height*0.057,
                        cursorColor: AppColors.black,
                        borderColor: AppColors.blackD0D5DD,
                        clrSearchIcon: AppColors.clr687083,
                        leftIcon: Assets.svgs.svgSearch.keyName,
                        textColor: AppColors.black,
                        rightIcon:Assets.svgs.svgClearSearch.keyName,
                        placeholder: LocaleKeys.keySearchName.localized,
                        onClearSearch: (){
                          ticketManagementWatch.clearSearchController();
                          ticketManagementWatch.ticketListApi(context, false);
                          ticketManagementWatch.ticketListScrollController.addListener(() async{
                            if (ticketManagementWatch.ticketListState.success?.hasNextPage == true) {
                              if (ticketManagementWatch.ticketListScrollController.position.maxScrollExtent == ticketManagementWatch.ticketListScrollController.position.pixels) {
                                if(!ticketManagementWatch.ticketListState.isLoadMore) {
                                  await ticketManagementWatch.ticketListApi(context,true,);
                                }
                              }
                            }
                          });
                        },
                        onChanged: (value){
                          ticketManagementWatch.onSearchChanged(context);

                        },
                      ).paddingOnly(right: context.width*0.008),

                      /// calender Filter Widget
                      PopupMenuButton<SampleItem>(
                        tooltip: '',
                        surfaceTintColor: AppColors.transparent,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints.expand(
                          width: context.width * 0.4,
                          height: context.height * 0.22,
                        ),
                        clipBehavior: Clip.hardEdge,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                        ),
                        color: AppColors.white,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                          PopupMenuItem<SampleItem>(
                            padding: EdgeInsets.zero,
                            value: SampleItem.itemOne,
                            mouseCursor: MouseCursor.defer,
                            child: Consumer(
                                builder: (context,ref,child) {
                                  final ticketManagementWatch = ref.watch(ticketManagementController);
                                  return Container(
                                    color: AppColors.white,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CommonText(
                                              title: LocaleKeys.keySelectCustomDate.localized,
                                              textStyle: TextStyles.medium.copyWith(
                                                color: AppColors.black,
                                                fontSize: 17.sp,
                                              ),
                                            ).paddingOnly(bottom: context.height*0.025),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            /// Start Date
                                            Expanded(
                                              child: Consumer(builder: (context, ref, child) {
                                                return Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        /// Start Date Calender Picker
                                                        showCommonWebDialog(context: context,
                                                            keyBadge: ticketManagementWatch.startDateSelectionDialogKey,
                                                            dialogBody: CustomDatePicker(
                                                          selectDateOnTap: true,
                                                          bubbleDirection: true,
                                                          bubbleColor: AppColors.white,
                                                          initialDate: ticketManagementWatch.startDate,
                                                          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 365),
                                                          lastDate: DateTime.now(),
                                                          getDateCallback: (DateTime? selectedDate, {bool? isOkPressed}) {
                                                            ticketManagementWatch.updateStartEndDate(true, selectedDate);
                                                            // = DateFormat('dd/MM/yyyy').format(selectedDate ?? DateTime.now());
                                                          },
                                                          onOkTap: () {
                                                            ticketManagementWatch.clearEndDate();
                                                            // updateIsDatePickerVisible();
                                                            // orderListWatch.updateIsDatePickerVisible(false);
                                                          },
                                                          onCancelTap: () {
                                                            // updateIsDatePickerVisible();
                                                            // orderListWatch.updateIsDatePickerVisible(false);
                                                          },
                                                        ),
                                                          width: 0.5,
                                                          height:0.55,
                                                        );
                                                      },
                                                      child: Container(
                                                        height: context.height*0.07,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.lightPinkF7F7FC),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(
                                                              Icons.calendar_today_outlined,
                                                              // color: getDateTextIconColor(isStartDate, startDate, endDate),
                                                            ),
                                                            SizedBox(
                                                              width: context.width*0.010,
                                                            ),
                                                            FittedBox(
                                                              fit: BoxFit.contain,
                                                              child: CommonText(
                                                                title: ticketManagementWatch.startDate != null ? dateFormatFromDateTime(ticketManagementWatch.startDate, dateFormat) : LocaleKeys.keyStartDate.localized,
                                                                fontSize: 12.sp,
                                                                // clrfont: getDateTextIconColor(isStartDate, startDate, endDate),
                                                              ),
                                                            ),
                                                          ],
                                                        ).paddingSymmetric(horizontal: context.width*0.005),
                                                      ),
                                                    ),
                                                     Visibility(visible: ticketManagementWatch.startDateError != null, child: CommonText(title: ticketManagementWatch.startDateError.toString(), textStyle: TextStyles.regular.copyWith(color: AppColors.red), maxLines: 3,))
                                                  ],
                                                );
                                              }),
                                            ),

                                            SizedBox(
                                              width: context.width*0.020,
                                            ),

                                            ///End Date
                                            Expanded(
                                              child: Consumer(builder: (context, ref, child) {
                                                return Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        /// End Date Calender Picker
                                                        showCommonWebDialog(
                                                            width: 0.5,
                                                            height:0.55,
                                                            keyBadge: ticketManagementWatch.endDateSelectionDialogKey,
                                                            context: context, dialogBody: CustomDatePicker(
                                                          selectDateOnTap: true,
                                                          width: context.width * 0.5,
                                                          height: context.height * 0.5,
                                                          bubbleDirection: true,
                                                          bubbleColor: AppColors.white,
                                                          initialDate: ticketManagementWatch.endDate,
                                                          firstDate: ticketManagementWatch.startDate,
                                                          lastDate: DateTime.now(),
                                                          getDateCallback: (DateTime? selectedDate, {bool? isOkPressed}) {
                                                            ticketManagementWatch.updateStartEndDate(false, selectedDate);
                                                            // = DateFormat('dd/MM/yyyy').format(selectedDate ?? DateTime.now());
                                                          },
                                                          onOkTap: () {
                                                            // updateIsDatePickerVisible();
                                                            // orderListWatch.updateIsDatePickerVisible(false);
                                                          },
                                                          onCancelTap: () {
                                                            // updateIsDatePickerVisible();
                                                            // orderListWatch.updateIsDatePickerVisible(false);
                                                          },
                                                        ));
                                                      },
                                                      child: Container(
                                                        height: context.height*0.07,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.lightPinkF7F7FC),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(
                                                              Icons.calendar_today_outlined,
                                                              // color: getDateTextIconColor(isStartDate, startDate, endDate),
                                                            ),
                                                            SizedBox(
                                                              width: context.width*0.010,
                                                            ),
                                                            FittedBox(
                                                              fit: BoxFit.contain,
                                                              child: CommonText(
                                                                title: ticketManagementWatch.endDate != null ? dateFormatFromDateTime(ticketManagementWatch.endDate, dateFormat) : LocaleKeys.keyEndDate.localized,
                                                                fontSize: 12.sp,
                                                                // clrfont: getDateTextIconColor(isStartDate, startDate, endDate),
                                                              ),
                                                            ),
                                                          ],
                                                        ).paddingSymmetric(horizontal: context.width*0.005),
                                                      ),
                                                    ),
                                                    Visibility(visible: ticketManagementWatch.endDateError != null, child: CommonText(title: ticketManagementWatch.endDateError.toString(), textStyle: TextStyles.regular.copyWith(color: AppColors.red), maxLines: 3,))
                                                  ],
                                                );
                                              }),
                                            ),

                                            SizedBox(
                                              width: context.width*0.020,
                                            ),
                                            Container(
                                              height: context.height*0.05,
                                              width: context.width*0.05,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.black,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  ticketManagementWatch.startDateValidation();
                                                  ticketManagementWatch.endDateValidation();
                                                  if(ticketManagementWatch.startDateError == null && ticketManagementWatch.endDateError == null) {
                                                    ticketManagementWatch.ticketListApi(context, false).then((value){
                                                      if(ticketManagementWatch.ticketListState.success?.status == ApiEndPoints.apiStatus_200){
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  }
                                                },
                                                child: CommonSVG(
                                                  strIcon: Assets.svgs.svgRightArrow.keyName,
                                                  svgColor: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: context.width*0.020, vertical: context.height*0.015),
                                  );
                                }
                            ),
                          ),
                        ],
                        offset: Offset(-1.w, 60.h),
                        child: CommonSVG(
                          strIcon: Assets.svgs.svgDate.keyName,
                          height: context.height*0.049,
                          width: context.width*0.049,),
                      ).paddingOnly(right: context.width * 0.008),


                      /// Export Button
                      // CommonButton(
                      //   buttonText: LocaleKeys.keyExport.localized,
                      //   rightIcon: CommonSVG(strIcon: Assets.svgs.svgExport.keyName, height: context.height*0.020,),
                      //   height: context.height*0.060,
                      //   width: context.width*0.101,
                      //   buttonTextStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.clr828282),
                      //   onTap: () {},
                      // ).paddingOnly(right: context.width*0.009),

                      /// Create Ticket Button
                      CommonButton(
                        buttonText: "${LocaleKeys.keyCreate.localized} ${LocaleKeys.keyTicket.localized}",
                        height:context.height*0.060,
                        width: context.width*0.101,
                        buttonTextStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.white),
                        isButtonEnabled: true,
                        isLoading: ticketManagementWatch.ticketReasonListState.isLoading,
                        backgroundColor: AppColors.black,
                        onTap: () async {
                          ticketManagementWatch.clearTicketReasonData();
                          /// Create ticket form
                          await ticketManagementWatch.ticketReasonListApi(context).then((value){
                            if(value.success?.status == ApiEndPoints.apiStatus_200){
                              showCommonWebDialog(
                                  width: 0.5,
                                  context: mainClassCntx,
                                  keyBadge: ticketManagementWatch.dailog1Key,
                                  dialogBody: ticketManagementWatch.ticketReasonListState.isLoading?
                                  DialogProgressBar(isLoading: ticketManagementWatch.ticketReasonListState.isLoading):
                                  const TicketCreateDialog()
                              );
                            }
                          });


                        },
                      )
                    ],
                  )
                ],
              ).paddingOnly(left: context.width*0.025, right: context.width*0.025, top: context.height*0.030),
            ],
          );
        }
    );
  }
}
class TicketCreateDialog extends StatelessWidget with BaseStatelessWidget{
  const TicketCreateDialog({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CommonText(
                title: "${LocaleKeys.keyCreate.localized} ${LocaleKeys.keyTicket.localized}",
                fontSize: 20.sp,
                clrfont: AppColors.black,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName),
              ),
            )
          ],
        ),
        SizedBox(height: context.height * 0.040,),

        CreateTicketStatusFormWidget(
          index: 0,mainClassCntx: context,ticketStatus: "",
          onDialogPopCall: (){},),
      ],
    ).paddingAll(context.height*0.040);
  }
}
