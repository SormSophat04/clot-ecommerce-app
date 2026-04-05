enum FlavorType {
  dev,
  staging,
  prod,
}

class Flavor {
  static FlavorType appFlavor = FlavorType.dev;

  static bool isDev() => appFlavor == FlavorType.dev;
  static bool isStaging() => appFlavor == FlavorType.staging;
  static bool isProd() => appFlavor == FlavorType.prod;
}