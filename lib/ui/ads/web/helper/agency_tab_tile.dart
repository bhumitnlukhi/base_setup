import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AgencyTabTile extends StatelessWidget with BaseStatelessWidget{
  final String title;
  final bool value;
  const AgencyTabTile({super.key, required this.title, required this.value});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final adsWatch = ref.watch(adsController);
        final selectClientWatch = ref.watch(selectClientController);
        return IgnorePointer(
          ignoring: ( adsWatch.changeStatusOfDefaultAdState.isLoading ||
              adsWatch.changeStatusOfAdState.isLoading || adsWatch.archiveAdState.isLoading),
          child: InkWell(
            onTap: () async {
              adsWatch.selectedDestinationData = null;
              adsWatch.updateAgencyOwnAds(value);
              if(value == true){
                adsWatch.screenNavigationOnTabChange(0, ref);
              }else{
                adsWatch.screenNavigationOnTabChange(1, ref);
              }
              adsWatch.disposeApiData();
              if(adsWatch.isSelectedOwnAds == true){
                adsWatch.searchCtr.clear();
                adsWatch.adsListApi(context, false, agencyUuid: Session.getUuid(), isGetOnlyClient: false);
              } else {

                selectClientWatch.disposeController(isNotify : true);
                adsWatch.clientDataList = [];
                await selectClientWatch.clientListApi(context, false, isAdsAvailable: true).then((value){
                  if(selectClientWatch.clientListState.success?.status == ApiEndPoints.apiStatus_200){
                    adsWatch.updateClientList(selectClientWatch.clientListState.success?.data ?? []);
                  }
                });

              }
            },
            child: Container(
              height: context.height * 0.07,
              width: context.width * 0.08,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: adsWatch.isSelectedOwnAds == value ? AppColors.clr009AF1 : AppColors.clrD6D6D6),
                  color: adsWatch.isSelectedOwnAds == value ? AppColors.clr009AF1 : AppColors.clrF7F7FC
              ),
              alignment: Alignment.center,
              child: CommonText(title: title,textStyle: TextStyles.regular.copyWith(color: adsWatch.isSelectedOwnAds == value? AppColors.white : AppColors.clr626262,fontSize: 14.sp),),
            ),
          ),
        );
      }
    );
  }
}
