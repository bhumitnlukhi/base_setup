import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/stores/web/helper/destination_filter_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_list_tile.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_child_text_widget_master.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class CommonOwnPastPackageListWidget extends ConsumerWidget with BaseConsumerWidget {
  const CommonOwnPastPackageListWidget({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final packageWatch = ref.watch(packageController);
    final storeWatch = ref.watch(storesController);
    return Column(
      children: [

        /// Header
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: {
            0: const FlexColumnWidth(3),
            1: const FlexColumnWidth(2),
            2: const FlexColumnWidth(2),
            3: const FlexColumnWidth(3),
            4: FlexColumnWidth((Session.getUserType() == UserType.VENDOR.name) ? 2.5 : 0.001),
            5: const FlexColumnWidth(2),
            6: const FlexColumnWidth(2),

          },
          children:  [
            TableRow(
              children: [
                // TableHeaderTextWidget(text:LocaleKeys.keyPackageName.localized,),
                TableHeaderTextWidget(text:LocaleKeys.keyPackageDuration.localized,),
                TableHeaderTextWidget(text:LocaleKeys.keyDailyBudget.localized,),
                TableHeaderTextWidget(text:LocaleKeys.keyBudget.localized,),
                Row(
                  children: [
                    Expanded(child: TableHeaderTextWidget(text: packageWatch.destinationData != null ? (packageWatch.destinationData?.name ?? '') :LocaleKeys.keyDestinationName.localized)),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: DestinationFilterWidget(
                        selectedDestination: packageWatch.destinationData,
                          // layerLink: packageWatch.link,
                          // overlayPortalController: packageWatch.tooltipController,
                          onTap: () async {
                          packageWatch.clearData();
                        await packageWatch.packageListApi(context, false);
                      }),
                    )
                  ],
                ),
                (Session.getUserType() == UserType.VENDOR.name) ? TableHeaderTextWidget(text:LocaleKeys.keyStoreName.localized,) : const Offstage(),
                TableHeaderTextWidget(text:LocaleKeys.keyStatus.localized,),

                packageWatch.isFilterApplied()
                    ? InkWell(
                  onTap: () async{
                    packageWatch.clearFilters(context);
                    if (storeWatch.tooltipDestinationController?.isShowing ?? false) {
                      storeWatch.tooltipDestinationController?.toggle();
                    }
                    await packageWatch.packageListApi(context, true);
                  },
                  child: CommonText(
                    title: LocaleKeys.keyClearFilters.localized,
                    textAlign: TextAlign.right,
                    textStyle: TextStyles.medium.copyWith(color: AppColors.clr009AF1, decoration: TextDecoration.underline),
                  ),
                )
                    : const Offstage(),
              ],
            ),
          ],
        ).paddingLTRB(context.width*0.02, context.width*0.02, context.width*0.02, context.width*0.006),

        /// List
        packageWatch.packageListState.isLoading ?  const Expanded(child: CommonListShimmer()) :

        Expanded(
          child:FadeBoxTransition(
            child: SingleChildScrollView(
              controller: packageWatch.packageScrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (packageWatch.packageList.isNotEmpty)
                   ? ListView.separated(
                    shrinkWrap: true,
                    // controller: packageWatch.packageScrollController ,
                    itemCount: packageWatch.packageList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var packageData = packageWatch.packageList[index];
                      var (bgColor, textColor) = getAllStatusColor(packageData?.status);
                      return CommonListTile(
                        childWidget: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                          columnWidths: {
                            0: const FlexColumnWidth(3),
                            1: const FlexColumnWidth(2),
                            2: const FlexColumnWidth(2),
                            3: const FlexColumnWidth(3),
                            4: FlexColumnWidth((Session.getUserType() == UserType.VENDOR.name) ? 2.5 : 0.001),
                            5: const FlexColumnWidth(2),
                            6: const FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              children: [

                                /// Country name
                                // TableChildTextWidget(text: packageData?.packages?.name ?? ''),
                                // TableChildTextWidget(text:'${dateFormatFromDateTime((packageData?.startDate?.milliSecondsToDateTime()),'dd/MM/yyyy hh:mm:ss')}'
                                //     ' To ${dateFormatFromDateTime((packageData?.endDate?.milliSecondsToDateTime()),'dd/MM/yyyy hh:mm:ss')}'),
                                TableChildTextWidget(text:'${millisecondToUtcDateTime(packageData?.startDate??0,dateFormat)}'
                                    ' To ${millisecondToUtcDateTime(packageData?.endDate??0,dateFormat)}'),
                                // TableChildTextWidget(text:DateTime.fromMillisecondsSinceEpoch(packageData?.createdAt ?? 0).timeOnly,),
                                TableChildTextWidget(text: '${packageData?.currency ?? ''} ${packageData?.dailyBudget?.toString() ?? ''}',),
                                TableChildTextWidget(text:'${packageData?.currency ?? ''} ${packageData?.budget?.toString() ?? ''}' ),
                                TableChildTextWidget(text:packageData?.destinationName ?? '' ),
                                (Session.getUserType() == UserType.VENDOR.name) ? TableChildTextWidget(text:packageData?.purchaseByName ?? '' ) : const Offstage(),
                                Container(
                                  decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(16.r)
                                  ),
                                  child: Center(
                                    child: CommonText(
                                      title:  packageData?.status ?? '' ,
                                      textStyle: TextStyles.regular.copyWith(
                                          fontSize: 12.sp,
                                          color: textColor,
                                      ),

                                    ),
                                  ).paddingSymmetric(vertical: context.height*0.008,horizontal: context.width*0.012),
                                ),
                                Align(
                                  alignment: Session.isRTL ? Alignment. topLeft: Alignment.topRight,
                                  child: InkWell(
                                      onTap: (){
                                        ref.read(navigationStackController).push(NavigationStackItem.packageWalletDetail(packageUuid: packageData?.uuid??''));
                                      },
                                      child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName, width: context.width * 0.045, height: context.height * 0.045,isRotate: true,)),
                                )
                              ],
                            ),
                          ],
                        ).paddingOnly(top: context.height*0.03, bottom: context.height*0.03,left: context.width*0.012,right: context.width*0.018),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 25.h);
                    },
                  )
                      : SizedBox(
                        height: context.height * 0.6,
                        child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    EmptyStateWidget(
                                        imgName: Assets.svgs.svgNoData.keyName,
                                        title: LocaleKeys.keyNoDataFound.localized)
                                  ],
                                ),
                      ),
                        DialogProgressBar(isLoading: packageWatch.packageListState.isLoadMore, forPagination: true,)

                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}
