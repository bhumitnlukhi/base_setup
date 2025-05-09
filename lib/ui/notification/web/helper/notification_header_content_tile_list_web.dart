import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/notification/notification_screen_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/notification/model/response/notification_list_reponse_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class NotificationHeaderContentTileList extends ConsumerWidget
    with BaseConsumerWidget {
  final NotificationData? notificationData;
  final bool? isFromHome;

  NotificationHeaderContentTileList({super.key, this.notificationData,this.isFromHome});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final notificationScreenWatch = ref.watch(notificationScreenController);
    return InkWell(
      onTap: (){
        if(isFromHome??false){
          Navigator.of(context).pop();
        }
        notificationScreenWatch.setNotificationRedirection(ref,isFromHome:isFromHome,moduleName: notificationData?.module,uuid:notificationData?.moduleUuid ,entityUuid: notificationData?.entityUuid,subEntityUuid: notificationData?.subEntityUuid,entityType:notificationData?.entityType ,subEntityType: notificationData?.subEntityType);
      },
      child: Row(
        children: [
          Container(
            height: 44.h,
            width: 44.h,
            decoration: const BoxDecoration(
                color: AppColors.white, shape: BoxShape.circle),
            child: CommonSVG(
              strIcon: Assets.svgs.svgNotificationWeb.keyName,
              height: 44.h,
              width: 44.h,
            ).paddingAll(12),
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child:CommonText(
                        maxLines: 10,
                        title:notificationData?.message??'',
                        textStyle: TextStyles.regular.copyWith(
                            fontSize: 15.sp, color: AppColors.textFieldLabelColor),
                      ).paddingOnly(right: context.width*0.001),
                    ),

                    IconButton(
                        onPressed: (){

                          showConfirmationDialogWeb(context: context, title: LocaleKeys.keyDeleteNotification.localized,
                          message: LocaleKeys.keyDeleteAllNotificationMessage.localized,
                          dialogWidth: context.width*0.35,
                          didTakeAction: (status)
                          async{
                            if(status)
                            {
                              await notificationScreenWatch.deleteNotificationAPI(context,notificationData?.uuid.toString()??'');
                              if(notificationScreenWatch.deleteNotificationState.success?.status == ApiEndPoints.apiStatus_200){
                                if((notificationScreenWatch.notificationListState.success?.hasNextPage??false) && notificationScreenWatch.getNotificationListState()){
                                  if(context.mounted){
                                    if(isFromHome??false){
                                      notificationScreenWatch.notificationListAPI(context,initPageSize: 5,showLoading: false);
                                    }else{
                                      notificationScreenWatch.notificationListAPI(context,showLoading: false);
                                    }

                                  }
                                }
                              }
                            }
                          }
                      );
                    }, icon: const Icon(Icons.delete_forever_outlined,size: 25,color: AppColors.red,))
                  ],
                ),
                // SizedBox(
                //   height: 5.h,
                // ),
                // CommonText(
                //   maxLines: 5,
                //   title:notificationData?.message??'',
                //   textStyle: TextStyles.regular.copyWith(
                //       fontSize: 15.sp, color: AppColors.textFieldLabelColor),
                // ),SizedBox(
                //   height: 5.h,
                // ),
                // CommonText(
                //   maxLines: 5,
                //   title:notificationData?.message??'',
                //   textStyle: TextStyles.regular.copyWith(
                //       fontSize: 15.sp, color: AppColors.textFieldLabelColor),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
