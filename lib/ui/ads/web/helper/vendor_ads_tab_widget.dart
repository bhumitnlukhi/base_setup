import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_cupertino_switch.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_list_tile.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_child_text_widget_master.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class VendorAdsTabWidget extends ConsumerWidget with BaseConsumerWidget {
  const VendorAdsTabWidget({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final adsWatch = ref.watch(adsController);
    final storesWatch = ref.watch(storesController);

    return Column(
      children: [
        CommonBackTopWidget(
          title: '${storesWatch.storeDetailsLanguageState.success?.data?.name ?? ''} Store\'s ads',
          onTap: () async {
            final selectStoreWatch = ref.watch(selectStoreController);
            ref.read(navigationStackController).pop();
            selectStoreWatch.disposeController(isNotify : true);
            adsWatch.disposeController(isNotify: true);
            await selectStoreWatch.storeListApi(context, false, destinationUuid: '', dataSize: pageCount, isAdsAvailable: true).then((value){
              if(selectStoreWatch.storeListState.success?.status == ApiEndPoints.apiStatus_200){
                adsWatch.updateStoreList(selectStoreWatch.storeListState.success?.data ?? []);
              }
            });
          },
        ).paddingOnly(bottom: context.height * 0.050),

        /// common top widget
        // FadeBoxTransition(
        //   child: CommonTopRowWeb(
        //     masterTitle: storeName,
        //     searchController: adsWatch.searchCtr,
        //     searchPlaceHolder: LocaleKeys.keySearch.localized,
        //     buttonText: LocaleKeys.keyCreateAds.localized,
        //     onChanged: (value){
        //       adsWatch.onSearchChanged(value, context);
        //
        //     },
        //     showSearchBar: adsWatch.isSelectedOwnAds == true ? false : true,
        //     extraSpace: context.width*0.048,
        //     showExport: false,
        //     showImport: false,
        //     onCreateTap: (){
        //       ref.read(navigationStackController).push(const NavigationStackItem.addEditAds());
        //     },
        //     // onExportTap: (){},
        //     // onImportTap: (){
        //     //   showCommonWebDialog(
        //     //     keyBadge: adsWatch.importDialogKey,
        //     //       context: context,
        //     //       width: 0.45,
        //     //       height: 0.52,
        //     //       dialogBody: CommonImportDialogWeb(title: LocaleKeys.keyAds.localized,));
        //     // },
        //   ).paddingOnly(bottom: context.height * 0.040),
        // ),

        /// ads list header
        Table(
            textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
            /// status
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(2),

            /// store/agency name
            3: FlexColumnWidth(3),

            /// type
            4: FlexColumnWidth(3),

            /// destination name
            5: FlexColumnWidth(3),

            /// date
            6: FlexColumnWidth(1.5),

            /// delete
            7: FlexColumnWidth(2),
            8: FlexColumnWidth(1.5),
            9: FlexColumnWidth(2),
          },
          children: [
            TableRow(children: [
              // TableHeaderTextWidget(text: LocaleKeys.keyDefault.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyStatus.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyAdsId.localized),
              // TableHeaderTextWidget(text: LocaleKeys.keyStoreAgencyName.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyStoreName.localized),
              // TableHeaderTextWidget(text: LocaleKeys.keyDestinationName.localized),
              Row(
                children: [
                  TableHeaderTextWidget(text: LocaleKeys.keyDestinationName.localized),
                  // SizedBox(width: 10.w),
                  // DestinationFilterWidget(
                  //     selectedDestination: adsWatch.selectedDestinationData,
                  //     // layerLink: packageWatch.link,
                  //     // overlayPortalController: packageWatch.tooltipController,
                  //     onTap: () async {
                  //       adsWatch.disposeApiData();
                  //
                  //       await adsWatch.adsListApi(context, false, vendorUuid: Session.getUuid(), storeUuid: storesWatch.storeDetailsState.success?.data?.uuid??'',);
                  //
                  //     })
                ],
              ),
              TableHeaderTextWidget(text: LocaleKeys.keyMediaType.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyAdStatus.localized),
              const TableHeaderTextWidget(text: ''),
              TableHeaderTextWidget(text: LocaleKeys.keyReason.localized),
              const TableHeaderTextWidget(text: ''),

              adsWatch.isFilterApplied()
                  ? InkWell(
                      onTap: () async {
                        adsWatch.clearFilters(context);
                        if (storesWatch.tooltipDestinationController?.isShowing ?? false) {
                          storesWatch.tooltipDestinationController?.toggle();
                        }
                        // print("storeListData?.odigoStoreName??''");
                        // print(storeListData?.odigoStoreName??'');
                        // print(storeListData?.odigoStoreUuid??'');
                        await adsWatch.adsListApi(context, false, vendorUuid: Session.getUuid(), storeUuid: storesWatch.storeDetailsLanguageState.success?.data?.uuid ?? '');
                      },
                      child: CommonText(
                        title: LocaleKeys.keyClearFilters.localized,
                        textAlign: TextAlign.right,
                        textStyle: TextStyles.medium.copyWith(color: AppColors.clr009AF1, decoration: TextDecoration.underline),
                      ),
                    )
                  : const Offstage(),
            ]),
          ],
        ).paddingOnly(bottom: context.height * 0.022, left: context.width * 0.007),

        /// ads listing
        adsWatch.adsListState.isLoading
            ? const Expanded(child: CommonListShimmer())
            : Expanded(
                child: adsWatch.adsListState.isLoading
                    ? const Expanded(child: CommonListShimmer())
                    : adsWatch.adsList.isEmpty
                        ? EmptyStateWidget(
                            imgName: Assets.svgs.svgNoData.keyName,
                            title: LocaleKeys.keyNoDataFound.localized,
                          )
                        : FadeBoxTransition(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: adsWatch.adsList.length,
                              controller: adsWatch.vendorAdsCtr,
                              itemBuilder: (context, index) {
                                final data = adsWatch.adsList[index];
                                var (bgColor, textColor) = getAllStatusColor(data?.status);
                                return CommonListTile(
                                  childWidget: Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                                    columnWidths: const {
                                      /// status
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(4),
                                      2: FlexColumnWidth(2),

                                      /// store/agency name
                                      3: FlexColumnWidth(3),

                                      /// type
                                      4: FlexColumnWidth(3),

                                      /// destination name
                                      5: FlexColumnWidth(3),

                                      /// date
                                      6: FlexColumnWidth(1.5),

                                      /// delete
                                      7: FlexColumnWidth(2),

                                      /// detail
                                      8: FlexColumnWidth(1.5),
                                      9: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(children: [
                                          (data?.status != 'PENDING' && data?.status != 'REJECTED')
                                              ? Align(
                                                alignment: Alignment.centerLeft,
                                                child: (adsWatch.changeStatusOfAdState.isLoading && adsWatch.updatingAdStatusIndex == index)
                                                    ? LoadingAnimationWidget.waveDots(color: AppColors.black, size: 22.h).alignAtCenterLeft().paddingOnly(left: context.width * 0.006)
                                                    : CommonCupertinoSwitch(
                                                        switchValue: data?.active ?? false,
                                                        onChanged: (val) async {
                                                          await adsWatch.changeStatusOfAdApi(context, adUuid: data?.uuid ?? '', status: data?.active == true ? "INACTIVE" : "ACTIVE").then((value) {});
                                                          if(context.mounted){
                                                            await adsWatch.adsListApi(
                                                                context, false,
                                                                vendorUuid: Session
                                                                    .getUuid(),
                                                                storeUuid: storesWatch
                                                                        .storeDetailsLanguageState
                                                                        .success
                                                                        ?.data
                                                                        ?.uuid ??
                                                                    '');
                                                          }
                                                        },
                                                      ),
                                              )
                                            : const SizedBox(),
                                        TableChildTextWidget(text: data?.uuid ?? ''),
                                        TableChildTextWidget(text: data?.adsByName ?? ''),
                                        TableChildTextWidget(text: data?.destinationName ?? ''),
                                        // TableChildTextWidget(text: DateTime.fromMillisecondsSinceEpoch(data?.createdAt ?? 0).dateOnly),
                                        TableChildTextWidget(text: data?.adsMediaType ?? ''),
                                        Container(
                                          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16.r)),
                                          child: Center(
                                            child: CommonText(
                                              title: data?.status ?? '',
                                              textStyle: TextStyles.regular.copyWith(
                                                fontSize: 12.sp,
                                                color: textColor,
                                              ),
                                            ),
                                          ).paddingSymmetric(vertical: context.height * 0.008, horizontal: context.width * 0.012),
                                        ).paddingOnly(right: context.width * 0.02),
                                        TableChildTextWidget(
                                          text: data?.isDefault == true
                                                  ? LocaleKeys.keyDefault.localized
                                                  : '',
                                          textStyle: TextStyles.regular.copyWith(color: (data?.isDefault == false && data?.rejectReason != null) ? AppColors.clrEB1F1F : AppColors.orangeEE7700),
                                        ),
                                        TableChildTextWidget(
                                          text: data?.rejectReason ?? '',
                                          textStyle: TextStyles.regular.copyWith(color: (data?.isDefault == false && data?.rejectReason != null) ? AppColors.clrEB1F1F : AppColors.orangeEE7700),
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              showConfirmationDialogWeb(
                                                context: context,
                                                title: LocaleKeys.keyAreYouSure.localized,
                                                message: LocaleKeys.keyAreYouSureYouWantToDeleteThisAd.localized,
                                                dialogWidth: context.width * 0.3,
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  await adsWatch.archiveAdApi(context, adUuid: data?.uuid ?? '');
                                                },
                                              );
                                            },
                                            child: Visibility(visible: data?.isDefault != true, child: (adsWatch.archiveAdState.isLoading && adsWatch.updateDeleteIndex == index) ? LoadingAnimationWidget.waveDots(color: AppColors.black, size: 22.h).alignAtCenter() : CommonSVG(strIcon: Assets.svgs.svgDelete.keyName, width: context.width * 0.030, height: context.height * 0.030))),

                                        /// details
                                        InkWell(
                                            onTap: () {
                                              ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adUuid: data?.uuid ?? ''));
                                            },
                                            child: Align(alignment: Alignment.centerRight, child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName, width: context.width * 0.045, height: context.height * 0.045,isRotate: true,).paddingOnly(right: context.width * 0.020))),
                                      ]),
                                    ],
                                  ).paddingOnly(top: 10.h, bottom: 10.h),
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
        DialogProgressBar(
          isLoading: adsWatch.adsListState.isLoadMore,
          forPagination: true,
        )
      ],
    );
  }
}
