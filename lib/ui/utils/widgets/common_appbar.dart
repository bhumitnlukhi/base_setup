import 'package:flutter_base_setup/framework/utility/extension/extension.dart';
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';


class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLeadingEnable;
  final bool isDrawerEnable;
  final GestureTapCallback? onLeadingPress;
  final String title;
  final String? leftImage;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;

  const CommonAppBar(
      {Key? key,
      this.isLeadingEnable = true,
      this.isDrawerEnable = false,
      this.onLeadingPress,
      this.leftImage,
      this.title = '',
      this.backgroundColor,
      this.titleColor,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: (isLeadingEnable)
          ? ((isDrawerEnable)
              ? InkWell(
                  onTap: () {
                    // FocusScope.of(context).unfocus();
                    // CustomDrawerState.openDrawer();
                  },
                  child: Image.asset(
                    leftImage ?? AppAssets.icBack,
                    fit: BoxFit.fill,
                  ).paddingAll(8.h),
                )
              : InkWell(
                  onTap: onLeadingPress ??
                      () {
                        Navigator.pop(context);
                      },
                  child: Image.asset(
                    leftImage ?? AppAssets.icBack,
                    fit: BoxFit.fill,
                  ).paddingAll(8.h),
                ))
          : const Offstage(),
      elevation: 0,
      actions: actions,
      backgroundColor: backgroundColor ?? AppColors.scaffoldBGByTheme(),
      title: Text(title,
          textAlign: TextAlign.center,
          style: TextStyles.medium.copyWith(
              fontSize: 16.sp, color: titleColor ?? AppColors.primary)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

/*
Widget Usage
const CommonAppBar(
        title: "Home",
      ),
* */
