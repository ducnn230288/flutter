import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '/constants/index.dart';
import '/cubit/index.dart';
import '/firebase_options.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initFirebase();
    context.read<AuthC>().check(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthC, AuthS>(
          listenWhen: (oldState, newState) => newState.status != AppStatus.init,
          listener: (context, state) {
            Future.delayed(const Duration(milliseconds: 30), () {
              CSpace.setScreenSize(context);
              GoRouter.of(context).goNamed(state.status == AppStatus.fails ? CRoute.introduction : CRoute.home);
            });
          },
          builder: (context, state) => Center(
                child: CIcon.logo,
              )),
    );
  }

  Future<RemoteMessage?> initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      debugPrint('Đã kết nối với Firebase');
      // FirebaseMessaging messaging = FirebaseMessaging.instance;
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');
        if (message.notification != null) {
          debugPrint('Message notification: ${message.notification}');
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      final String aPNSToken = await FirebaseMessaging.instance.getAPNSToken() ?? '';
      debugPrint('fcmToken ----------------- $fcmToken');
      debugPrint('APNSToken ----------------- $aPNSToken');
      await FirebaseMessaging.instance.subscribeToTopic('myTopic');
      final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
      return message;
    } catch (e) {
      debugPrint('Không thể kết nối với Firebase: $e');
    }
    return null;
  }

  void handleMessage(RemoteMessage message) {
    if (message.data['id'] != null && message.data['id'] != '') {
      // Navigator.pushNamedAndRemoveUntil(
      //   Utils.navigatorKey.currentState!.context,
      //   RoutesName.PROPERTY_SEE_DETAILS,
      //   arguments: message.data['id'],
      //       (route) => false,
      // );
    }
  }
}
