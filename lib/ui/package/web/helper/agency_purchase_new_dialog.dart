import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_radio_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/slide_left_transition.dart';

class AgencyPurchaseNewDialog extends ConsumerWidget  with BaseConsumerWidget{
  const AgencyPurchaseNewDialog({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,ref) {
    final packageWatch = ref.watch(packageController);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: CommonSVG(
            strIcon: Assets.svgs.svgClose.keyName,
          ).paddingOnly(bottom: context.height*0.03).alignAtCenterRight(),
        ),
        CommonText(
            title: LocaleKeys.keyPurchasePackage.localized,
          textStyle: TextStyles.medium.copyWith(
            fontSize: 22.sp
          ),
        ).paddingOnly(bottom: context.height*0.025),

        SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return SlideLeftTransition(
                      delay: 100,
                      child: Column(
                        children: [
                          /// Change package creation for  Radio Buttons
                          CommonRadioButton(
                            value: packageWatch.agencyPurchasePackageDialogList[index].localized,
                            groupValue: packageWatch.selectedAgencyPurchasePackageFor.localized,
                            onTap: () {
                              packageWatch.changeSelectedAgencyPurchasePackageFor(packageWatch.agencyPurchasePackageDialogList[index]);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => SizedBox(width: context.width*0.03,),
                  itemCount: packageWatch.agencyPurchasePackageDialogList.length)
            ],
          ),
        ),

        CommonButton(
          isButtonEnabled: true,
          buttonText: LocaleKeys.keySubmit.localized,
          onTap: (){
            Navigator.of(context).pop();
            if(packageWatch.selectedAgencyPurchasePackageFor == LocaleKeys.keyForYourself){
              ref.read(navigationStackController).push(const NavigationStackItem.selectDestinations(isForOwn: true));
            }else{
              ref.read(navigationStackController).push(const NavigationStackItem.selectDestinations(isForOwn: false));
            }
            packageWatch.changeSelectedAgencyPurchasePackageFor(LocaleKeys.keyForYourself);
          },
          width: context.width*0.08,
          height:context.height*0.06,
        ),


      ],
    );
  }
}
