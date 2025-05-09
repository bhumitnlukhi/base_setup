import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/common_radio_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class ContentLengthWidget extends ConsumerStatefulWidget {
  const ContentLengthWidget({super.key});

  @override
  ConsumerState<ContentLengthWidget> createState() => _ContentLengthWidgetState();
}

class _ContentLengthWidgetState extends ConsumerState<ContentLengthWidget> with BaseConsumerStatefulWidget {

  MediaTypeEnum? mediaType;

  @override
  Widget buildPage(BuildContext context) {
    final addEditAdsWatch = ref.watch(addEditAdsController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CommonRadioWidget(name: '10',isSelect: addEditAdsWatch.selectedContentLength == ContentLengthEnum.ten,onTap:  (){
          addEditAdsWatch.onRadioUpdateContentLengthType(ContentLengthEnum.ten);
        }),

        SizedBox(width: context.width * 0.02,),

        CommonRadioWidget(name: '15',isSelect: addEditAdsWatch.selectedContentLength == ContentLengthEnum.fifteen,onTap: (){
          addEditAdsWatch.onRadioUpdateContentLengthType(ContentLengthEnum.fifteen);
        }),

        SizedBox(width: context.width * 0.02,),

        CommonRadioWidget(name: '30',isSelect: addEditAdsWatch.selectedContentLength == ContentLengthEnum.thirty,onTap: (){
          addEditAdsWatch.onRadioUpdateContentLengthType(ContentLengthEnum.thirty);
        }),

      ],
    );
  }
}
