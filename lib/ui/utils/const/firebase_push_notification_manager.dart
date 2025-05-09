// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:odigo_vendor/framework/utils/session.dart';
// import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
// import 'package:odigo_vendor/ui/utils/theme/theme.dart';
//
// /// Server Key
// ///
// class FirebasePushNotificationManager {
//   FirebasePushNotificationManager._privateConstructor();
//
//   static final FirebasePushNotificationManager instance =
//       FirebasePushNotificationManager._privateConstructor();
//
//   factory FirebasePushNotificationManager() {
//     return instance;
//   }
//
//   /// Initial code for main.dart void main
//   Future<void> setupInteractedMessage(WidgetRef ref) async {
//     // await Firebase.initializeApp();
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
//     enableIOSNotifications();
//     await registerNotificationListeners(ref);
//     String? fcmToken = await FirebaseMessaging.instance.getToken();
//     print('token:::::::::::::::: $fcmToken');
//
//     Session.saveLocalData(keyDeviceFCMToken, fcmToken);
//   }
//
//   Future<void> registerNotificationListeners(WidgetRef ref) async {
//     /// Flutter Local Notification
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//
//     /// Android Setup
//     ///
//     final AndroidNotificationChannel channel = androidNotificationChannel();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//
//     /// Add Notification app icon
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@drawable/ic_app_icon');
//
//     /// Sound and other permissions for IOS Side
//     const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//
//     /// Initialize Notification for both platform
//     const InitializationSettings initSettings =
//         InitializationSettings(android: androidSettings, iOS: iOSSettings);
//     flutterLocalNotificationsPlugin.initialize(initSettings,
//
//         /// On get Notification
//         // onDidReceiveNotificationResponse: ,
//         // onSelectNotification: ,
//         onDidReceiveNotificationResponse: (payload) async {
//       Map<String, dynamic> data = jsonDecode(payload.payload??'');
//       onReceiveNotification(data,ref);
//     });
//
//
//
//     ///Received Notification click event after App killed state
//     FirebaseMessaging.onBackgroundMessage((message) async {
//       print(
//           '....getInitialMessage.....data...........${json.encode(message.data)}');
//       return onReceiveNotification(message.data,ref);
//     });
//
//     ///Received Notification click event after background notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       showLog(
//           '....onMessageOpenedApp.....data...........${json.encode(message.data)}');
//       // RemoteNotification? notification = message.notification;
//       showLog('Create notification object');
//       onReceiveNotification(message.data, ref);
//     });
//
//     /// when app is running in foreground so need to fire local notification
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       showLog(
//           'when app is running in foreground so need to fire local notification');
//       RemoteNotification? notification = message.notification;
//       showLog('Create notification object');
//       showLog('message.notification ${message.notification?.android?.imageUrl}');
//       showLog('message ${message}');
//       showLog('message data ${message.data.entries.toList()}');
//
//       if (notification != null) {
//         showLog(
//             '....onMessage.....data...........${json.encode(message.data)}');
//         http.Response response;
//         BigPictureStyleInformation? bigPictureStyleInformation;
//         AndroidNotificationDetails? androidNotificationDetailsNormal;
//         if(message.notification?.android?.imageUrl?.isNotEmpty == true) {
//           showLog('we are here foreground if part');
//           response = await http.get(Uri.parse(message.notification?.android?.imageUrl.toString() ?? ''));
//           bigPictureStyleInformation =
//               BigPictureStyleInformation(
//                 ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
//                 hideExpandedLargeIcon: true,
//               );
//           androidNotificationDetailsNormal = AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             styleInformation: bigPictureStyleInformation,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: '@drawable/ic_app_icon',
//             color: AppColors.white,
//           );
//
//         } else {
//           showLog('we are here foreground else part');
//           androidNotificationDetailsNormal = AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             // TODO add a proper drawable resource to android, for now using
//             //      one that already exists in example app.
//             icon: '@drawable/ic_app_icon',
//             color: AppColors.white,
//           );
//         }
//
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: androidNotificationDetailsNormal,
//
//               // iOS: const IOSNotificationDetails(),
//             ),
//             payload: jsonEncode(message.data));
//       }
//     });
//   }
//
//   Future<void> enableIOSNotifications() async {
//     await FirebaseMessaging.instance
//         .requestPermission(alert: true, badge: true, sound: true);
//
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//     // FirebaseMessaging.
//   }
//
//   /// Android
//   AndroidNotificationChannel androidNotificationChannel() =>
//       const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         description:
//             'This channel is used for important notifications.', // description
//         importance: Importance.max,
//       );
//
//   onReceiveNotification(Map<String, dynamic> message,WidgetRef ref) async {
//     var module = message['module'];
//     String id = message['orderUuid']; //orderId
// //    String ids = message['data']['ids']; //orderId
//
//     print('---Module from notification json-----$module');
//     print('---Module from notification json-----$id');
//     // print("---Orderid from notification json-----${id}");
//     print('---Orderid from notification json-----');
//
//     var slug = message['slug'];
//     showLog('slug $slug');
//
//     var dataId = message['data_id'];
//     showLog('data id ${dataId.runtimeType}');
//
//     // if(module.contains("Orders")) {
//     //   await dashBoardProviderWatch.getDashboardData(context);
//     //   Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(id:id),),);
//     // }
//     // else if(module.contains("Accept Order")) {
//     //   await dashBoardProviderWatch.getDashboardData(context);
//     //   Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(id: id),),);
//     // }
//     // else if(module.contains("Ticket")) {
//     //   // Navigator.push(context,
//     //   //   MaterialPageRoute(builder: (context) => TicketsScreen(fromNotification: true,),),);
//     // }
//     // else if(module.contains("Payout")) {
//     //   Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailScreen(paymentDetailId: id),),);
//     // }
//   }
// }
//
