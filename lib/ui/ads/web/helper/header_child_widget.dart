import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class HeaderChildWidget extends StatelessWidget {
  final String headerName;
  final Widget child;
  const HeaderChildWidget({super.key, required this.headerName, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title: headerName,clrfont: AppColors.textFieldBorderColor,),
        SizedBox(height: context.height * 0.02,),
        child,
      ],
    );
  }
}
