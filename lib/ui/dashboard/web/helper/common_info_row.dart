import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonInfoRow extends StatelessWidget {
  final String xAxisLabel;
  final String yAxisLabel;

  const CommonInfoRow({
    Key? key,
    required this.xAxisLabel,
    required this.yAxisLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteF7F7FC,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          CommonText(
            title: xAxisLabel,
            textStyle: TextStyles.medium.copyWith(
              color: AppColors.black.withOpacity(0.5),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 20.w),
          CommonText(
            title: yAxisLabel,
            textStyle: TextStyles.medium.copyWith(
              color: AppColors.black.withOpacity(0.5),
              fontSize: 12.sp,
            ),
          ),
        ],
      ).paddingSymmetric(vertical: 12.h,horizontal: 15.w),
    );
  }
}
