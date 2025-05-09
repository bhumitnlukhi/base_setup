import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ClientDetailsDialogWidget extends ConsumerStatefulWidget {
  const ClientDetailsDialogWidget({super.key});

  @override
  ConsumerState<ClientDetailsDialogWidget> createState() => _ClientDetailsDialogWidgetState();
}

class _ClientDetailsDialogWidgetState extends ConsumerState<ClientDetailsDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final clientsWatch = ref.watch(clientsController);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [

            /// clients details & cross icon
            Expanded(
              child: CommonText(
                title: LocaleKeys.keyClientDetails.localized,
                fontSize: 22.sp,
                clrfont: AppColors.black,
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(navigationStackController).pushRemove(const NavigationStackItem.clients());
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName),
              ),
            )
          ],
        ),

        SizedBox(height: context.height*0.020,),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                flex: 2,
                child: _widgetHeaderValue(context: context,header: LocaleKeys.keyClientName.localized,value: clientsWatch.clientDetailsState.success?.data?.name??'')),
            Expanded(
              flex: 2,
              child: _widgetHeaderValue(context: context,header: LocaleKeys.keyCategory.localized,value: clientsWatch.clientDetailsState.success?.data?.businessCategory?.name??''),)

          ],
        ),

        SizedBox(height: context.height*0.05,),

        _widgetHeaderValue(context: context,header: LocaleKeys.keyAddress.localized,value: "${clientsWatch.clientDetailsState.success?.data?.houseNumber ?? ''}, ${clientsWatch.clientDetailsState.success?.data?.streetName??''}, ${clientsWatch.clientDetailsState.success?.data?.addressLine1??''}, ${clientsWatch.clientDetailsState.success?.data?.addressLine2??''}, ${clientsWatch.clientDetailsState.success?.data?.landmark ?? ''}, ${clientsWatch.clientDetailsState.success?.data?.cityName ?? ''}, ${clientsWatch.clientDetailsState.success?.data?.stateName ?? ''}-${clientsWatch.clientDetailsState.success?.data?.postalCode ?? ''}, ${clientsWatch.clientDetailsState.success?.data?.countryName ?? ''}",maxLines: 3),

      ],
    ).paddingAll(context.height*0.040);
  }

  _widgetHeaderValue({required BuildContext context,required String header, required String value, int? maxLines}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title: header, textStyle: TextStyles.regular.copyWith(color: AppColors.grey8F8F8F,fontSize: 16.sp),),
        SizedBox(height: context.height*0.010,),
        CommonText(title: value,maxLines: 3, textStyle: TextStyles.regular.copyWith(color: AppColors.black171717,fontSize: 18.sp),),
      ],
    ).paddingOnly(right: context.width * 0.020);
  }
}


