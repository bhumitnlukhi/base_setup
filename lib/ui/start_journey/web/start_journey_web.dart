import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/start_journey/start_journey_controller.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/robot_widget.dart';
import 'package:odigo_vendor/ui/start_journey/web/helper/selection_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class StartJourneyWeb extends ConsumerStatefulWidget {
  const StartJourneyWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<StartJourneyWeb> createState() => _StartJourneyWebState();
}

class _StartJourneyWebState extends ConsumerState<StartJourneyWeb> {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final startJourneyWatch = ref.watch(startJourneyController);
      if (Session.getNewFCMToken().isEmpty) {
        String? fcmToken;
        try {
          fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await Session.saveLocalData(keyNewFCMToken, fcmToken);
            showLog('NEW Token Saved:${Session.getNewFCMToken()} ');
          }
        } catch (e) {
          showLog(e.toString());
        }
      }
      startJourneyWatch.disposeController(isNotify: true);
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: RobotWidget()),
        Expanded(child: SelectionWidget()),
      ],
    );
  }
}
