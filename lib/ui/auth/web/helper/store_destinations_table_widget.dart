import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/vendor_registration_form_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class StoreDestinationsTableWidget extends StatelessWidget {
  const StoreDestinationsTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
            textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
          columnWidths: const {
            /// serial number
            0: FlexColumnWidth(2),

            /// Destination
            1: FlexColumnWidth(3),

            /// Store name
            2: FlexColumnWidth(3),

            /// Edit name
            3: FlexColumnWidth(1),


            4: FlexColumnWidth(0.5),

            /// delete name
            5: FlexColumnWidth(1),
          },
          children: [
            TableRow(children: [
              TableHeaderTextWidget(text: LocaleKeys.keySrNo.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyDestinations.localized),
              TableHeaderTextWidget(text: LocaleKeys.keyStores.localized),
              const Offstage(),
              const Offstage(),
              const Offstage()
            ]),
          ],
        ).paddingOnly(left: 30.w, right: 25.w, top: 25.h, bottom: 20.h),
        Consumer(
            builder: (context, ref, child) {
              final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
              return ListView.separated(
                shrinkWrap: true,
                itemCount: vendorRegistrationFormWatch.destinationStoreList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.clrF7F7FC),
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                      columnWidths: const {
                        /// serial number
                        0: FlexColumnWidth(2),

                        /// Destination
                        1: FlexColumnWidth(3),

                        /// Store name
                        2: FlexColumnWidth(3),

                        /// Edit name
                        3: FlexColumnWidth(1),


                        4: FlexColumnWidth(0.5),

                        /// delete name
                        5: FlexColumnWidth(1),

                      },
                      children: [
                        TableRow(children: [
                          ///Sr NO
                          CommonText(title: '${index+1}',textStyle: TextStyles.regular.copyWith(fontSize: 14.sp),),

                          ///Destination
                          CommonText(title: '${vendorRegistrationFormWatch.destinationStoreList[index].destinationData?.name}',textStyle: TextStyles.regular.copyWith(fontSize: 14.sp),),

                          ///Store
                          CommonText(title: '${vendorRegistrationFormWatch.destinationStoreList[index].storeData?.name}',textStyle: TextStyles.regular.copyWith(fontSize: 14.sp),),

                          const Offstage(),

                          const Offstage(),

                          ///Delete
                          CommonButton(
                            buttonText: LocaleKeys.keyDelete.localized,
                            isButtonEnabled: true,
                            height: context.height * 0.049,
                            width: context.width * 0.099,
                            buttonEnabledColor: AppColors.redE16000,
                            buttonTextSize: 12.sp,
                            // backgroundColor: AppColors.red,
                            onTap: (){
                              vendorRegistrationFormWatch.removeDestinationAndStoreValue(index);
                            },
                          )
                        ]),
                      ],
                    ).paddingOnly(left: 30.w, right: 20.w, top: 20.h, bottom: 20.h),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 25.h,
                  );
                },
              );
            }
        ),
      ],
    );
  }
}
