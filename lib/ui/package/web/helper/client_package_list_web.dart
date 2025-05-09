import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/int_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/stores/web/helper/destination_filter_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
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

class ClientPackageListWeb extends ConsumerWidget with BaseConsumerWidget {
  const ClientPackageListWeb({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final packageWatch = ref.watch(packageController);
    final storesWatch = ref.watch(storesController);
    return Column(
      children: [
        /// Header
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
            ///  Client  name
            0: FlexColumnWidth(1.5),

            /// Package name
            1: FlexColumnWidth(3),

            /// Purchase date
            2: FlexColumnWidth(2),

            /// Package date
            3: FlexColumnWidth(2),

            /// Package date
            4: FlexColumnWidth(3),

            ///Pricing
            5: FlexColumnWidth(1.5),
            6: FlexColumnWidth(1.5),

            /// Space
            // 6: FlexColumnWidth(1.2),
          },
          children: [
            TableRow(
              children: [
                // TableHeaderTextWidget(text: LocaleKeys.keyDestinationName.localized,),
                TableHeaderTextWidget(
                  text: LocaleKeys.keyClientName.localized,
                ),
                // TableHeaderTextWidget(text:LocaleKeys.keyPackageName.localized,),
                TableHeaderTextWidget(
                  text: LocaleKeys.keyPackageDuration.localized,
                ),
                TableHeaderTextWidget(text: LocaleKeys.keyDailyBudget.localized),
                TableHeaderTextWidget(text: LocaleKeys.keyBudget.localized),
                Row(
                  children: [
                    TableHeaderTextWidget(text: packageWatch.destinationData != null ? (packageWatch.destinationData?.name ?? '') : LocaleKeys.keyDestinationName.localized),
                    SizedBox(width: 10.w),
                    DestinationFilterWidget(
                        selectedDestination: packageWatch.destinationData,
                        // layerLink: packageWatch.link,
                        // overlayPortalController: packageWatch.tooltipController,
                        // packageWatch.di
                        onTap: () async {
                          packageWatch.clearData();
                          await packageWatch.packageListApi(context, false);
                        })
                  ],
                ),
                TableHeaderTextWidget(text: LocaleKeys.keyStatus.localized),
                packageWatch.isFilterApplied()
                    ? InkWell(
                        onTap: () async {
                          packageWatch.clearFilters(context);
                          if (storesWatch.tooltipDestinationController?.isShowing ?? false) {
                            storesWatch.tooltipDestinationController?.toggle();
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
        ).paddingLTRB(context.width * 0.020, context.width * 0.02, context.width * 0.02, context.width * 0.006),

        /// List
        packageWatch.packageListState.isLoading
            ? const Expanded(child: CommonListShimmer())
            : packageWatch.packageList.isEmpty
                ? Expanded(
                    child: Center(
                        child: EmptyStateWidget(
                    imgName: Assets.svgs.svgNoData.keyName,
                    title: LocaleKeys.keyNoDataFound.localized,
                  )))
                : Expanded(
                    child: FadeBoxTransition(
                      child: SingleChildScrollView(
                        controller: packageWatch.packageScrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: packageWatch.packageList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var packageData = packageWatch.packageList[index];
                                var (bgColor, textColor) = getAllStatusColor(packageData?.status);
                                return CommonListTile(
                                  childWidget: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                                    columnWidths: const {
                                      ///  Client  name
                                      0: FlexColumnWidth(1.5),

                                      /// Package name
                                      1: FlexColumnWidth(3),

                                      /// Purchase date
                                      2: FlexColumnWidth(2),

                                      /// Package date
                                      3: FlexColumnWidth(2),

                                      /// Package date
                                      4: FlexColumnWidth(3),

                                      ///Pricing
                                      5: FlexColumnWidth(1.5),
                                      6: FlexColumnWidth(1.5),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          /// Country name
                                          // TableChildTextWidget(text:packageData?.packages?.destinationName ?? ''),
                                          // TableChildTextWidget(text:packageData?.purchaseByName ?? ''),
                                          TableChildTextWidget(text: packageData?.purchaseByName ?? ''),
                                          TableChildTextWidget(
                                              text: '${dateFormatFromDateTime((packageData?.startDate?.milliSecondsToDateTime()), dateFormat)}'
                                                  ' To ${dateFormatFromDateTime((packageData?.endDate?.milliSecondsToDateTime()), dateFormat)}'),
                                          // TableChildTextWidget(text:dateFormatFromDateTime((packageData?.createdAt?.milliSecondsToDateTime()),'hh:mm a')),
                                          TableChildTextWidget(text: '${packageData?.currency ?? ''} ${packageData?.dailyBudget?.toString() ?? ''}'),
                                          TableChildTextWidget(text: '${packageData?.currency ?? ''} ${packageData?.budget?.toString() ?? ''}'),

                                          TableChildTextWidget(text: packageData?.destinationName ?? ''),
                                          Container(
                                            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16.r)),
                                            child: Center(
                                              child: CommonText(
                                                title: packageData?.status ?? '',
                                                textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: textColor),
                                              ),
                                            ).paddingSymmetric(vertical: context.height * 0.008, horizontal: context.width * 0.012),
                                          ),
                                          // TableChildTextWidget(text:getStatusColor(true, packageData?.status ?? '' )),
                                          Align(
                                            alignment: Session.isRTL ? Alignment. topLeft: Alignment.topRight,
                                            child: InkWell(
                                                onTap: () {
                                                  ref.read(navigationStackController).push(NavigationStackItem.packageWalletDetail(packageUuid: packageData?.uuid ?? '', clientMasterUuid: packageData?.purchaseByUuid ?? ''));
                                                },
                                                child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName, width: context.width * 0.045, height: context.height * 0.045,isRotate: true,)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ).paddingOnly(top: context.height * 0.03, bottom: context.height * 0.03, left: context.width * 0.014, right: context.width * 0.02),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 25.h,
                                );
                              },
                            ),
                            DialogProgressBar(
                              isLoading: packageWatch.packageListState.isLoadMore,
                              forPagination: true,
                            )
                            // /// Load more
                            // countryWatch.countryListState.isLoadMore
                            //     ? Center(child: const CircularProgressIndicator(color: AppColors.black171717,).paddingOnly(top: 10.h))
                            //     : const Offstage(),
                          ],
                        ),
                      ),
                    ),
                  ),
      ],
    );
  }
}
