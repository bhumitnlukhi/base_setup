import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_shimmer.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/add_fund_dialog.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/wallet_history_table_widget.dart';

class VendorWalletWidget extends ConsumerStatefulWidget {
  const VendorWalletWidget({super.key});

  @override
  ConsumerState<VendorWalletWidget> createState() => _VendorWalletWidgetState();
}

class _VendorWalletWidgetState extends ConsumerState<VendorWalletWidget> with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final walletWatch = ref.watch(walletController);
      walletWatch.disposeController(isNotify: true);

      await walletWatch.vendorDetailApi(context).then((value) async {
        await walletWatch.transactionHistoryListApi(context, false);
      });

      walletWatch.historyScrollController.addListener(() async {
        if (walletWatch.transactionHistoryListState.success?.hasNextPage == true) {
          if (walletWatch.historyScrollController.position.maxScrollExtent == walletWatch.historyScrollController.position.pixels) {
            if (!walletWatch.transactionHistoryListState.isLoadMore) {
              await walletWatch.transactionHistoryListApi(context, true);
            }
          }
        }
      });
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final walletWatch = ref.watch(walletController);
    return Column(
      children: [
        ///Wallet Balance

        walletWatch.vendorDetailState.isLoading
            ? CommonShimmer(height: context.height * 0.15, width: double.infinity)
            : Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Wallet Balance Title
                        CommonText(
                          title: LocaleKeys.keyWalletBalance.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                        ),
                        SizedBox(
                          height: context.height * 0.01,
                        ),

                        ///Amount
                        Row(
                          children: [
                            CommonText(
                              title: walletWatch.isBalanceHidden ? '${Session.getCurrency()} ${'X' * (walletWatch.vendorDetailState.success?.data?.wallet.toString().length ?? 0)}' : '${Session.getCurrency()} ${walletWatch.vendorDetailState.success?.data?.wallet ?? ''}',
                              textStyle: TextStyles.semiBold.copyWith(fontSize: 30.sp, color: AppColors.primary2),
                            ).paddingOnly(right: context.width * 0.010),
                            InkWell(
                                onTap: () {
                                  walletWatch.changeBalanceVisibility();
                                },
                                child: CommonSVG(strIcon: walletWatch.isBalanceHidden ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName, height: 24.h, boxFit: BoxFit.scaleDown, width: 24.h))
                          ],
                        ),
                      ],
                    ),

                    ///Add Button
                    InkWell(
                      onTap: () {
                        final formKey = GlobalKey<FormState>();
                        walletWatch.disposeDialogData();

                        ///Add Button On Tap
                        ///Add Button On Tap
                        showCommonWebDialog(
                          width: 0.5,
                          height: 0.4,
                          // height: context.height * 0.52,
                          context: context,
                          keyBadge: walletWatch.addFundDialogKey,
                          // height: context.height * 0.5,
                          dialogBody: AddFundDialog(formKey: formKey).paddingSymmetric(
                            horizontal: context.width * 0.03,
                            vertical: context.height * 0.03,
                          ),
                        );
                        // showCommonWebDialog(
                        //   keyBadge:  walletWatch.addFundDialogKey,
                        //   context: context,
                        //   width: 0.5,
                        //   dialogBody:  const AddFundDialog()
                        //       .paddingSymmetric(
                        //     horizontal: context.width * 0.03,
                        //     vertical: context.height * 0.03,
                        //   ),
                        // );
                      },
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(30.r)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColors.white,
                              size: 15.h,
                            ),
                            CommonText(
                              title: LocaleKeys.keyAddFund.localized,
                              textStyle: TextStyles.regular.copyWith(color: AppColors.white, fontSize: 14.sp),
                            ),
                          ],
                        ).paddingSymmetric(horizontal: context.width * 0.015, vertical: context.height * 0.016),
                      ),
                    )
                  ],
                ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
              ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Wallet Transaction History
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Wallet Balance Title
                (/*walletWatch.transactionHistoryListState.isLoading || */ !(walletWatch.filterApplied))
                    ? CommonShimmer(height: context.height * 0.050, width: context.width * 0.30)
                    : CommonText(
                        title: LocaleKeys.keyWalletTransactionHistory.localized,
                        textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                      ),
                SizedBox(
                  height: context.height * 0.03,
                ),

                const Expanded(child: WalletHistoryTableWidget())
              ],
            ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
          ),
        )
      ],
    );
  }
}
