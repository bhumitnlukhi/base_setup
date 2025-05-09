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
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_shimmer.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/client_list_widget.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/wallet_history_table_widget.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/ui/wallet/web/helper/add_fund_agency_dialog.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';

class AgencyWalletWidget extends ConsumerStatefulWidget {
  const AgencyWalletWidget({super.key});

  @override
  ConsumerState<AgencyWalletWidget> createState() => _AgencyWalletWidgetState();
}

class _AgencyWalletWidgetState extends ConsumerState<AgencyWalletWidget> with BaseConsumerStatefulWidget{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final walletWatch = ref.watch(walletController);
      final selectClientWatch = ref.watch(selectClientController);
      selectClientWatch.disposeController(isNotify : true);
      walletWatch.disposeController(isNotify: true);

      await walletWatch.vendorDetailApi(context).then((value) async {
        await walletWatch.transactionHistoryListApi(context, false);
      }).then((value) async {
        await selectClientWatch.clientListApi(context, false).then((value){
          walletWatch.setClientListForDropDown(selectClientWatch.clientList);
          walletWatch.updateClientList(selectClientWatch.clientList);
        });

      });

      selectClientWatch.scrollController.addListener(() async{
        if (selectClientWatch.clientListState.success?.hasNextPage == true) {
          if (selectClientWatch.scrollController.position.maxScrollExtent == selectClientWatch.scrollController.position.pixels) {
            if(!selectClientWatch.clientListState.isLoadMore) {
              await selectClientWatch.clientListApi(context,true).then((value){
                walletWatch.clientList = selectClientWatch.clientList;
              });
            }
          }
        }
      });

      walletWatch.historyScrollController.addListener(() async{
        if (walletWatch.transactionHistoryListState.success?.hasNextPage == true) {
          if (walletWatch.historyScrollController.position.maxScrollExtent == walletWatch.historyScrollController.position.pixels) {
            if(!walletWatch.transactionHistoryListState.isLoadMore) {
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
    final selectClientWatch = ref.watch(selectClientController);

    return Column(
      children: [
        ///Wallet Balance
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    walletWatch.vendorDetailState.isLoading? CommonShimmer(height: context.height * 0.22, width: context.width * 0.20,) :
                    Container(
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                      child: Column(
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
                              SizedBox(
                                width: context.width * 0.15,
                                child: CommonText(
                                  // title: walletWatch.isBalanceHidden ? '${Session.getCurrency()} ${'X' * (walletWatch.vendorDetailState.success?.data?.wallet.toString().length??0) }' : '${Session.getCurrency()} ${NumberFormatter.formatter("${walletWatch.vendorDetailState.success?.data?.wallet ??''}")}',
                                  title: walletWatch.isBalanceHidden ? '${Session.getCurrency()} ${'X' * (walletWatch.vendorDetailState.success?.data?.wallet.toString().length??0) }' : '${Session.getCurrency()} ${"${walletWatch.vendorDetailState.success?.data?.wallet ??''}"}',
                                  textStyle: TextStyles.semiBold.copyWith(fontSize: 30.sp, color: AppColors.primary2),
                                ).paddingOnly(right: context.width * 0.010),
                              ),
                              InkWell(

                                  onTap: ()  {
                                    walletWatch.changeBalanceVisibility();

                                  },
                                  child: CommonSVG(strIcon: walletWatch.isBalanceHidden ? Assets.svgs.svgPasswordUnhide.keyName :Assets.svgs.svgPasswordHide.keyName, height: context.height * (walletWatch.isBalanceHidden? 0.030 :0.020), width: context.height * (walletWatch.isBalanceHidden? 0.030 :0.020)))
                            ],
                          ),

                          SizedBox(
                            height: context.height * 0.03,
                          ),

                          ///Add Button
                          InkWell(
                            onTap: () async {
                              // final selectClientWatch = ref.watch(selectClientController);
                              final walletWatch = ref.watch(walletController);
                              final formKey = GlobalKey<FormState>();
                              // selectClientWatch.disposeController(isNotify : true);
                              walletWatch.disposeDialogData();


                              ///Add Button On Tap
                              showCommonWebDialog(
                                width: 0.5,
                                // height: context.height * 0.52,
                                context: context,
                                keyBadge: walletWatch.addFundAgencyDialogKey,
                                // height: context.height * 0.5,
                                dialogBody:  AddFundAgency(formKey: formKey)
                                    .paddingSymmetric(
                                  horizontal: context.width * 0.03,
                                  vertical: context.height * 0.03,
                                ),
                              );
                              // await selectClientWatch.clientListApi(context, false).then((value){
                              //   print("walletWatch.clientList.length");
                              //   print(walletWatch.clientList.length);
                              //   walletWatch.disposeDialogData();
                              //
                              //
                              // });

                            },
                            child: Container(
                              height: context.height*0.065,
                              decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(30.r)
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                      ).paddingSymmetric(horizontal: context.width * 0.015, vertical: context.height * 0.020),
                    ),

                    SizedBox(
                      height: context.height * 0.02,
                    ),

                    ///Client List Title
                    CommonText(
                      title: LocaleKeys.keyClientList.localized,
                      textStyle: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 18.sp),
                    ),

                    SizedBox(
                      height: context.height * 0.02,
                    ),

                    ///Client List
                     Expanded(child: selectClientWatch.clientListState.isLoading?
                     const CommonListShimmer():
                     walletWatch.clientList.isEmpty?
                     EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized,):
                     const ClientListWidget())
                  ],
                ).paddingOnly(right: context.width*0.02),
              ),

              ///Wallet Transaction History
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    /*walletWatch.transactionHistoryListState.isLoading ||  */walletWatch.filterApplied==false?
                    CommonShimmer(height: context.height * 0.06, width: double.infinity).paddingOnly(bottom: context.height * 0.020):
                    Container(
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10.w,),
                          ///Person name
                          CommonText(
                            title: walletWatch.selectedClientInList!=null ? (walletWatch.selectedClientInList?.name??'') : (walletWatch.vendorDetailState.success?.data?.name??''),
                            textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                          ),
                          // CommonText(
                          //   title: walletWatch.selectedClientInList!=null? "\$${walletWatch.selectedClientInList?.wallet}":"\$${walletWatch.vendorDetailState.success?.data?.wallet??''}",
                          //   textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                          // ),
                          InkWell(
                              onTap: () async {
                                walletWatch.updateSelectedClientInList(null);
                                walletWatch.disposeWalletHistoryData();
                                await walletWatch.transactionHistoryListApi(context, false);
                              },
                              child: Visibility(
                                  visible: walletWatch.selectedClientInList!=null,
                                  child: CommonSVG(strIcon: Assets.svgs.svgCancel.keyName, height: context.height * 0.030, width: context.height * 0.030, )))

                        ],
                      ).paddingSymmetric(horizontal: context.width * 0.030, vertical: context.height * 0.010),
                    ).paddingOnly(bottom: context.height * 0.020),
                    Expanded(
                      child:
                      Container(
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Wallet Balance Title
                            CommonText(
                              title: LocaleKeys.keyWalletTransactionHistory.localized,
                              textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                            ),
                            SizedBox(
                              height: context.height * 0.03,
                            ),
                      
                            const Expanded(child: WalletHistoryTableWidget())
                      
                          ],
                        ).paddingSymmetric(horizontal: context.width * 0.030, vertical: context.height * 0.030),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ],
    );
  }
}
