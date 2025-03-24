import 'package:citi_guide_app/core/theme/app_theme.dart';
import 'package:citi_guide_app/core/theme/theme_provider.dart';
import 'package:citi_guide_app/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>( 
      builder: (context, themeProvider, child){
        return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        initialRoute: Routes.onboarding,
        getPages: AppRoutes.pages,
      );
    }
    );
  }
}
