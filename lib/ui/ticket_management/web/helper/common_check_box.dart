import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CommonCheckBox extends StatelessWidget with BaseStatelessWidget{
  const CommonCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.shape, this.fillColor, this.selectedBorder, this.unSelectedBorder,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? fillColor;
  final Color? selectedBorder;
  final Color? unSelectedBorder;
  final OutlinedBorder? shape;

  @override
  Widget buildPage(BuildContext context) {
    return Checkbox(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3.r),bottomRight: Radius.circular(3.r)),
          ),

      fillColor: WidgetStatePropertyAll(fillColor),
      activeColor: activeColor ?? AppColors.white,
      checkColor: checkColor ?? AppColors.black,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: WidgetStateBorderSide.resolveWith(
            (states) {
          if (states.contains(WidgetStatePropertyAll(value))) {
            return BorderSide(color: AppColors.black, width: 1.w);
          } else {
            return BorderSide(color:  AppColors.black.withOpacity(0.2), width: 1.w);
          }
        },
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}