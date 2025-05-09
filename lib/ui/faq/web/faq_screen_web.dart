import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/faq/faq_screen_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_appbar_web.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';

class FaqScreenWeb extends ConsumerStatefulWidget {
  const FaqScreenWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<FaqScreenWeb> createState() => _FaqScreenWebState();
}

class _FaqScreenWebState extends ConsumerState<FaqScreenWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  /// Scroll controller
  final ScrollController scrollController = ScrollController();

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final faqScreenWatch = ref.read(faqScreenController);
      faqScreenWatch.disposeController(isNotify: true);
      await faqScreenWatch.faqListAPI(context, false);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (faqScreenWatch.faqData.length != faqScreenWatch.faqListState.success?.totalCount) {
            await faqScreenWatch.faqListAPI(context, true);
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
    final faqScreenWatch = ref.watch(faqScreenController);
    return Stack(
      children: [
        _bodyWidget(),
        DialogProgressBar(isLoading: faqScreenWatch.faqListState.isLoading),
      ],
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final faqScreenWatch = ref.read(faqScreenController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonAppBarWeb(),
        SizedBox(
          height: context.height * 0.02,
        ),
        Expanded(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    title: LocaleKeys.keyFaq.localized.toUpperCase(),
                    textStyle: TextStyles.regular.copyWith(fontSize: 20.sp, color: AppColors.black),
                  ),
                  SizedBox(
                    height: 41.h,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: faqScreenWatch.faqData.isEmpty
                              ? EmptyStateWidget(
                                  imgName: Assets.svgs.svgNoData.keyName,
                                  title: LocaleKeys.keyNoDataFound.localized,
                                ).alignAtCenter()
                              : ListView.builder(
                                  itemCount: faqScreenWatch.faqData.length,
                                  controller: scrollController,
                                  itemBuilder: (context, index) {
                                    bool isExpanded = faqScreenWatch.selectedIndex == index;
                                    return ExpansionTile(
                                      key: Key('tile_${index}_${isExpanded.toString()}'),
                                      backgroundColor: AppColors.white,
                                      initiallyExpanded: isExpanded,
                                      childrenPadding: EdgeInsets.zero,
                                      onExpansionChanged: (expanded) {
                                        faqScreenWatch.updateIndex(expanded ? index : -1);
                                      },
                                      title: Row(
                                        children: [
                                          Container(
                                            height: 57.h,
                                            width: 57.h,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.clrF7F7FC),
                                            child: CommonSVG(
                                              strIcon: Assets.svgs.svgFaq.path,
                                              svgColor: AppColors.black,
                                            ).paddingAll(16.h),
                                          ),
                                          Flexible(
                                            child: CommonText(
                                              title: faqScreenWatch.faqData[index]?.question ?? '',
                                              maxLines: 10000000,
                                              textStyle: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black),
                                            ).paddingOnly(left: 17.w),
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(
                                        isExpanded ? Icons.minimize : Icons.add,
                                        size: 15.h,
                                        color: AppColors.black,
                                      ),
                                      children: [
                                        CommonText(
                                          title: faqScreenWatch.faqData[index]?.answer ?? '',
                                          maxLines: 10000000,
                                          textStyle: TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.clr5D596C),
                                         // maxLines: 10000000,
                                        ).alignAtCenterLeft().paddingOnly(left: 85.w)
                                      ],
                                    );
                                  },
                                ),
                        ),
                        DialogProgressBar(isLoading: faqScreenWatch.faqListState.isLoadMore, forPagination: true),
                      ],
                    ),
                  ),
                ],
              ).paddingAll(25.h),
            ),
          ),
        ),
      ],
    ).paddingAll(20.h);
  }
}
