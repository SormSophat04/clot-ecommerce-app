import 'package:clot_ecommerce_app/core/config/env_config.dart';
import 'package:clot_ecommerce_app/core/config/flavor.dart';

class AppConfig {
  static late FlavorType flavorType;
  static late EnvConfig envConfig;

  static void init(FlavorType f) {
    flavorType = f;
    switch (f) {
      case FlavorType.dev:
        envConfig = const EnvConfig(
          apiBaseUrl: "http://10.0.2.2:8080",
          appName: "Clot Dev",
          enbaleLog: true,
        );
        break;
      case FlavorType.staging:
        envConfig = const EnvConfig(
          apiBaseUrl: "https://api.staging.clot.com",
          appName: "Clot Staging",
          enbaleLog: true,
        );
        break;
      case FlavorType.prod:
        envConfig = const EnvConfig(
          apiBaseUrl: "https://api.prod.clot.com",
          appName: "Clot Prod",
          enbaleLog: false,
        );
        break;
    }
  }
}
