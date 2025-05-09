import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/ads/web/helper/agency_ads_tab_widget.dart';
import 'package:odigo_vendor/ui/ads/web/store_list_for_ads.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_row_web.dart';

class AdsWeb extends ConsumerStatefulWidget {
  final int? tabIndex;
  const AdsWeb({Key? key,this.tabIndex}) : super(key: key);

  @override
  ConsumerState<AdsWeb> createState() => _AdsWebState();
}

class _AdsWebState extends ConsumerState<AdsWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final adsWatch = ref.watch(adsController);
      final storesWatch = ref.watch(storesController);
      final selectClientWatch = ref.watch(selectClientController);
      selectClientWatch.disposeController(isNotify : true);
      adsWatch.disposeController(isNotify : true);
      adsWatch.searchCtr.clear();

      // if(Session.getUserType() == UserType.VENDOR.name){
      //   adsWatch.adsListApi(context, false, vendorUuid: Session.getUuid());
      // }
       if((Session.getUserType() == UserType.AGENCY.name)) {

        // if(widget.tabIndex!=null){
          if(widget.tabIndex ==0){
            adsWatch.updateAgencyOwnAds(true);
          }else{
            adsWatch.updateAgencyOwnAds(false);
          }

        // }
        if(adsWatch.isSelectedOwnAds){
          adsWatch.adsListApi(context, false, agencyUuid: Session.getUuid());
        } else {

          await selectClientWatch.clientListApi(context, false, isAdsAvailable: true).then((value){
            if(selectClientWatch.clientListState.success?.status == ApiEndPoints.apiStatus_200){
              adsWatch.updateClientList(selectClientWatch.clientListState.success?.data ?? []);
            }
          });

          selectClientWatch.scrollController.addListener(() async{
            if (selectClientWatch.clientListState.success?.hasNextPage == true) {
              if (selectClientWatch.scrollController.position.maxScrollExtent == selectClientWatch.scrollController.position.pixels) {
                if(!selectClientWatch.clientListState.isLoadMore) {
                  await selectClientWatch.clientListApi(context,true, isAdsAvailable: true).then((value){
                    if(selectClientWatch.clientListState.success?.status == ApiEndPoints.apiStatus_200){
                      adsWatch.updateClientList(selectClientWatch.clientListState.success?.data ?? []);
                    }
                  });
                }
              }
            }
          });
          // adsWatch.adsListApi(context, false, isGetOnlyClient: true);
        }
          if(mounted){
            await storesWatch.destinationListApi(context, pageSize: pageSize100000, hasAds: true, activeRecords: true);

            // await storesWatch.destinationListApiCall(context, pageSize: pageSize100000);
          }

       } else{
         // final storeListWatch = ref.watch(storeListController);
         final adWatch = ref.watch(adsController);
         final selectStoreWatch = ref.watch(selectStoreController);
         selectStoreWatch.disposeController(isNotify : true);
         adWatch.disposeController(isNotify: true);
         await selectStoreWatch.storeListApi(context, false, destinationUuid: '', dataSize: pageCount, isAdsAvailable: true).then((value){
           if(selectStoreWatch.storeListState.success?.status == ApiEndPoints.apiStatus_200){
             adWatch.updateStoreList(selectStoreWatch.storeListState.success?.data ?? []);
           }
         });
         if(mounted){
           await storesWatch.destinationListApi(context, pageSize: pageSize100000, hasAds: true, activeRecords: true);
         }
         adWatch.storeScrollCtr.addListener(() async{
           if (selectStoreWatch.storeListState.success?.hasNextPage == true) {
             if (adWatch.storeScrollCtr.position.maxScrollExtent == adWatch.storeScrollCtr.position.pixels) {
               if(!selectStoreWatch.storeListState.isLoadMore) {
                 await selectStoreWatch.storeListApi(context, true, destinationUuid: '', dataSize: pageCount, isAdsAvailable: true).then((value){
                   if(selectStoreWatch.storeListState.success?.status == ApiEndPoints.apiStatus_200){
                     adWatch.updateStoreList(selectStoreWatch.storeListState.success?.data ?? []);
                   }
                 });
               }
             }
           }
         });

       }
      // storesWatch.disposeController(isNotify: true);
      // adsWatch.vendorAdsCtr.addListener(() async{
      //   if (adsWatch.adsListState.success?.hasNextPage == true) {
      //     if (adsWatch.vendorAdsCtr.position.maxScrollExtent == adsWatch.vendorAdsCtr.position.pixels) {
      //       if(!adsWatch.adsListState.isLoadMore) {
      //         adsWatch.adsListApi(context, true, vendorUuid: Session.getUuid());
      //       }
      //     }
      //   }
      // });
      //
      // adsWatch.agentAdsCtr.addListener(() async{
      //   if (adsWatch.adsListState.success?.hasNextPage == true) {
      //     if (adsWatch.agentAdsCtr.position.maxScrollExtent == adsWatch.agentAdsCtr.position.pixels) {
      //       if(!adsWatch.adsListState.isLoadMore) {
      //         adsWatch.adsListApi(context, true, agencyUuid: Session.getUuid());
      //       }
      //     }
      //   }
      // });
      //
      // adsWatch.clientAdsCtr.addListener(() async{
      //   if (adsWatch.adsListState.success?.hasNextPage == true) {
      //     if (adsWatch.clientAdsCtr.position.maxScrollExtent == adsWatch.clientAdsCtr.position.pixels) {
      //       if(!adsWatch.adsListState.isLoadMore) {
      //         adsWatch.adsListApi(context, true, isGetOnlyClient: true);
      //       }
      //     }
      //   }
      // });

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
    final adsWatch = ref.watch(adsController);
    final selectClientWatch = ref.watch(selectClientController);
    final storeWatch = ref.watch(storesController);

    return Stack(
      children: [

        InkWell(
          onTap: () {
            if(storeWatch.tooltipDestinationController?.isShowing ?? false){
              storeWatch.tooltipDestinationController?.toggle();
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
                    masterTitle: LocaleKeys.keyAds.localized,
                    searchController: adsWatch.searchCtr,
                    searchPlaceHolder: LocaleKeys.keySearchClientName.localized,
                    buttonText: LocaleKeys.keyCreateAds.localized,
                    onChanged: (value){
                      onSearchChanged(value, context);

                    },
                    onClearSearch: () async {
                      adsWatch.clientDataList = [];
                      await selectClientWatch.clientListApi(context, false, isAdsAvailable: true, searchText: '').then((value){
                        if(selectClientWatch.clientListState.success?.status == ApiEndPoints.apiStatus_200){
                          adsWatch.updateClientList(selectClientWatch.clientListState.success?.data ?? []);
                        }
                      });
                    },
                    showSearchBar: adsWatch.isSelectedOwnAds == true ? false : true,
                    extraSpace: context.width*0.048,
                    showExport: false,
                    showImport: false,
                    onCreateTap: (){
                      ref.read(navigationStackController).push(const NavigationStackItem.addEditAds());
                    },
                    // onExportTap: (){},
                    // onImportTap: (){
                    //   showCommonWebDialog(
                    //     keyBadge: adsWatch.importDialogKey,
                    //       context: context,
                    //       width: 0.45,
                    //       height: 0.52,
                    //       dialogBody: CommonImportDialogWeb(title: LocaleKeys.keyAds.localized,));
                    // },
                  ).paddingOnly(bottom: context.height * 0.040),
                ),


                Expanded(child: Session.getUserType() == UserType.AGENCY.name ? const AgencyAdsTabWidget() : const StoreListForAdsWidget()/*const VendorAdsTabWidget()*/)

              ],
            ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
          ).paddingAll(context.height*0.025),
        ),
        // DialogProgressBar(isLoading: adsWatch.archiveAdState.isLoading)

      ],
    );
  }

  /// call api on search
  Timer? debounce;
  void onSearchChanged(String value,BuildContext context){
    final selectClientWatch = ref.watch(selectClientController);
    final adsWatch = ref.watch(adsController);

    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () async {
      selectClientWatch.clientList = [];
      selectClientWatch.pageNo =1;
      selectClientWatch.clientListState.success = null;
      adsWatch.clientDataList = [];
      // disposeApiData();
      // adsListApi(context, false, isGetOnlyClient: true);
      await selectClientWatch.clientListApi(context, false, isAdsAvailable: true, searchText: value).then((value){
        if(selectClientWatch.clientListState.success?.status == ApiEndPoints.apiStatus_200){
          adsWatch.updateClientList(selectClientWatch.clientListState.success?.data ?? []);
        }
      });

    });
  }





}
