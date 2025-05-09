import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonTotalCountContentWeb extends ConsumerWidget with BaseConsumerWidget{
  final String title;
  final int? totalCount;
  final String icon;
  const CommonTotalCountContentWeb( {
    Key? key,
    required this.title,
    this.totalCount,
    required this.icon,
  }) : super(key: key);

  @override
  Widget buildPage(BuildContext context,ref) {
    return Container(
     decoration: BoxDecoration(
       color: AppColors.white,
       borderRadius: BorderRadius.circular(19.r),
     ),
      padding:EdgeInsets.all(context.height*0.023),
      child: Row(
        children: [

          /// Icon
          CommonSVG(
            strIcon: icon,
            height: context.height*0.085,
            width: context.height*0.085,
          ).paddingOnly(right: context.width*0.015),


          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText(
                    title: title.localized,
                    textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 20.sp),
                  ),
                ],
              ),

              SizedBox(
                height: 8.h,
              ),

              /// Total section
              Row(
                children: [
                  CommonText(
                    title: (totalCount ?? 0) < 10 ? '0$totalCount' : '${totalCount ?? 0}',
                    textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 30.sp),
                  ).paddingOnly(right: 7.w),
                  CommonText(
                    title: LocaleKeys.keyTotal.localized,
                    textStyle: TextStyles.regular.copyWith(color: AppColors.clrD0D1D2, fontSize: 18.sp),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}