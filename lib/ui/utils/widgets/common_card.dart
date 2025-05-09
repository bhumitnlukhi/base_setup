import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CommonCard extends StatelessWidget with BaseStatelessWidget {
  final double? elevation;
  final Color? shadowColor;
  final Color? color;
  final Widget child;
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? margin;
  final double? cornerRadius;
  final Color? borderColor;

  const CommonCard({super.key, required this.child, this.elevation, this.shadowColor, this.shape, this.margin, this.cornerRadius, this.color, this.borderColor});

  @override
  Widget buildPage(BuildContext context) {
    return Card(
      elevation: elevation ?? 4,
        surfaceTintColor: AppColors.transparent,
      shadowColor: shadowColor ?? AppColors.cardShadow.withOpacity(0.1),
      color: color ?? AppColors.white,
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius ?? 20.r), side: BorderSide(color: borderColor ?? AppColors.transparent)),
      margin: margin,
      child: child,
    );
  }
}
