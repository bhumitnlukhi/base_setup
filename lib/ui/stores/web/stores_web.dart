import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/stores/web/helper/destination_filter_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_cupertino_switch.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_list_tile.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_row_web.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_child_text_widget_master.dart';

class StoresWeb extends ConsumerStatefulWidget {
  const StoresWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<StoresWeb> createState() => _StoresWebState();
}

class _StoresWebState extends ConsumerState<StoresWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final storesWatch = ref.watch(storesController);
      storesWatch.disposeController(isNotify: true);
      storesWatch.storeSearchCtr.clear();
      await storesWatch.storeListApiCall(context);
      // storesWatch.tooltipController.hide();
      if(mounted){
        await storesWatch.destinationListApiCall(context,
            pageSize: pageSize100000);
      }
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final storesWatch = ref.watch(storesController);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (storesWatch.tooltipDestinationController?.isShowing ?? false) {
              storesWatch.tooltipDestinationController?.hide();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// common top widget
                FadeBoxTransition(
                  child: CommonTopRowWeb(
                    masterTitle: LocaleKeys.keyStores.localized,
                    searchController: storesWatch.storeSearchCtr,
                    searchPlaceHolder: LocaleKeys.keySearchStoreName.localized,
                    onChanged: (value) {
                      EasyDebounce.debounce(searchStoreDebounce, const Duration(milliseconds: searchDebounceTime), () {
                        storesWatch.storeListApiCall(context);
                      });
                    },
                    onCreateTap: () {
                      ref.read(navigationStackController).push(const NavigationStackItem.addEditStore());
                    },
                    showExport: false,
                    showImport: false,
                    onClearSearch: () async {
                      storesWatch.clearSearchCtr();
                      await storesWatch.storeListApiCall(context);
                    },
                  ).paddingOnly(bottom: context.height * 0.040),
                ),

                /// store listing widget
                /// store list header
                Table(
                  textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  columnWidths: const {
                    /// status
                    0: FlexColumnWidth(1),

                    /// store name
                    1: FlexColumnWidth(2),

                    /// category name
                    2: FlexColumnWidth(4),

                    /// Destination
                    3: FlexColumnWidth(3.0),

                    /// Uuid
                    4: FlexColumnWidth(2.0),

                    /// approval-status
                    5: FlexColumnWidth(1.5),

                    /// detail
                    6: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableHeaderTextWidget(text: LocaleKeys.keyStatus.localized),
                        TableHeaderTextWidget(text: LocaleKeys.keyStoreName.localized),
                        TableHeaderTextWidget(text: LocaleKeys.keyCategory.localized),
                        Row(
                          children: [
                            TableHeaderTextWidget(text: storesWatch.selectedDestination != null ? (storesWatch.selectedDestination?.name ?? '') : LocaleKeys.keyDestinations.localized),
                            SizedBox(width: 10.w),
                            // DestinationFilterWidget(onTap: => storesWatch.storeListApiCall(context)),
                            DestinationFilterWidget(
                              selectedDestination: storesWatch.selectedDestination,
                              // layerLink: storesWatch.link,
                              //   overlayPortalController: storesWatch.tooltipController,
                                onTap:   (){
                                  storesWatch.storeListApiCall(context);
                            }),
                          ],
                        ),
                        TableHeaderTextWidget(text: LocaleKeys.keyStoreUuid.localized),
                        TableHeaderTextWidget(text: LocaleKeys.keyStoreStatus.localized),
                        storesWatch.isFilterApplied()
                            ? InkWell(
                                onTap: () {
                                  storesWatch.clearFilters(context);
                                  if (storesWatch.tooltipDestinationController?.isShowing ?? false) {
                                    storesWatch.tooltipDestinationController?.hide();
                                  }
                                },
                                child: CommonText(
                                  title: LocaleKeys.keyClearFilters.localized,
                                  textStyle: TextStyles.medium.copyWith(color: AppColors.clr009AF1, decoration: TextDecoration.underline),
                                ),
                              )
                            : const Offstage(),
                      ],
                    ),
                  ],
                ).paddingOnly(bottom: context.height * 0.022, left: context.width * 0.007),

                /// store listing
                (storesWatch.storeListState.isLoading )
                    ? const Expanded(child: CommonListShimmer())
                    : Expanded(
                        child: FadeBoxTransition(
                          child: (storesWatch.storeList.isNotEmpty)
                              ? Column(
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: storesWatch.storeList.length,
                                        controller: storesWatch.storeScrollController,
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          StoreListData? storeData = storesWatch.storeList[index];
                                          return storeData == null
                                              ? const Offstage()
                                              : CommonListTile(
                                                  childWidget: Table(
                                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                    textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                                                    columnWidths: const {
                                                      /// status
                                                      0: FlexColumnWidth(1),

                                                      /// store name
                                                      1: FlexColumnWidth(2),

                                                      /// category name
                                                      2: FlexColumnWidth(4),

                                                      /// Destination
                                                      3: FlexColumnWidth(3.0),

                                                      /// Uuid
                                                      4: FlexColumnWidth(2.0),

                                                      /// approval-status
                                                      5: FlexColumnWidth(1.5),

                                                      /// detail
                                                      6: FlexColumnWidth(1),
                                                    },
                                                    children: [
                                                      TableRow(
                                                        children: [
                                                          (storeData.status == 'ACTIVE' || storeData.status == 'INACTIVE')
                                                              ? Align(
                                                                  alignment: Alignment.center,
                                                                  child: storesWatch.updateStoreStatusState.isLoading && storesWatch.updatingStoreIndex == index
                                                                      ? Center(
                                                                          child: LoadingAnimationWidget.waveDots(
                                                                            color: AppColors.black,
                                                                            size: 22.h,
                                                                          ).alignAtCenterLeft().paddingOnly(left: 10.w),
                                                                        )
                                                                      : CommonCupertinoSwitch(
                                                                          switchValue: storeData.status == 'ACTIVE',
                                                                          onChanged: (val) {
                                                                            ///API for update status
                                                                            storesWatch.updateStoreStatusApi(context, storeUuid: storeData.uuid ?? '', status: storeData.status ?? '', updatingStoreIndex: index);
                                                                          },
                                                                        ),
                                                                )
                                                              : const Offstage(),
                                                          TableChildTextWidget(
                                                            text: storeData.odigoStoreName ?? ''
                                                          ),
                                                          TableChildTextWidget(
                                                            text: storeData.businessCategoryLanguageResponseDtOs?.map((e) => e.name).join(', ')??'',
                                                          ),
                                                          TableChildTextWidget(
                                                            text:  storeData.destinationName ?? '',
                                                          ),
                                                          TableChildTextWidget(
                                                            text:  storeData.uuid ?? '',
                                                          ).paddingOnly(right: 10.w),

                                                          Builder(
                                                            builder: (context) {
                                                              var (bgColor, textColor) = storesWatch.getStatusColor(storeData.status);
                                                              return Container(
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(45.r),
                                                                  color: bgColor,
                                                                ),
                                                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                                                child: CommonText(
                                                                  title: storeData.status ?? '',
                                                                  textStyle: TextStyles.regular.copyWith(fontSize: 12.sp, color: textColor),
                                                                ),
                                                              );
                                                            },
                                                          ),

                                                          /// details
                                                          InkWell(
                                                            onTap: () {
                                                              ref.read(navigationStackController).pushRemove(NavigationStackItem.stores(storeUuid: storeData.uuid));
                                                              if (storeData.uuid != null) {
                                                                storesWatch.showStoreDetailsDialog(context, ref, storeUuid: storeData.uuid!);
                                                              }
                                                            },
                                                            child: CommonSVG(strIcon: Assets.svgs.svgForwardArrow.keyName, width: context.width * 0.045, height: context.height * 0.045,isRotate: true,),
                                                          )
                                                        ],
                                                      ),
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
                                  DialogProgressBar(isLoading: storesWatch.storeListState.isLoadMore, forPagination: true,)
                                ],
                              )
                              : Center(
                                  child: EmptyStateWidget(
                                    imgName: Assets.svgs.svgNoData.path,
                                    title: '${LocaleKeys.keyNoStoresFound.localized}${storesWatch.selectedDestination != null ? ' ${LocaleKeys.keyAt.localized} ${storesWatch.selectedDestination?.name}' : ''}',
                                  ),
                                ),
                        ),
                      )
              ],
            ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
          ).paddingAll(context.height * 0.025),
        ),
        DialogProgressBar(isLoading: storesWatch.storeDetailsState.isLoading),
      ],
    );
  }
}
