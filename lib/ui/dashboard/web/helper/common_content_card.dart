import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_active_inactive.dart';
import 'package:odigo_vendor/ui/utils/anim/animation_extension.dart';
import 'package:odigo_vendor/ui/utils/anim/custom_animation_controller.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonContentCard extends ConsumerStatefulWidget {
  final String title;
  final int? totalCount;
  final Color activeColor;
  final Color inActiveColor;
  final String countText;
  final double value;
  final int? totalActiveCount;
  final int? totalInActiveCount;
  final int? totalRejectedCount;
  final int? totalPendingCount;
  final bool? currencyRequired;
  final String? activeText;
  final String? inActiveText;
  final bool isRightSideView;

  const CommonContentCard({super.key, required this.title, this.totalCount, required this.activeColor, required this.inActiveColor, required this.countText, required this.value, this.totalActiveCount, this.totalInActiveCount, this.totalRejectedCount, this.totalPendingCount, this.currencyRequired, this.activeText, this.inActiveText, this.isRightSideView = false});

  @override
  ConsumerState<CommonContentCard> createState() => _CommonContentCardState();
}

class _CommonContentCardState extends ConsumerState<CommonContentCard> with BaseConsumerStatefulWidget, TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!mounted) return;

      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
      ref.watch(customAnimationController).notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      if ((animationController?.isDisposed ?? true) == false) {
        animationController?.forward();
        animationController?.addListener(() {
          if (mounted) {
            ref.watch(customAnimationController).notifyListeners();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return animationController != null
        ? Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(19.r), color: AppColors.white),
            padding: EdgeInsets.all(context.height * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                CommonText(
                  title: widget.title.localized,
                  textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 20.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),

                /// Total section
                Row(
                  children: [
                    CommonText(
                      title: (widget.currencyRequired ?? false)
                          ? '${Session.getCurrency()} ${(widget.totalCount ?? 0) < 10 ? '0${widget.totalCount}' : (widget.totalCount ?? 0)}'
                          : (widget.totalCount ?? 0) < 10
                              ? '0${widget.totalCount}'
                              : '${widget.totalCount ?? 0}',
                      textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 28.sp),
                    ).paddingOnly(right: 7.w),
                    CommonText(
                      title: LocaleKeys.keyTotal.localized,
                      textStyle: TextStyles.regular.copyWith(color: AppColors.clrD0D1D2, fontSize: 18.sp),
                    ),
                  ],
                ).paddingOnly(bottom: 15.h),

                /// For showing progress
                widget.isRightSideView
                    ? Container(
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: widget.inActiveColor,
                          borderRadius: BorderRadius.circular(35.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: widget.totalActiveCount ?? 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.activeColor,
                                  borderRadius: (widget.totalInActiveCount != null || widget.totalRejectedCount != null || widget.totalPendingCount != null) ? BorderRadius.only(topLeft: Radius.circular(35.r), bottomLeft: Radius.circular(35.r)) : BorderRadius.circular(35.r),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: widget.totalInActiveCount ?? 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.inActiveColor,
                                  borderRadius: (widget.totalActiveCount != null && (widget.totalRejectedCount != null || widget.totalPendingCount != null)) ? BorderRadius.zero : BorderRadius.circular(35.r),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: widget.totalPendingCount ?? 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.clr009AF1,
                                  borderRadius: (widget.totalRejectedCount != null && widget.totalRejectedCount != 0) ? BorderRadius.zero : BorderRadius.only(topRight: Radius.circular(35.r), bottomRight: Radius.circular(35.r)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: widget.totalRejectedCount ?? 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.clrEB1F1F,
                                  borderRadius: widget.totalPendingCount != null ? BorderRadius.only(topRight: Radius.circular(35.r), bottomRight: Radius.circular(35.r)) : BorderRadius.circular(35.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: 13.h,
                        decoration: BoxDecoration(
                          color: widget.inActiveColor,
                          borderRadius: BorderRadius.circular(35.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: widget.totalActiveCount ?? 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.activeColor,
                                  borderRadius: BorderRadius.circular(35.r),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: widget.totalInActiveCount ?? 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.inActiveColor,
                                  borderRadius: BorderRadius.circular(35.r),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   flex: 2,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: AppColors.red,
                            //       borderRadius: BorderRadius.circular(35.r),
                            //     ),
                            //   ),
                            // ),
                            // Expanded(
                            //   flex: 2,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: AppColors.black,
                            //       borderRadius: BorderRadius.circular(35.r),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                // SizedBox(
                //   width: context.width,
                //   child: Stack(
                //     children: [
                //       Container(
                //         // width: context.width * 0.4,
                //         height: 13.h,
                //         decoration: BoxDecoration(
                //           color: widget.inActiveColor,
                //           borderRadius: BorderRadius.circular(35.r),
                //         ),
                //       ),
                //       if (widget.totalActiveCount != 0 && widget.totalCount != 0)
                //         Container(
                //           width: context.width % (widget.totalActiveCount ?? 0 / (widget.totalCount ?? 0)).toDouble(),
                //           height: 14.h,
                //           decoration: BoxDecoration(
                //             color: widget.activeColor,
                //             borderRadius: BorderRadius.circular(35.r),
                //           ),
                //         ),
                //     ],
                //   ),
                // ).paddingOnly(right: context.width * 0.02),

                SizedBox(
                  height: 20.h,
                ),

                widget.isRightSideView
                    ? Wrap(
                  alignment: WrapAlignment.start, // Adjust alignment as needed
                  spacing: 10, // Space between children within a line
                  runSpacing: 10, // Space between lines

                        children: [
                          CommonActiveInactive(
                            title: widget.activeText?.localized ?? LocaleKeys.keyActive.localized,
                            containerColor: widget.activeColor,
                            countText: widget.countText,
                            currencyRequired: widget.currencyRequired,
                            count: widget.totalActiveCount ?? 0,
                          ).paddingOnly(right: 4.w),
                          CommonActiveInactive(title: widget.inActiveText?.localized ?? LocaleKeys.keyInActive.localized, containerColor: AppColors.clrECECEC, countText: widget.countText, currencyRequired: widget.currencyRequired, count: widget.totalInActiveCount ?? 0).paddingOnly(right: 4.w),

                          ///todo: uncomment it when its deployed
                          Session.getUserType() == UserType.VENDOR.name
                              ? CommonActiveInactive(
                                  title: widget.activeText?.localized ?? LocaleKeys.keyRejected.localized,
                                  containerColor: AppColors.clrEB1F1F,
                                  countText: widget.countText,
                                  currencyRequired: widget.currencyRequired,
                                  count: widget.totalRejectedCount ?? 0,
                                ).paddingOnly(right: 4.w)
                              : const SizedBox(),
                          Session.getUserType() == UserType.VENDOR.name
                              ? CommonActiveInactive(
                                  title: widget.activeText?.localized ?? LocaleKeys.keyPending.localized,
                                  containerColor: AppColors.clr009AF1,
                                  countText: widget.countText,
                                  currencyRequired: widget.currencyRequired,
                                  count: widget.totalPendingCount ?? 0,
                                )
                              : const SizedBox(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonActiveInactive(
                            title: widget.activeText?.localized ?? LocaleKeys.keyActive.localized,
                            containerColor: widget.activeColor,
                            countText: widget.countText,
                            currencyRequired: widget.currencyRequired,
                            count: widget.totalActiveCount ?? 0,
                          ).paddingOnly(right: 30.w),
                          CommonActiveInactive(title: widget.inActiveText?.localized ?? LocaleKeys.keyInActive.localized, containerColor: AppColors.clrECECEC, countText: widget.countText, currencyRequired: widget.currencyRequired, count: widget.totalInActiveCount ?? 0),
                        ],
                      ),
              ],
            ),
          )
        : const Offstage();
  }
}
