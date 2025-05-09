import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/package/all_locations_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/package/web/helper/all_location_bottom_widget.dart';
import 'package:odigo_vendor/ui/package/web/helper/all_location_client_top_widget.dart';
import 'package:odigo_vendor/ui/package/web/helper/all_location_own_top_widget.dart';
import 'package:odigo_vendor/ui/package/web/helper/all_location_vendor_top_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';

class AllLocationsWeb extends ConsumerStatefulWidget {
  final bool? isForOwn;
  const AllLocationsWeb({Key? key, this.isForOwn}) : super(key: key);

  @override
  ConsumerState<AllLocationsWeb> createState() => _AllLocationsWebState();
}

class _AllLocationsWebState extends ConsumerState<AllLocationsWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final allLocationsWatch = ref.read(allLocationsController);
      final selectDestinationWatch = ref.read(selectDestinationController);
      allLocationsWatch.disposeController(isNotify : true);
      if(selectDestinationWatch.selectedDestination == null){
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.package());
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
    final selectDestinationWatch = ref.watch(selectDestinationController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         CommonTitleBackWidget(title:  selectDestinationWatch.selectedDestination?.name??'',).paddingOnly(bottom: context.height*0.03),

        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  Session.getUserType()==UserType.VENDOR.name?
                  const AllLocationVendorTopWidget():(widget.isForOwn??true)
                      ?const AllLocationOwnTopWidget():const AllLocationClientTopWidget(),
          
                  Expanded(
                    child: AllLocationBottomWidget(
                      isForOwn: widget.isForOwn,
                      onProceedTap: () async {
                        var selectDestinationWatch = ref.watch(selectDestinationController);
                        var allLocationsWatch = ref.watch(allLocationsController);
                        var selectStore = ref.watch(selectStoreController);
                        var selectClient = ref.watch(selectClientController);

                        await allLocationsWatch.packageLimitApi(context: context,
                            destinationUuid:selectDestinationWatch.selectedDestination?.uuid ??'',
                            startDate:allLocationsWatch.startDate,
                            endDate:allLocationsWatch.endDate,
                            budget:allLocationsWatch.priceCtr.text,
                            storeUuid: selectStore.selectedStore?.odigoStoreUuid,clientUuid: widget.isForOwn == false ? selectClient.selectedClient?.uuid : null
                        ).then((value){
                          if(allLocationsWatch.packageLimitState.success?.status == ApiEndPoints.apiStatus_200){

                            showMessageDialog(context,
                                "Your Daily Budget is ${allLocationsWatch.packageLimitState.success?.data?.dailyBudget} and estimated Ad show count is ${allLocationsWatch.packageLimitState.success?.data?.estimatedAdShowCount}",
                                    (){
                                if(Session.getUserType() == UserType.VENDOR.name){
                                  Navigator.pop(context);
                                          ref.read(navigationStackController).push( NavigationStackItem.billing(isVertical: true, dailyBudget: allLocationsWatch.packageLimitState.success?.data?.dailyBudget??0));
                                        }else{
                                          if(widget.isForOwn??true){
                                            ref.read(navigationStackController).push( NavigationStackItem.billing(isForOwn:true,isVertical: false, dailyBudget: allLocationsWatch.packageLimitState.success?.data?.dailyBudget??0));
                                          }else{
                                            ref.read(navigationStackController).push( NavigationStackItem.billing(isForOwn:false,isVertical: true, dailyBudget: allLocationsWatch.packageLimitState.success?.data?.dailyBudget??0));
                                          }
                                        }
                                    },isShowClose: true);
                          }
                        });
                      },
                    ),
                  )
              ],
            ).paddingAll(context.height*0.02),
          ),
        )

      ],
    ).paddingAll(context.height*0.02);
  }


}
