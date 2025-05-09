import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/package/web/helper/select_destination_list_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_grid_list_shimmer.dart';

class SelectDestinationWeb extends ConsumerStatefulWidget {
  final bool? isForOwn;
  const SelectDestinationWeb({Key? key,this.isForOwn, }) : super(key: key);

  @override
  ConsumerState<SelectDestinationWeb> createState() =>
      _SelectDestinationWebState();
}

class _SelectDestinationWebState extends ConsumerState<SelectDestinationWeb> with BaseConsumerStatefulWidget,BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final selectDestinationWatch = ref.watch(selectDestinationController);
      selectDestinationWatch.disposeController(isNotify : true);
      if(Session.getUserType() == UserType.VENDOR.name){
        await selectDestinationWatch.destinationListApi(context, false, forVendor: true, dataSize: pageSize100000);
      } else{
        await selectDestinationWatch.destinationListApi(context, false, dataSize: pageSize100000,adsForOwn: widget.isForOwn);
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
      children: [
        /// titel
         CommonTitleBackWidget(title: LocaleKeys.keySelectDestination.localized,),

        /// body
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.white,
            ),
            child:selectDestinationWatch.destinationListState.isLoading ? const CommonGridListShimmer().paddingSymmetric(horizontal: context.width * 0.015, vertical: context.height * 0.015) :selectDestinationWatch.destinationList.isEmpty ?
            Center(child: EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized,)):
            SelectDestinationListWidget(
              isIconRequired: true,
              onTap: (index){
                selectDestinationWatch.updateSelectedDestination(selectDestinationWatch.destinationList[index]);
                if(Session.getUserType() == UserType.VENDOR.name){
                  ///
                  ref.read(navigationStackController).push( NavigationStackItem.selectStore(isForOwn:false, destinationUuid: selectDestinationWatch.destinationList[index]?.uuid??''));
                }else{
                  if(widget.isForOwn??true){
                    ref.read(navigationStackController).push(const NavigationStackItem.allLocations(isForOwn:true));
                  }else{
                    ref.read(navigationStackController).push(const NavigationStackItem.selectClient(isForOwn:false));
                  }

                }
              },
            ).paddingAll(context.height*0.02),
          ).paddingOnly(top: context.height*0.05),
        )

      ],
    ).paddingAll(context.height*0.02);
  }


}
