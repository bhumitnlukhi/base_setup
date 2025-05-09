import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/ads_details_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_details_controller.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_cupertino_switch.dart';

class AdsDetailsWeb extends ConsumerStatefulWidget {
  final String adUuid;

  const AdsDetailsWeb({Key? key, required this.adUuid}) : super(key: key);

  @override
  ConsumerState<AdsDetailsWeb> createState() => _AdsDetailsWebState();
}

class _AdsDetailsWebState extends ConsumerState<AdsDetailsWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final adsDetailsWatch = ref.watch(adsDetailsController);
      adsDetailsWatch.disposeController(isNotify: true);
      await adsDetailsWatch.adDetailApi(context, adUuid: widget.adUuid);
      if(mounted){
        await adsDetailsWatch.adContentApi(context, false,
            adUuid: widget.adUuid);
      }
      adsDetailsWatch.contentScroll.addListener(() async {
        if (adsDetailsWatch.adContentState.success?.hasNextPage == true) {
          if (adsDetailsWatch.contentScroll.position.maxScrollExtent == adsDetailsWatch.contentScroll.position.pixels) {
            if (!adsDetailsWatch.adContentState.isLoadMore) {
              await adsDetailsWatch.adContentApi(context, true, adUuid: widget.adUuid);
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
    final adsWatch = ref.watch(adsController);
    final adsDetailWatch = ref.watch(adsDetailsController);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.white,
      ),
      child: FadeBoxTransition(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonBackTopWidget(
                  title: LocaleKeys.keyAdsDetails.localized,
                  onTap: () {
                    ref.read(navigationStackController).pop();
                  },
                ),
                (adsDetailWatch.adDetailState.success?.data?.status == 'ACTIVE')
                    ? Row(
                        children: [
                          CommonText(
                            title: LocaleKeys.keyDefault.localized,
                            textStyle: TextStyles.regular,
                          ).paddingOnly(right: context.width * 0.020),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: (adsWatch.changeStatusOfDefaultAdState.isLoading)
                                ? LoadingAnimationWidget.waveDots(color: AppColors.black, size: 22.h).paddingOnly(right: context.width * 0.01, left: context.width * 0.005)
                                : CommonCupertinoSwitch(
                                    switchValue: adsDetailWatch.adDetailState.success?.data?.isDefault ?? false,
                                    onChanged: (val) async {
                                      if (val) {
                                        await adsWatch.changeStatusOfDefaultAdApi(context, adUid: adsDetailWatch.adDetailState.success?.data?.uuid ?? '').then((value) {
                                          if (adsWatch.changeStatusOfDefaultAdState.success?.status == ApiEndPoints.apiStatus_200) {
                                            adsDetailWatch.adDetailState.success?.data?.isDefault = !(adsDetailWatch.adDetailState.success?.data?.isDefault ?? false);
                                            for (var element in adsWatch.adsList) {
                                              if (element?.uuid == adsDetailWatch.adDetailState.success?.data?.uuid) {
                                                element?.isDefault = adsDetailWatch.adDetailState.success?.data?.isDefault;
                                              } else if (element?.destinationUuid == adsDetailWatch.adDetailState.success?.data?.destination?.uuid) {
                                                element?.isDefault = false;
                                              }
                                            }
                                            // adsWatch.adsList.every((element)=> element?.isDefault == false);

                                            adsDetailWatch.updateUi();
                                          }
                                        });
                                      } else {
                                        showMessageDialog(context, LocaleKeys.keyUnableToDeactivateDefaultAd.localized, () {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                  ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ).paddingOnly(bottom: context.height * 0.034),
            SizedBox(height: context.height * 0.030),
            const Expanded(child: AdsDetailsWidget())
          ],
        ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
      ),
    ).paddingAll(context.height * 0.025);
  }
}
