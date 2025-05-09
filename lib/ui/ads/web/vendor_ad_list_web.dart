import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/ads/web/helper/vendor_ads_tab_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';

class VendorAdListWeb extends ConsumerStatefulWidget {
  final String? storeUuid;
  final String? destinationUuid;

  const VendorAdListWeb({Key? key, required this.storeUuid, required this.destinationUuid}) : super(key: key);

  @override
  ConsumerState<VendorAdListWeb> createState() => _VendorAdListWebState();
}

class _VendorAdListWebState extends ConsumerState<VendorAdListWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      // final vendorAdListWatch = ref.watch(vendorAdListController);

      final adsWatch = ref.watch(adsController);
      final storesWatch = ref.watch(storesController);
      storesWatch.disposeController(isNotify: true);
      adsWatch.disposeData(isNotify: true);
      // final storesWatch = ref.watch(storesController);
     // await storesWatch.storeDetailApi(context, storeUuid: widget.storeUuid??'' , forOdigoStore: true);
      await storesWatch.storeDetailLanguageApi(context, storeUuid: widget.storeUuid??'');
      adsWatch.disposeData(isNotify : true);
      adsWatch.searchCtr.clear();
      if(mounted){
        adsWatch.adsListApi(context, false,
            vendorUuid: Session.getUuid(),
            storeUuid: widget.storeUuid,
            destinationUuid: widget.destinationUuid);
      }
      // if(Session.getUserType() == UserType.VENDOR.name){
      //   adsWatch.adsListApi(context, false, vendorUuid: Session.getUuid());
      // }else if((Session.getUserType() == UserType.AGENCY.name)) {
      //
      //   if(widget.tabIndex!=null){
      //     if(widget.tabIndex ==0){
      //       adsWatch.updateAgencyOwnAds(true);
      //     }else{
      //       adsWatch.updateAgencyOwnAds(false);
      //     }
      //
      //   }
      //   if(adsWatch.isSelectedOwnAds){
      //     adsWatch.adsListApi(context, false, agencyUuid: Session.getUuid());
      //   } else {
      //     adsWatch.adsListApi(context, false, isGetOnlyClient: true);
      //   }
      // }
      // storesWatch.disposeController(isNotify: true);
      if(mounted){
        final storeWatch = ref.read(storesController);
        await storeWatch.destinationListApi(context, pageSize: pageSize100000, activeRecords: true);

      }
      adsWatch.vendorAdsCtr.addListener(() async{
        if (adsWatch.adsListState.success?.hasNextPage == true) {
          if (adsWatch.vendorAdsCtr.position.maxScrollExtent == adsWatch.vendorAdsCtr.position.pixels) {
            if(!adsWatch.adsListState.isLoadMore) {
              adsWatch.adsListApi(context, true, vendorUuid: Session.getUuid());
            }
          }
        }
      });

      adsWatch.agentAdsCtr.addListener(() async{
        if (adsWatch.adsListState.success?.hasNextPage == true) {
          if (adsWatch.agentAdsCtr.position.maxScrollExtent == adsWatch.agentAdsCtr.position.pixels) {
            if(!adsWatch.adsListState.isLoadMore) {
              adsWatch.adsListApi(context, true, agencyUuid: Session.getUuid(), storeUuid: widget.storeUuid);
            }
          }
        }
      });

      adsWatch.clientAdsCtr.addListener(() async{
        if (adsWatch.adsListState.success?.hasNextPage == true) {
          if (adsWatch.clientAdsCtr.position.maxScrollExtent == adsWatch.clientAdsCtr.position.pixels) {
            if(!adsWatch.adsListState.isLoadMore) {
              adsWatch.adsListApi(context, true, isGetOnlyClient: true);
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

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    // final storesWatch = ref.watch(storesController);

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.white,
        ),child: const VendorAdsTabWidget().paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030));
  }


}
