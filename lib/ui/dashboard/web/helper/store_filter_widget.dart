import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';

class StoreFilterWidget extends ConsumerWidget {
  final Function() onTap;
  final OverlayPortalController controller;
  const StoreFilterWidget({super.key,required this.onTap, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LayerLink link = LayerLink();
    final storeWatch = ref.watch(storesController);
    // storeWatch.selectedDestination = null;
    return CompositedTransformTarget(
      link: link,
      child: OverlayPortal(
        controller: controller,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: link,
            targetAnchor: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Material(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: context.height * 0.4,
                        maxWidth: context.width * 0.15,
                        minHeight: context.height * 0.15
                    ),
                    height: storeWatch.storeList.isEmpty ? (context.height * 0.3) : (storeWatch.storeList.length * (context.height * 0.05)) + (context.height * 0.1),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15.r)),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 30.h, // Adjust height as needed
                                child: TextFormField(
                                  style: TextStyles.regular.copyWith(
                                    color: AppColors.clr8D8D8D,
                                    fontSize: 12.sp,
                                  ),
                                  decoration: InputDecoration(
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 15.h, // Matches icon size to remove extra spacing
                                      minHeight: 15.h,
                                    ),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(right: 7.w),
                                      child: Icon(
                                        Icons.search,
                                        color: AppColors.clr8D8D8D,
                                        size: 15.h,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.only(left: 0, right: 10.w, top: 10.h, bottom: 10.h), // Adjust padding
                                    hintText: LocaleKeys.keySearchDestination.localized,
                                    hintStyle: TextStyles.regular.copyWith(
                                      color: AppColors.clr8D8D8D,
                                      fontSize: 12.sp,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r), // Optional: Add rounded border
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true, // Optional: Add background color
                                    fillColor: Colors.white, // Adjust background color
                                  ),
                                  onChanged: (storeName) {
                                    storeWatch.searchStore(storeName);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(color: AppColors.clr8D8D8D.withOpacity(0.1)),
                        SizedBox(height: context.height * 0.01),
                        storeWatch.searchedStoreList.isEmpty
                            ? EmptyStateWidget(
                          title: LocaleKeys.keyNoDestinationFound.localized,
                          titleFontSize: 12.sp,
                          imgName: Assets.svgs.svgNoData.path,
                          imgHeight: context.height * 0.07,
                          imgWidth: context.height * 0.07,
                          // padding: context.height * 0.02,
                        )
                            : Expanded(
                          child: ListView.separated(
                            itemCount: storeWatch.searchedStoreList.length,
                            itemBuilder: (BuildContext context, int index) {
                              StoreListData? storeName = storeWatch.searchedStoreList[index];
                              return storeName == null
                                  ? const Offstage()
                                  : InkWell(
                                onTap: () {
                                  storeWatch.updateSelectedStore(storeName);
                                  if (controller.isShowing) {
                                    controller.hide();
                                  }
                                  onTap.call();
                                  // storesWatch.storeListApiCall(context);
                                },
                                child: CommonText(
                                  title: storeName.name ?? '',
                                  textStyle: TextStyles.regular.copyWith(color: storeWatch.selectedStoreData == storeName ? AppColors.primary : AppColors.clr8D8D8D),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(height: context.height * 0.02);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: InkWell(
          onTap: () {
            if (!controller.isShowing) {
              storeWatch.searchStore('');
            }
            controller.toggle();
          },
          child: CommonSVG(
            strIcon: Assets.svgs.svgFilter.keyName,
            width: context.height * 0.027,
            height: context.height * 0.027,
          ),
        ),
      ),
    );
  }
}
