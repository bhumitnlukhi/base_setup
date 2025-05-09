import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/package_detail_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/package/web/helper/services_history_date_dialog.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class PackageWalletHistoryTableWidget extends ConsumerStatefulWidget {
  final String packageUuid;
  final String? clientMasterUuid;

  const PackageWalletHistoryTableWidget({super.key, required this.packageUuid, required this.clientMasterUuid});

  @override
  ConsumerState<PackageWalletHistoryTableWidget> createState() => _PackageWalletHistoryTableWidgetState();
}

class _PackageWalletHistoryTableWidgetState extends ConsumerState<PackageWalletHistoryTableWidget> with BaseConsumerStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    final packageDetailWatch = ref.watch(packageDetailController);
    return Column(
      children: [
        packageDetailWatch.packageWalletHistoryListState.isLoading
            ? CommonShimmer(height: context.height * 0.05, width: double.infinity).paddingOnly(bottom: context.height * 0.030)
            : Table(
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
                  /// Date
                  0: FlexColumnWidth(1.5),

                  /// Time
                  1: FlexColumnWidth(2),

                  /// Transaction Id
                  2: FlexColumnWidth(3),

                  /// Timezone
                  3: FlexColumnWidth(2),

                  /// transaction message
                  4: FlexColumnWidth(3),

                  /// amount
                  5: FlexColumnWidth(2),

                  ///Amount
                  // 4: FlexColumnWidth(2),
                  //
                  // ///Status
                  // 5: FlexColumnWidth(1.5),
                },
                children: [
                  TableRow(children: [
                    Row(
                      children: [
                        TableHeaderTextWidget(
                          text: LocaleKeys.keyDate.localized,
                          textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                        ).paddingOnly(right: context.width * 0.020),
                        ServiceHistoryDateDialog(
                            globalKey: packageDetailWatch.dateKey,
                            startDate: packageDetailWatch.startDate,
                            endDate: packageDetailWatch.endDate,
                            getDateCallback: (DateTime? selectedDate, bool isStartDate, {bool? isOkPressed}) {
                              if (isOkPressed ?? false) {
                                packageDetailWatch.updateStartEndDate(isStartDate, selectedDate);
                              } else {
                                packageDetailWatch.updateTempDate(selectedDate);
                              }
                            },
                            onClearCallBack: (DateTime? startDate, DateTime? endDate) async {
                              /// Updating start date and end date on clear
                              if (startDate != null && endDate != null) {
                                packageDetailWatch.clearStartDateEndDate(callbackStartDate: startDate, callbackEndDate: endDate);
                                packageDetailWatch.packageWalletHistoryListApi(context, packageUuid: widget.packageUuid, false, clientMasterUuid: widget.clientMasterUuid);
                                Navigator.pop(context);

                                ///Api call
                                // await packageDetailWatch
                                //     .getCreatedTicketListApi(context, false,
                                //     pageNumber: 1);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            onApplyClick: () {
                              if ((packageDetailWatch.endDate!.isAfter(packageDetailWatch.startDate!)) || (packageDetailWatch.endDate!.isAtSameMomentAs(packageDetailWatch.startDate!))) {
                                /// Api Call if the ticket list state is not loading
                                if (!packageDetailWatch.packageWalletHistoryListState.isLoading) {
                                  /// Api Call
                                  packageDetailWatch.packageWalletHistoryListApi(context, packageUuid: widget.packageUuid, false, clientMasterUuid: widget.clientMasterUuid);
                                  Navigator.pop(context);
                                  // _getTicketListApiCall(
                                  //     ticketManagementWatch, context);
                                }
                              }
                            },
                            updateIsDatePickerVisible: () {}),
                      ],
                    ),

                    TableHeaderTextWidget(
                      text: LocaleKeys.keyTime.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    // TableHeaderTextWidget(text: LocaleKeys.keyTransactionID.localized,textStyle: TextStyles.medium.copyWith(
                    //     fontSize: 16.sp,
                    //     color: AppColors.black
                    // ),),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyTransactionType.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),

                    TableHeaderTextWidget(
                      text: LocaleKeys.keyTimezone.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    // _widgetTableHeader(
                    //     text: LocaleKeys.keyStatus.localized, rightImage: true,
                    //     rightWidget: const TransactionTypeFilterWidgetWeb(),
                    // ),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyTransactionMessage.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyAmount.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    // TableHeaderTextWidget(text: LocaleKeys.keyStatus.localized,textStyle: TextStyles.medium.copyWith(
                    //     fontSize: 16.sp,
                    //     color: AppColors.black
                    // ),),
                  ]),
                ],
              ).paddingOnly(top: 25.h, bottom: 20.h),
        Consumer(builder: (context, ref, child) {
          return Expanded(
            child: packageDetailWatch.packageWalletHistoryListState.isLoading
                ? const CommonListShimmer()
                : packageDetailWatch.packageWalletListData.isEmpty
                    ? EmptyStateWidget(
                        imgName: Assets.svgs.svgNoData.keyName,
                        title: LocaleKeys.keyNoDataFound.localized,
                        imgHeight: context.height * 0.20,
                        imgWidth: context.height * 0.20,
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        controller: packageDetailWatch.historyScrollController,
                        itemCount: packageDetailWatch.packageWalletListData.length,
                        itemBuilder: (context, index) {
                          final itemList = packageDetailWatch.packageWalletListData[index];
                          return Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                            columnWidths: const {
                              /// Date
                              0: FlexColumnWidth(1.5),

                              /// Time
                              1: FlexColumnWidth(2),

                              /// Transaction Id
                              2: FlexColumnWidth(3),

                              /// Timezone
                              3: FlexColumnWidth(2),

                              /// transaction message
                              4: FlexColumnWidth(3),

                              /// amount
                              5: FlexColumnWidth(2),

                              ///Amount
                              // 4: FlexColumnWidth(2),
                              //
                              // ///Status
                              // 5: FlexColumnWidth(1.5),
                            },
                            children: [
                              TableRow(children: [
                                ///Date
                                CommonText(
                                  title: itemList.transactionType == "CREDIT" ? timeZone(itemList.destinationTimeZone ?? '', itemList.transactionTime ?? 0, dateFormat) : timeZone(itemList.destinationTimeZone ?? '', itemList.adsShowTime ?? 0, dateFormat),
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),
                                // CommonText(title: "29 May 2024",textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),),

                                ///Time
                                CommonText(
                                  title: itemList.transactionType == "CREDIT" ? timeZone(itemList.destinationTimeZone ?? '', itemList.transactionTime ?? 0, 'hh:mm:ss a').toString().allInCaps : timeZone(itemList.destinationTimeZone ?? '', itemList.adsShowTime ?? 0, 'hh:mm:ss a').toString().allInCaps,
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),
                                // CommonText(title: "12:34 PM",textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),),

                                ///Transaction Id
                                // CommonText(title: itemList.uuid??'',textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),),
                                // CommonText(title: "ujns-erwe-wew-wew",textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),),

                                ///Transaction Type
                                CommonText(
                                  title: itemList.transactionType ?? '',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, color: itemList.transactionType == "DEBIT" ? AppColors.clrFF5858 : AppColors.green35C658),
                                ),

                                ///Timezone
                                CommonText(
                                  title: itemList.destinationTimeZone ?? '',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),
                                // CommonText(title: "Debit",textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, )),

                                ///transaction Message
                                CommonText(
                                  title: itemList.transactionMessage ?? '-',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                  maxLines: 10,
                                ),
                                ///Amount
                                CommonText(
                                  title: '${itemList.currency ?? ''} ${itemList.amount ?? 0}',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),
                                // CommonText(title: '\$${89789}',textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),),

                                ///Status
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: AppColors.greenE2FFE6,
                                //     borderRadius: BorderRadius.circular(16.r)
                                //   ),
                                //   child: Center(
                                //     child: CommonText(
                                //       title: 'Completed',
                                //       textStyle: TextStyles.regular.copyWith(
                                //         fontSize: 12.sp,
                                //         color: AppColors.green30C844
                                //       ),
                                //
                                //     ),
                                //   ).paddingSymmetric(vertical: context.height*0.008,horizontal: context.width*0.012),
                                // ),
                              ]),
                            ],
                          ).paddingOnly(top: 20.h);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: context.height * 0.0,
                          );
                        },
                      ),
          );
        }),
        DialogProgressBar(
          isLoading: packageDetailWatch.packageWalletHistoryListState.isLoadMore,
          forPagination: true,
        )
      ],
    );
  }

}
