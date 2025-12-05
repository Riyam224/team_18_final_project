class AppPortfolioConstants {
  AppPortfolioConstants._();

  static const Map<int, int> monthIndexToDays = {
    0: 30,
    1: 60,
    2: 90,
    3: 120,
    4: 150,
    5: 180,
  };

  static const int defaultMonthIndex = 1;
  static const int defaultDays = 30;
  static const String changeLabelSuffix = 'Today';
  static const String positivePrefix = '+';
  static const String percentSuffix = '%';
  static const int hoursInDay = 24;
  static const int daysInWeek = 7;
  static const String dateFormat = 'MMM d, yyyy';
  static const int decimalDigitsForCurrency = 2;
  static const int decimalDigitsForPercent = 2;
  static const int decimalDigitsForChangePercent = 1;
  static const int decimalDigitsForAllocationPercent = 0;
  static const int zeroValue = 0;
  static const int oneValue = 1;
  static const int percentageMultiplier = 100;
  static const int priceDataIndex = 1;
  static const int minArrayLength = 2;
}
