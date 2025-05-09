import 'package:flutter/scheduler.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';

class ImageDialog extends StatefulWidget {
  final String imageUrl;
  const ImageDialog({super.key, required this.imageUrl});

  @override
  State<StatefulWidget> createState() {
    return _ImageDialogState();
  }
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: imageWidget(),
      ),
    );
  }

  Widget imageWidget() {
    return Stack(
      children: [
        Center(
          child: Container(
              color: AppColors.black,
              child: CacheImage(
                imageURL: widget.imageUrl,
                contentMode: BoxFit.fitHeight,
                placeholderImage: Assets.svgs.svgImagePlaceholder.keyName,
              )),
        ),
        InkWell(onTap: (){
          Navigator.pop(context);

        },child: Icon(Icons.close,color: AppColors.white,size: 20.h,))
      ],
    ).paddingAll(20.h);
  }
}
