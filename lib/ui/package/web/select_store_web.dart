import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/select_store_list_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_grid_list_shimmer.dart';

class SelectStoreWeb extends ConsumerStatefulWidget {
  final String destinationUuid;
  const SelectStoreWeb({Key? key, required this.destinationUuid}) : super(key: key);

  @override
  ConsumerState<SelectStoreWeb> createState() => _SelectStoreWebState();
}

class _SelectStoreWebState extends ConsumerState<SelectStoreWeb> with BaseConsumerStatefulWidget,BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final selectStoreWatch = ref.watch(selectStoreController);
      selectStoreWatch.disposeController(isNotify : true);
      await selectStoreWatch.storeListApi(context, false, destinationUuid: widget.destinationUuid, dataSize: pageSize100000, isAdsAvailable: true);
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
    final selectStoreWatch = ref.watch(selectStoreController);
    return Column(
      children: [
        ///title
        CommonTitleBackWidget(title: LocaleKeys.keySelectStore.localized,),

        /// body
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.white,
            ),
            child:
            selectStoreWatch.storeListState.isLoading ? const CommonGridListShimmer().paddingSymmetric(horizontal: context.width * 0.015, vertical: context.height * 0.015) :
            selectStoreWatch.storeList.isEmpty ?
            Center(child: EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized,)):
            SelectStoreListWidget(

              onTap: (index){
                selectStoreWatch.updateSelectedStore(selectStoreWatch.storeList[index]);
                ref.read(navigationStackController).push(const NavigationStackItem.allLocations(isForOwn: false));
              },
            ).paddingAll(context.height*0.02),
          ).paddingOnly(top: context.height*0.05),
        )

      ],
    ).paddingAll(context.height*0.02);
  }


}
