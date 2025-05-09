import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/auth/web/helper/tab_widget_tile.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TabWidgetTile(name: LocaleKeys.keyLogin.localized,value: true,),
        SizedBox(width: context.width * 0.01,),
        TabWidgetTile(name: LocaleKeys.keySignup.localized,value: false,),
      ],
    );
  }
}
