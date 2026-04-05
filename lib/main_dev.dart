import 'package:clot_ecommerce_app/core/config/app_config.dart';
import 'package:clot_ecommerce_app/core/config/flavor.dart';
import 'package:clot_ecommerce_app/main.dart';

void main(){
  AppConfig.init(Flavor.appFlavor = FlavorType.dev);
  mainFlavor();
}