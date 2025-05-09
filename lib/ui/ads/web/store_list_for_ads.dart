import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
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

class StoreListForAdsWidget extends ConsumerWidget with BaseConsumerWidget {
  const StoreListForAdsWidget({super.key});

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final selectStoreWatch = ref.watch(selectStoreController);
    final adWatch = ref.watch(adsController);
    // final storeListWatch = ref.watch(storeListController);

    return Column(
      children: [
        /// ads list header
        Table(
          textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
            /// status
            0: FlexColumnWidth(0.1),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(3),
            3: FlexColumnWidth(4),

            /// store/agency name
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),

          },
          children: [
            TableRow(children: [
              // TableHeaderTextWidget(text: LocaleKeys.keyDefault.localized),
              const Offstage(),
              TableHeaderTextWidget(text: LocaleKeys.keyStoreName.localized),
              Row(
                children: [
                  Expanded(child: TableHeaderTextWidget(text: adWatch.selectedDestinationData != null ? (adWatch.selectedDestinationData?.name ?? '') :LocaleKeys.keyDestinationName.localized)),
                  DestinationFilterWidget(
                      selectedDestination: adWatch.selectedDestinationData,
                      // layerLink: packageWatch.link,
                      // overlayPortalController: packageWatch.tooltipController,
                      onTap: () async {
                        adWatch.disposeApiData();
                        await selectStoreWatch.storeListApi(context, true, destinationUuid: adWatch.selectedDestinationData?.uuid ?? '', dataSize: pageCount, isAdsAvailable: true).then(
                          (value) {
                            if(value.success?.status == ApiEndPoints.apiStatus_200){
                              adWatch.replaceStoreData(selectStoreWatch.storeListState.success?.data ?? []);

                            }
                          },
                        );
                      })
                ],
              ).paddingOnly(right: 10.w),
              TableHeaderTextWidget(text: LocaleKeys.keyAdsCount.localized),
              const Offstage(),
              adWatch.selectedDestinationData != null
                  ? InkWell(
                onTap: () async {
                  final storeWatch = ref.watch(storesController);
                  adWatch.clearFilters(context);
                  await selectStoreWatch.storeListApi(context, true, destinationUuid: '', dataSize: pageCount, isAdsAvailable: true).then((value) {
                    if(value.success?.status == ApiEndPoints.apiStatus_200){
                      adWatch.replaceStoreData(selectStoreWatch.storeListState.success?.data ?? []);

                    }
                  },);
                  if (storeWatch.tooltipDestinationController?.isShowing ?? false) {
                    storeWatch.tooltipDestinationController?.toggle();
                  }
                },
                child: CommonText(
                  title: LocaleKeys.keyClearFilters.localized,
                  textAlign: TextAlign.left,
                  textStyle: TextStyles.medium.copyWith(color: AppColors.clr009AF1, decoration: TextDecoration.underline),
                ),
              )
                  : const Offstage(),
              // TableHeaderTextWidget(text: LocaleKeys.keyDestinationName.localized),
            ]),
          ],
        ).paddingOnly(bottom: context.height * 0.022, left: context.width * 0.007),

        /// ads listing
        selectStoreWatch.storeListState.isLoading ? const Expanded(child: CommonListShimmer()) :
        Expanded(
          child: selectStoreWatch.storeListState.isLoading?
          const Expanded(child: CommonListShimmer()):
          adWatch.storeList.isEmpty?
          EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized,):
          FadeBoxTransition(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: adWatch.storeList.length,
              controller: adWatch.storeScrollCtr,
              itemBuilder: (context, index) {

                final data = adWatch.storeList[index];
                return CommonListTile(
                  childWidget:
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                    columnWidths: const {
                      /// status
                      0: FlexColumnWidth(0.1),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(4),

                      /// store/agency name
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),


                    },
                    children: [
                      TableRow(children: [
                        const Offstage(),
                        TableChildTextWidget(text: data?.odigoStoreName??'').paddingSymmetric(horizontal: 5.w),
                        TableChildTextWidget(text: data?.destinationName??'').paddingOnly(right: 10.w),
                        TableChildTextWidget(text: (data?.adsCount??'').toString()),

                        const Offstage(),
                        /// details
                        InkWell(
                            onTap: () {
                              ref.read(navigationStackController).push( NavigationStackItem.vendorAdList( id: data?.odigoStoreUuid??'',destinationUuid: data?.destinationUuid));
                            },
                            child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName,  width: context.width * 0.045, height: context.height * 0.045,isRotate: true,)),


                      ]),
                    ],
                  ).paddingOnly( top: 10.h, bottom: 10.h),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 25.h,
                );
              },
            ),
          ),
        ),
        DialogProgressBar(isLoading: selectStoreWatch.storeListState.isLoadMore, forPagination: true,)

      ],
    );
  }
}
