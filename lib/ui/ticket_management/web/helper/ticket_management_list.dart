import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/my_order_filter_action_widget_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class TicketManagementList extends ConsumerWidget with BaseConsumerWidget {
  const TicketManagementList({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// table header
                Table(
                  textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  columnWidths: const {

                    /// Ticket ID
                    // 0: FlexColumnWidth(2.7),
                    /// Date
                    0: FlexColumnWidth(4),
                    /// User Name
                    1: FlexColumnWidth(4),
                    /// Reason type
                    // 3: FlexColumnWidth(4),
                    /// Reason
                    2: FlexColumnWidth(5),
                    /// Status
                    3: FlexColumnWidth(6),
                    /// comments
                    4: FlexColumnWidth(3),

                    5: FlexColumnWidth(0.5),/// Ticket ID
                  },
                  children: [
                    TableRow(
                      children: [

                        /// ticket id
                        // _widgetTableHeader(
                        //     text: LocaleKeys.keyTicketID.localized, rightImage: false).paddingOnly(left: context.width*0.010),

                        /// ticket date
                        _widgetTableHeader(
                            text: LocaleKeys.keyTicketDate.localized, rightImage: false).paddingOnly(left: context.width*0.010),

                        /// ticket user name
                        _widgetTableHeader(
                            text: LocaleKeys.keyUserSpaceName.localized, rightImage: false),

                        /// reason type
                        // _widgetTableHeader(
                        //     text: LocaleKeys.keyReasonType.localized, rightImage: false),

                        /// Reason
                        _widgetTableHeader(
                            text: LocaleKeys.keyReason.localized, rightImage: false),

                        /// Status
                        _widgetTableHeader(
                            text: LocaleKeys.keyStatus.localized, rightImage: true,
                          rightWidget: const MyOrderFilterActionWidgetWeb()
                        ),
                        _widgetTableHeader(
                            text: LocaleKeys.keyComments.localized, rightImage: false).alignAtCenterRight(),


                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: context.width*0.0050,
                )
              ],
            ).paddingOnly(bottom: context.height*0.0023),
          ),
        ),
      ],
    );
  }

  Widget _widgetTableHeader({required String text, TextAlign? textAlign, bool? rightImage, Widget? rightWidget}) {
    return Row(
      children: [
        CommonText(
          title: text,
          textAlign: textAlign ?? (Session.isRTL ? TextAlign.right : TextAlign.left),
          textStyle: TextStyles.regular
              .copyWith(fontSize: 18.sp, color: AppColors.grey8D8C8C),
        ).paddingOnly(right: rightImage == true ? 25.w : 0.0),
        rightImage == true ? rightWidget as Widget : const Offstage()
      ],
    );
  }
}
