import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
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
import 'package:odigo_vendor/ui/wallet/web/helper/transaction_type_filter_widget_web.dart';

class WalletHistoryTableWidget extends ConsumerStatefulWidget {
  const WalletHistoryTableWidget({super.key});

  @override
  ConsumerState<WalletHistoryTableWidget> createState() => _WalletHistoryTableWidgetState();
}

class _WalletHistoryTableWidgetState extends ConsumerState<WalletHistoryTableWidget> with BaseConsumerStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    final walletWatch = ref.watch(walletController);
    return Column(
      children: [
        /*walletWatch.transactionHistoryListState.isLoading &&  */ walletWatch.filterApplied == false
            ? CommonShimmer(height: context.height * 0.05, width: double.infinity).paddingOnly(bottom: context.height * 0.030)
            : Table(
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
                  /// Date
                  0: FlexColumnWidth(1.5),

                  /// Time
                  1: FlexColumnWidth(1.2),

                  /// Transaction Id
                  2: FlexColumnWidth(3),

                  /// type
                  3: FlexColumnWidth(1.5),

                  ///Amount
                  4: FlexColumnWidth(1.7),

                  ///Status
                  5: FlexColumnWidth(2.5),
                },
                children: [
                  TableRow(children: [
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyDate.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyTime.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyTransactionID.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    // TableHeaderTextWidget(text: LocaleKeys.keyTransactionType.localized,textStyle: TextStyles.medium.copyWith(
                    //     fontSize: 16.sp,
                    //     color: AppColors.black
                    // ),),
                    _widgetTableHeader(
                      text: walletWatch.selectedTransactionType.name,
                      rightImage: true,
                      rightWidget: const TransactionTypeFilterWidgetWeb(),
                    ),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyAmount.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                    TableHeaderTextWidget(
                      text: LocaleKeys.keyStatus.localized,
                      textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                    ),
                  ]),
                ],
              ).paddingOnly(top: 25.h, bottom: 20.h),
        Consumer(builder: (context, ref, child) {
          return Expanded(
            child: walletWatch.transactionHistoryListState.isLoading
                ? const CommonListShimmer()
                : walletWatch.walletListData.isEmpty
                    ? EmptyStateWidget(
                        imgName: Assets.svgs.svgNoData.keyName,
                        title: LocaleKeys.keyNoDataFound.localized,
                        imgHeight: context.height * 0.20,
                        imgWidth: context.height * 0.20,
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        controller: walletWatch.historyScrollController,
                        itemCount: walletWatch.walletListData.length,
                        itemBuilder: (context, index) {
                          final itemList = walletWatch.walletListData[index];
                          var (bgColor, textColor) = getAllStatusColor(itemList.transactionType == "DEBIT" ? "SUCCESS" : itemList.status);
                          return Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                            columnWidths: const {
                              /// Date
                              0: FlexColumnWidth(1.5),

                              /// Time
                              1: FlexColumnWidth(1.2),

                              /// Transaction Id
                              2: FlexColumnWidth(3),

                              /// Space
                              3: FlexColumnWidth(1.5),

                              ///Amount
                              4: FlexColumnWidth(1.7),

                              ///Status
                              5: FlexColumnWidth(2.5),
                            },
                            children: [
                              TableRow(children: [
                                ///Date
                                CommonText(
                                  title: getDateTimeFromMilliseconds(itemList.transactionDateTime ?? 0, dateFormat),
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),

                                ///Time
                                CommonText(
                                  title: getDateTimeFromMilliseconds(itemList.transactionDateTime ?? 0, 'hh:mm a'),
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),

                                ///Transaction Id
                                CommonText(
                                  title: itemList.uuid ?? '',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),

                                CommonText(
                                  title: itemList.transactionType ?? '',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, color: itemList.transactionType == "DEBIT" ? AppColors.clrFF5858 : AppColors.green35C658),
                                ),

                                ///Transaction Id
                                CommonText(
                                  // title: '${Session.getCurrency()} ${NumberFormatter.formatter("${itemList.amount ?? 0}")}',
                                  title: '${Session.getCurrency()} ${"${itemList.amount ?? 0}"}',
                                  textStyle: TextStyles.regular.copyWith(fontSize: 16.sp),
                                ),

                                ///Status
                                InkWell(
                                  onTap: () {
                                    showLog('itemList.status ${itemList.status}');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16.r)),
                                    child: Center(
                                      child: CommonText(
                                        title: itemList.transactionType == "DEBIT" ? "SUCCESS" : itemList.status ?? '-',
                                        textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: textColor),
                                      ),
                                    ).paddingSymmetric(vertical: context.height * 0.008, horizontal: context.width * 0.012),
                                  ),
                                ),
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
          isLoading: walletWatch.transactionHistoryListState.isLoadMore,
          forPagination: true,
        )
      ],
    );
  }

  Widget _widgetTableHeader({required String text, TextAlign? textAlign, bool? rightImage, Widget? rightWidget}) {
    return Row(
      children: [
        CommonText(
          title: text,
          textAlign: textAlign ?? TextAlign.left,
          textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.black),
        ).paddingOnly(right: rightImage == true ? 5.w : 0.0),
        rightImage == true ? rightWidget as Widget : const Offstage()
      ],
    );
  }
}
