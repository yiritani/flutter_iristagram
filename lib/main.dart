import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iristagram/firebase_options.dart';
import 'package:flutter_iristagram/providers/user_provider.dart';
import 'package:flutter_iristagram/responsive/mobile_screen_layout.dart';
import 'package:flutter_iristagram/responsive/responsive_layout_screen.dart';
import 'package:flutter_iristagram/responsive/web_screen_layout.dart';
import 'package:flutter_iristagram/screens/login_screen.dart';
import 'package:flutter_iristagram/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                        mobileScreenLayout: MobileScreenLayout(),
                        webScreenLayout: WebScreenLayout());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const LoginScreen();
              })),
    );
  }
}
