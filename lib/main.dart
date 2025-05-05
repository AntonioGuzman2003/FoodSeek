import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final cameras = await availableCameras();
    Get.put(NavigationService(cameras: cameras));
  runApp(NetworkManager(
    child: MyApp(
      cameras: cameras,
    )));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key,required this.cameras});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      translations: Messages(),
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return HomeView(
                cameras: cameras,
              ); // Usuario autenticado
            } else {
              return HomeView(
                cameras: cameras,
              ); // Usuario autenticado
            }
          }
          // Mientras espera, muestra un indicador de carga
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      supportedLocales: [
        Locale('en', 'US'), //Ingles
        Locale('es', 'ES'), // Español
        Locale('fr', 'FR'), // Frances
        Locale('pt', 'BR'), // Portugues
        Locale('de', 'DE'), // Aleman
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Get.locale ?? Locale('en', 'US'),
    );
  }
}
