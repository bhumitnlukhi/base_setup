import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/wallet/wallet_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ClientListWidget extends StatelessWidget with BaseStatelessWidget{
  const ClientListWidget({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // final selectClientWatch = ref.watch(selectClientController);
        final walletWatch = ref.watch(walletController);

        return ListView.separated(
          itemCount: walletWatch.clientList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final data = walletWatch.clientList[index];
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColors.white
              ),
              child: Row(
                children: [
                  ///Name
                  Expanded(
                    flex: 3,
                    child: CommonText(title: data?.name??'',
                      maxLines: 2,
                      textStyle: TextStyles.regular.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.black
                      ),
                    ),
                  ),

                  // const Spacer(),

                  ///Amount
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: context.width*0.035,
                      // child: CommonText(title: '${Session.getCurrency()} ${NumberFormatter.formatter((data?.wallet??'').toString())}',
                      child: CommonText(title: '${Session.getCurrency()} ${(data?.wallet??'').toString()}',
                        textStyle: TextStyles.regular.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.primary2
                        ),
                        maxLines: 4,
                      ),
                    ).paddingOnly(right: context.width*0.02,left: context.width*0.005),
                  ),

                  ///Right Arrow
                  InkWell(
                    onTap: () async {

                      walletWatch.disposeWalletHistoryData();
                      walletWatch.updateSelectedClientInList(data);
                      walletWatch.updateSelectedType(context,  TransactionType.ALL);
                      walletWatch.filterChanged();
                      await walletWatch.transactionHistoryListApi(context, false, clientMasterUuid: data?.uuid??''
                      );
                    },
                    child: CommonSVG(strIcon: Assets.svgs.svgRightWithBackground.keyName,
                      height: context.height*0.040,
                      width: context.width*0.040,isRotate: true,),
                  )
                ],
              ).paddingSymmetric(horizontal: context.width * 0.016, vertical: context.height * 0.025),
            );
          }, separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: context.height * 0.02,
          );
        },);
      }
    );
  }
}
