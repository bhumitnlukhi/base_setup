import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/common_radio_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class MediaTypeWidget extends ConsumerStatefulWidget {
  const MediaTypeWidget({super.key});

  @override
  ConsumerState<MediaTypeWidget> createState() => _MediaTypeWidgetState();
}

class _MediaTypeWidgetState extends ConsumerState<MediaTypeWidget> with BaseConsumerStatefulWidget {

  MediaTypeEnum? mediaType;

  @override
  Widget buildPage(BuildContext context) {
    final addEditAdsWatch = ref.watch(addEditAdsController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CommonRadioWidget(name: LocaleKeys.keyImage.localized,isSelect: addEditAdsWatch.selectedMediaType == MediaTypeEnum.image,onTap:  (){
          addEditAdsWatch.onRadioUpdateMediaType(MediaTypeEnum.image);
        }),

        SizedBox(width: context.width * 0.02,),

        CommonRadioWidget(name: LocaleKeys.keyVideo.localized,isSelect: addEditAdsWatch.selectedMediaType == MediaTypeEnum.video,onTap: (){
          addEditAdsWatch.onRadioUpdateMediaType(MediaTypeEnum.video);
        }),

      ],
    );
  }
}
