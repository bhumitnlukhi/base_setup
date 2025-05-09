import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
class CommonRadioButton extends StatelessWidget with BaseStatelessWidget {
  const CommonRadioButton({
    super.key,
    required this.groupValue,
    required this.value,
    required this.onTap,
    this.textStyle,
  });

  final String? groupValue;
  final String value;
  final TextStyle? textStyle;
  final GestureTapCallback? onTap;

  @override
  Widget buildPage(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonSVG(
            height: 22.h,
            width: 20.h,
            strIcon: value == groupValue ? Assets.svgs.svgRadioSelected.keyName : Assets.svgs.svgRadioUnselected.keyName,
            svgColor: value != groupValue?AppColors.black.withOpacity(0.3):null,
          ).paddingOnly(right: 10.w),
          Text(value, style: TextStyles.regular.copyWith(
            color: AppColors.black,
            fontSize: 18.sp,
          )),
        ],
      ),
    );
  }
}