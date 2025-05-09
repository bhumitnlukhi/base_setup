import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/show_notification.dart';

showNotificationSnackBar(BuildContext context,{double? width,EdgeInsetsGeometry? padding, String? notificationTitle, String? notificationBody}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: width,
      elevation: 0,
      padding: padding??EdgeInsets.only(bottom: context.height*0.08, left: 20.w, right: 20.w),
      backgroundColor: AppColors.transparent,
      content: ShowNotification(
        notificationTitle:notificationTitle ,
        notificationBody: notificationBody,
        onCloseTap: (){
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}