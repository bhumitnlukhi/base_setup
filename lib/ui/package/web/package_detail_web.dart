import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/package/package_detail_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/package/web/helper/package_wallet_history_table_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_shimmer.dart';

class PackageDetailWeb extends ConsumerStatefulWidget {
  final String packageUuid;
  final String? clientMasterUuid;
  const PackageDetailWeb({Key? key, required this.packageUuid,  this.clientMasterUuid}) : super(key: key);

  @override
  ConsumerState<PackageDetailWeb> createState() => _PackageDetailWebState();
}

class _PackageDetailWebState extends ConsumerState<PackageDetailWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final packageDetailWatch = ref.watch(packageDetailController);
      packageDetailWatch.disposeController(isNotify : true);
      await packageDetailWatch.packageWalletHistoryListApi(context, packageUuid: widget.packageUuid, false, clientMasterUuid: widget.clientMasterUuid);
      packageDetailWatch.historyScrollController.addListener(() async{
        if (packageDetailWatch.packageWalletHistoryListState.success?.hasNextPage == true) {
          if (packageDetailWatch.historyScrollController.position.maxScrollExtent == packageDetailWatch.historyScrollController.position.pixels) {
            if(!packageDetailWatch.packageWalletHistoryListState.isLoadMore) {
              await packageDetailWatch.packageWalletHistoryListApi(context, packageUuid: widget.packageUuid, true, clientMasterUuid: widget.clientMasterUuid);
            }
          }
        }
      });
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  @override
  ///Build Override
  Widget buildPage(BuildContext context) {
    final packageDetailWatch = ref.watch(packageDetailController);
    return FadeBoxTransition(
      child: Column(
        children: [
          CommonBackTopWidget(title: LocaleKeys.keyPackageWalletDetail.localized, onTap: () {
            ref.read(navigationStackController).pop();
          },).paddingOnly(bottom: context.height * 0.02),
          ///Wallet Balance
      
          // packageDetailWatch.vendorDetailState.isLoading?
          // CommonShimmer(height: context.height * 0.15, width: double.infinity):
          packageDetailWatch.packageWalletHistoryListState.isLoading?
          CommonShimmer(height: context.height * 0.15, width: double.infinity):
          Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Wallet Balance Title
                    CommonText(
                      title: LocaleKeys.keyRemainingBudget.localized,
                      textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: context.height * 0.01,
                    ),
      
                    ///Amount
                    Row(
                      children: [
                        SizedBox(
                          // width: context.width*0.06*(1),
                          child: CommonText(
                            title: packageDetailWatch.isBalanceHidden ? '${Session.getCurrency()} ${"X"*(packageDetailWatch.currentBalanceValue.toString().length)}': '${Session.getCurrency()} ${packageDetailWatch.currentBalanceValue}',
                            textStyle: TextStyles.semiBold.copyWith(fontSize: 30.sp, color: AppColors.primary2),
                          ),
                        ).paddingOnly(right: context.width * 0.010),
                        InkWell(
                            onTap: () {
                              packageDetailWatch.changeBalanceVisibility();
                            },
                            child: CommonSVG(
                                strIcon: packageDetailWatch.isBalanceHidden ? Assets.svgs.svgPasswordUnhide.keyName :Assets.svgs.svgPasswordHide.keyName,
                                height: 24.h,
                                boxFit: BoxFit.scaleDown,
                                width: 24.h))
                      ],
                    ),
                  ],
                ),
      
              ],
            ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
          ),
      
          SizedBox(
            height: context.height * 0.03,
          ),
      
          ///Wallet Transaction History
          Expanded(
            child:
            Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Wallet Balance Title
                  packageDetailWatch.packageWalletHistoryListState.isLoading ?
                  CommonShimmer(height: context.height * 0.050, width: context.width * 0.30):
                  CommonText(
                    title: LocaleKeys.keyWalletTransactionHistory.localized,
                    textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp),
                  ),
                  SizedBox(
                    height: context.height * 0.03,
                  ),
      
                   Expanded(child: PackageWalletHistoryTableWidget(
                   packageUuid: widget.packageUuid,
                   clientMasterUuid: widget.clientMasterUuid,
                  ))
                ],
              ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: context.width * 0.02, vertical: context.height * 0.03),
    );
  }



}
