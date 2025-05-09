
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/notification/model/notification_filter_model.dart';
import 'package:odigo_vendor/framework/repository/notification/model/response/notification_list_reponse_model.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/notification/web/helper/notification_header_content_tile_list_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_card.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class NotificationHeaderTileListWeb extends ConsumerWidget
    with BaseConsumerWidget {

  final NotificationFilterModel model;
  final bool? isFromHome;
   NotificationHeaderTileListWeb({super.key,required this.model,this.isFromHome});

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    return model.notificationDayData?.isNotEmpty??false?Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          title: model.notificationDay?.localized??'',
          textStyle: TextStyles.regular
              .copyWith(color: AppColors.textFieldLabelColor, fontSize: 18.sp),
        ).paddingOnly(left: 20.w),
        SizedBox(
          height: 10.h,
        ),
        CommonCard(
          color: AppColors.lightPinkF7F7FC,
          child: ListView.separated(
            itemCount: model.notificationDayData?.length??0,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              NotificationData? notificationData = model.notificationDayData?[index];
              return  NotificationHeaderContentTileList(notificationData:notificationData,isFromHome:isFromHome).paddingOnly(bottom: 15.h,top: 10.h);
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 0.h,
                color: AppColors.greyBEBEBE.withOpacity(.2),
              );
            },
          ).paddingSymmetric(horizontal: 20.w)
        ),
      ],
    ):const Offstage() ;
  }
}
