import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class DestinationDetailsDialogBody extends StatelessWidget with BaseStatelessWidget {
  final DestinationData? data;
  const DestinationDetailsDialogBody({Key? key, this.data}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    String address = '${data?.houseNumber??''},'
        ' ${data?.stateName??''}, ${data?.addressLine1??''},'
        ' ${data?.addressLine2??''}, ${data?.landmark??''}, \n${data?.cityName??''},'
        ' ${data?.stateName??''} ${data?.postalCode??''}, ${data?.countryName}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Title and closeicon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(title: LocaleKeys.keyDestinationDetails.localized,textStyle: TextStyles.regular.copyWith(fontSize: 20.sp, color: AppColors.black),),
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName, width: context.width * 0.045, height: context.height * 0.045))
          ],
        ).paddingOnly(bottom: context.height * 0.034),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 3,
                child: commonTitleAndDesc(context, title: LocaleKeys.keyDestinationName.localized, subtitle:data?.name??'').paddingOnly(right: context.width * 0.040)),
            Expanded(
                flex: 2,
                child: commonTitleAndDesc(context, title: LocaleKeys.keyDestinationType.localized, subtitle: data?.destinationTypeName??'').paddingOnly(right: context.width * 0.040)),
            Expanded(
                flex: 2,
                child: commonTitleAndDesc(context, title: LocaleKeys.keyNoOfFloor.localized, subtitle: (data?.totalFloor??'').toString())),
            const Spacer(),
          ],
        ).paddingOnly(bottom: context.height * 0.055),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                flex: 3,
                child: commonTitleAndDesc(context, title: LocaleKeys.keyAddress.localized, subtitle: address).paddingOnly(bottom: context.height * 0.055)),
            const Spacer(flex:2)
          ],
        ),
        CommonText(title:LocaleKeys.keyOwnersDetails.localized,textStyle: TextStyles.regular.copyWith(fontSize: 20.sp),).paddingOnly(bottom: context.height * 0.034),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex:2,
                child: commonTitleAndDesc(context, title: LocaleKeys.keyUserName.localized, subtitle: data?.ownerName??'').paddingOnly(right: context.width * 0.040)),
            Expanded(
                flex: 2,
                child: commonTitleAndDesc(context, title:LocaleKeys.keyContactNo.localized,subtitle:data?.contactNumber??'' ).paddingOnly(right: context.width * 0.040)),
            Expanded(
                flex: 3,
                child: commonTitleAndDesc(context, title: LocaleKeys.keyEmaiID.localized, subtitle: data?.email??''))
          ],
        ),
      ],
    ).paddingAll(context.width * 0.020);
  }
  
  Widget commonTitleAndDesc(BuildContext context, {required String title,required String subtitle, double? titleFont, double? subtitleFont}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonText(title: title,textStyle: TextStyles.regular.copyWith(fontSize: titleFont ?? 16.sp, color: AppColors.grey8F8F8F),).paddingOnly(bottom: context.height * 0.010),
        CommonText(title: subtitle,textStyle: TextStyles.regular.copyWith(fontSize: subtitleFont ?? 18.sp),maxLines: 3,)
      ],
    );
  }
}
