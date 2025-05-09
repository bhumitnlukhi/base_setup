import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/store_list_tile_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_grid_list_shimmer.dart';

class SelectClientWeb extends ConsumerStatefulWidget {
  final bool? isForOwn;
  const SelectClientWeb({Key? key,this.isForOwn}) : super(key: key);

  @override
  ConsumerState<SelectClientWeb> createState() => _SelectClientWebState();
}

class _SelectClientWebState extends ConsumerState<SelectClientWeb> with BaseConsumerStatefulWidget,BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final selectClientWatch = ref.watch(selectClientController);
      selectClientWatch.disposeController(isNotify : true);
      await selectClientWatch.clientListApi(context, false,isFromCreateAd: true);
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
    final selectClientWatch = ref.watch(selectClientController);
    return Column(
      children: [
        /// tile
         CommonTitleBackWidget(title: LocaleKeys.keySelectClient.localized,),

        /// body widget
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  selectClientWatch.clientListState.isLoading ? const CommonGridListShimmer() :
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: selectClientWatch.clientList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var model = selectClientWatch.clientList[index];
                      return InkWell(
                          onTap:(){
                            selectClientWatch.updateSelectedClient(model);
                            ref.read(navigationStackController).push(NavigationStackItem.allLocations(isForOwn: widget.isForOwn));
                          },
                          child: StoreListTileWidget(image: '', name: model?.name??'', city: model?.name??'',)
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisExtent: context.height*0.28,
                      mainAxisSpacing: context.height * 0.02,
                      crossAxisSpacing: context.width * 0.02,
                    ),
                  ),

                ],
              ),
            ).paddingAll(context.height*0.02),
          ).paddingOnly(top: context.height*0.05),
        )

      ],
    ).paddingAll(context.height*0.02);
  }


}
