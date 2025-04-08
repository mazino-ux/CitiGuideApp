import 'package:citi_guide_app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:citi_guide_app/core/theme/theme_provider.dart';
import 'package:citi_guide_app/app.dart';
import 'package:citi_guide_app/presentation/home/faq/faq_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase with secure API keys
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  await GetStorage.init();
  Get.put(ThemeController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (_, child) {
        return ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: 'City Guide',
                theme: ThemeData(primarySwatch: Colors.deepPurple),
                debugShowCheckedModeBanner: false,
                home: const App(),
                routes: {
                  '/faq': (context) => const FAQPage(),
                },
              );
            },
          ),
        );
      },
      child: const App(),
    );
  }
}