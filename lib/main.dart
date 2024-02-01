import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_app/Controllers/theme_controller.dart';
import 'package:instagram_app/Provider/user_provider.dart';
import 'package:instagram_app/Views/screens/auth/login_screen.dart';
import 'package:instagram_app/firebase_options.dart';
import 'package:instagram_app/locale/locale.dart';
import 'package:instagram_app/locale/locale_controller.dart';
import 'package:instagram_app/responsive/mobile_screen.dart';
import 'package:instagram_app/responsive/responsive.dart';
import 'package:instagram_app/responsive/web_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/widgets/loading_widgets.dart';

SharedPreferences? sharedPref;

void main() async {
  await GetStorage.init();
  sharedPref = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    MyLocaleController controller = Get.put(MyLocaleController());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeController().lightTheme,
        darkTheme: ThemeController().darkTheme,
        themeMode: ThemeController().getThemeMode(),
        locale: controller.initialLang,
        translations: MyLocale(),
        // home: LoginScreen(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Responsive(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
