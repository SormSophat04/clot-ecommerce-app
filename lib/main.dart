import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/config/flavor.dart';
import 'core/routes/app_routes.dart';
import 'core/security/app_security_service.dart';
import 'core/theme/app_theme.dart';
import 'data/sources/local/storage_service.dart';

Future<void> mainFlavor() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());

  final securityService = Get.put(AppSecurityService(), permanent: true);
  final securityState = await securityService.initialize(
    protectScreenCapture: Flavor.isProd(),
  );
  final initialRoute = Flavor.isProd() && !securityState.isTrustedDevice
      ? Routes.securityBlocked
      : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
