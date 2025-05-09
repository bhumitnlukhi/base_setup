import 'package:chewie/chewie.dart';
import 'package:flutter/scheduler.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:video_player/video_player.dart';

class VideoImageCombineDemoWithSingleController extends StatefulWidget {
  final String videoUrl;
   const VideoImageCombineDemoWithSingleController(
      {super.key, this.title = appName, required this.videoUrl});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _VideoImageCombineDemoWithSingleControllerState();
  }
}

class _VideoImageCombineDemoWithSingleControllerState
    extends State<VideoImageCombineDemoWithSingleController> {

  /// Video Player Controller

  VideoPlayerController? videoPlayerController;

  ChewieController? chewieController;
  /// Current Index from List of Videos

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      videoPlayerController= VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await videoPlayerController!.initialize();
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: videoPlayerController?.value.size.aspectRatio,
        autoPlay: true,
        looping: false,
        controlsSafeAreaMinimum: EdgeInsets.zero,
        useRootNavigator: false,
        allowFullScreen: false
      );
      setState(() {});
    });
  }

  /// Dispose
  @override
  void dispose() {
    /// Dispose Controllers
    // _disposeControllers();
    chewieController?.dispose();
    super.dispose();
  }

  void _disposeControllers() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    chewieController = null;

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // color: Colors.black,
      title: widget.title,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: videoPlayer(),
      ),
    );
  }

  Widget videoPlayer() {
    return Stack(
      children: [
        Center(
          child: Container(
            color: AppColors.black,
            child: (chewieController != null && videoPlayerController != null && chewieController?.videoPlayerController != null)
                ? Chewie(
                  controller: chewieController!,
                )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
          ),
        ),
        InkWell(onTap: (){
          _disposeControllers();
          Navigator.pop(context);

        },child: Icon(Icons.close,color: AppColors.white,size: 20.h,))
      ],
    ).paddingAll(20);
  }
}
