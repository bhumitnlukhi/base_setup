import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/all_locations_controller.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/package/web/helper/common_billing_horizontal.dart';
import 'package:odigo_vendor/ui/package/web/helper/common_billing_vertical.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';

class BillingWeb extends ConsumerStatefulWidget {
  final bool? isVertical;
  final bool? isForOwn;
  final int dailyBudget;
  const BillingWeb({Key? key,this.isVertical,this.isForOwn, required this.dailyBudget}) : super(key: key);

  @override
  ConsumerState<BillingWeb> createState() => _BillingWebState();
}

class _BillingWebState extends ConsumerState<BillingWeb> with BaseConsumerStatefulWidget,BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // final billingWatch = ref.watch(billingController);
      var packageWatch = ref.watch(packageController);

      packageWatch.purchasePackageState.isLoading = false;
      //billingWatch.disposeController(isNotify : true);
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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// title
        CommonTitleBackWidget(title:  LocaleKeys.keyBillingInformation.localized,).paddingOnly(bottom: context.height*0.05),

        /// body widget
        Session.getUserType() == UserType.VENDOR.name || (widget.isForOwn==false)? Expanded(
          child: CommonBillingVertical(
            isForOwn: widget.isForOwn,
            estimatedAdCount : widget.dailyBudget,
            onPayButtonTap:() async {
              packagePurchaseApiCall(context,ref);
          
            }),
        )
            : Expanded(
              child: CommonBillingHorizontal(onPayButtonTap: () async {
                  packagePurchaseApiCall(context,ref);
              }),
            )

      ],
    ).paddingAll(context.height*0.02);
  }

  Future<void> packagePurchaseApiCall(BuildContext context, WidgetRef ref) async {

    var packageWatch = ref.watch(packageController);
    var selectDestinationWatch = ref.watch(selectDestinationController);
    var allLocationsWatch = ref.watch(allLocationsController);
    var selectStore = ref.watch(selectStoreController);
    var selectClient = ref.watch(selectClientController);
    final adsWatch = ref.watch(adsController);

    final storesWatch = ref.watch(storesController);


    await packageWatch.purchasePackage(context: context,
        destinationUuid:selectDestinationWatch.selectedDestination?.uuid ??'',
        startDate:allLocationsWatch.startDate,
        endDate:allLocationsWatch.endDate,
        budget:allLocationsWatch.priceCtr.text,
        dailyBudget: widget.dailyBudget,
        storeUuid: selectStore.selectedStore?.odigoStoreUuid,clientUuid: widget.isForOwn == false ? selectClient.selectedClient?.uuid : null
    ).then((value){
      if(value.success?.status == ApiEndPoints.apiStatus_200){
        showCommonErrorDialogNew(context: context, message: value.success?.message??'',onButtonTap: () async {
          // packageWatch.disposeController(isNotify : true);
          packageWatch.packageSearchCtr.clear();
          packageWatch.destinationData = null;
          packageWatch.clearData();
          ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.package());


          /// Ads List Api Call if no Ads Created purchase package button should be disable
          if(Session.getUserType() == UserType.AGENCY.name) {
            selectClient.clientListApi(context, false, isAdsAvailable: true);
          }
          await adsWatch.adsListApi(context, false, agencyUuid: Session.getUuid()).then((value) async {
            if (adsWatch.adsList.isNotEmpty) {
              /// Package Module Apis
              packageWatch.disposeController(isNotify: true);
              packageWatch.packageSearchCtr.clear();
              // if (widget.tabIndex != null) {
              //   if (widget.tabIndex == 0) {
              //     packageWatch.changeAgencyDetailsTab(0);
              //   } else {
              //     packageWatch.changeAgencyDetailsTab(1);
              //   }
              // }

              /// Package List
              await packageWatch.packageListApi(context, false);
              // storesWatch.disposeController(isNotify: true);
              if(context.mounted) {
                await storesWatch.destinationListApi(
                  context,
                  pageSize: pageSize100000,
                  hasPurchased: (packageWatch.agencyUserTabIndex == 0 || Session.getUserType() == UserType.VENDOR.name) ? true : null,
                  hasPurchasedForClient: packageWatch.agencyUserTabIndex == 1 ? true : null,
                  activeRecords: true
                );

                // await storesWatch.destinationListApiCall(context);
              }

              packageWatch.packageScrollController.addListener(() async {
                if (packageWatch.packageListState.success?.hasNextPage == true) {
                  if (packageWatch.packageScrollController.position.maxScrollExtent == packageWatch.packageScrollController.position.pixels) {
                    if (!packageWatch.packageListState.isLoadMore) {
                      await packageWatch.packageListApi(context, true);
                    }
                  }
                }
              });
            }
          });

          
          // packageWatch.changeAgencyDetailsTab(packageWatch.selectedAgencyPurchasePackageFor == LocaleKeys.keyForYourself? 0: 1);
          // packageWatch.screenNavigationOnTabChange(ref);
          //
          // await packageWatch.packageListApi(context, false);

        });
      }
    });
  }


}
