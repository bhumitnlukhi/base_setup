import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';

class CommonCupertinoSwitch extends StatelessWidget with BaseStatelessWidget {
  const CommonCupertinoSwitch({super.key, required this.switchValue,required this.onChanged });

  /// Switch Value
  final bool switchValue;
  /// On changed switch value
  final ValueChanged<bool> onChanged;

  @override
  Widget buildPage(BuildContext context) {
    return SizedBox(
      height: 22.h,
      width: 40.w,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Session.isRTL ? Alignment.centerRight: Alignment.centerLeft,
        child: CupertinoSwitch(
            value: switchValue,
            activeColor: AppColors.green35C658,
          trackColor: AppColors.black333333,
            onChanged: onChanged,
        ),
      ),
    );
  }
}
