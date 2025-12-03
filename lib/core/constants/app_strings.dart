import 'package:team_18_final_project/core/constants/app_assets.dart';

class AppStrings {
  AppStrings._();

  // Navigation
  static const home = 'Home';
  static const market = 'Market';
  static const portfolio = 'Portfolio';
  static const settings = 'Settings';
  static const creditCard = 'Credit Card';
  static const googlePay = 'Google Pay';
  static const mobileBanking = 'Mobile Banking';
  static const sendReceiptToYourEmail = 'Send receipt to your email';
  static const play = 'Play';
  static const dEBIT = 'DEBIT';
  static const paymentMethod = 'Payment method';

  // Onboarding
  // ---------- Special split title (Screen 1) ----------
  static const onboardingTitle1Part1 = "Welcome To ";
  static const onboardingTitle1Part2 = "Crypto X";

  // ---------- Normal onboarding titles ----------
  static const onboardingTitleSecurity = "Transaction Security";
  static const onboardingTitleMarket = "Fast And Reliable Market Updated";
  static const onboardingTitleGetStarted = "Get Started Now!";

  // Onboarding Buttons (used on onboarding screens)
  static const onboardingLogin = "Login";
  static const onboardingRegister = "Register";
  static const onboardingSkip = "Skip";

  // Auth - Register Screen
  static const createYourAccount = 'Create Your Account';
  static const signUpToEnjoy = 'Sign up to enjoy the best managing experience!';
  static const firstName = 'First Name';
  static const lastName = 'Last Name';
  static const emailId = 'Email-ID';
  static const password = 'Password';
  static const confirmPassword = 'Confirm Password';
  static const phoneNumberPlaceholder = 'XXX XXX XXXX';
  static const register = 'Register';
  static const alreadyHaveAccount = 'Already have an account? ';
  static const login = 'login';

  // Auth - Login Screen
  static const loginToYourAccount = 'Login To Your Account';
  static const welcomeBack = "Welcome back you've\nbeen missed!";
  static const rememberMe = 'Remember me';
  static const forgetPassword = 'Forget Password?';
  static const loginButton = 'Login';
  static const orLoginWith = 'Or login with';
  static const dontHaveAccount = "Don't have an account? ";
  static const signUp = 'Sign Up';

  // Auth - Fingerprint Setup Screen
  static const setYourFingerPrint = 'Set Your Finger Print';
  static const addFingerprintSecure =
      'Add a fingerprint to make your account\nmore secure.';
  static const placeFingerprintInstruction =
      'Place your finger in fingerprint\nsensor until the icon completely';
  static const skipFingerprint = 'Skip';

  // Auth - Fingerprint Success Screen
  static const yourScanningIsComplete = 'Your scanning is complete';
  static const youWillBeAbleToSignIn =
      'you will be able to sign in by using fingerprint';
  static const continueButton = 'Continue';

  // Auth - FaceID Setup Screen
  static const setYourFaceID = 'Set Your Face ID';
  static const addFaceIDSecure =
      'Add your face ID to make your account more secure.';
  static const faceID = 'Face ID';

  // Auth - FaceID Scanning Screen
  static const placeFaceIDInstruction =
      'Place your face ID in face\nscanner until the icon completely';
  static const faceIDScanComplete =
      'Once your scanning is complete, you will be able to sign in by using face ID';

  // Auth - FaceID Success Screen
  static const youreReady = "You're Ready!";

  // login face id verification
  static const touchIdVerifyTitle = "Touch ID sensor to verify yourself";

  static const touchIdFooter =
      "Please verify your identity using touch ID and it will proceed automatically.";

  // Login Success Screen
  static const youreVerified = "You're verified";
  static const verificationComplete =
      "You have been verified your \ninformation completely. Let's make \n transactions!";
  static const continueToHome = "Continue To Home";

  static const faceIDPleaseWaitLogin =
      "Please wait until your scanning is complete";

  // Login FaceID Verify Screen
  static const verificationCompleteTransactions =
      "You have been verified your information completely. Let's make transactions!";

  // Login FaceID Scanning Screen
  static const faceIDPleaseWaitScanning =
      "Please wait until your scanning is\ncomplete";

  // Home Screen
  static const currentBalance = 'Current Balance';
  static const weeklyProfit = 'Weekly Profit';
  static const retry = 'Retry';
  static const noTrendingCoinsAvailable = 'No trending coins available';
  static const noTopGainersAvailable = 'No top gainers available';

  // Greeting Template
  static String greetingTemplate(String userName) => "Hi $userName";

  // Auth - Registration & Login Messages
  static const registrationSuccessful = 'Registration Successful';
  static const biometricSetupQuestion =
      'Would you like to set up biometric authentication?';
  static const skipButton = 'Skip';
  static const setupButton = 'Set Up';
  static const creatingAccount = 'Creating Account...';
  static const loggingIn = 'Logging in...';
  static const processing = 'Processing...';
  static const verifyingFingerprint = 'Verifying fingerprint...';
  static const authenticationComplete = 'Authentication complete';

  // Auth - Biometric Error Messages
  static const fingerprintAuthFailed = 'Fingerprint authentication failed';
  static const faceIDAuthFailed = 'Face ID authentication failed';

  // Auth - Biometric Setup Localized Reasons
  static const authenticateSetupFingerprint =
      'Authenticate to set up fingerprint';
  static const authenticateSetupFaceID = 'Authenticate to set up Face ID';

  // Error Template
  static String errorTemplate(String error) => 'Error: $error';

  // Settings Screen
  static const profile = 'Profile';
  static const avatarDescription =
      'Avatar will use a default image until you choose a new one.';
  static const securityWarningFooter =
      'For your security, avoid using this app on rooted or jailbroken devices.';

  // Common
  static const notFound = '404 Not Found';

  // App Metadata
  static const appTitle = 'Team 18 Fintech';

  // App Lock Screen
  static const unlockWithBiometrics = 'Unlock with Biometrics';
  static const authenticateToUnlock = 'Authenticate to unlock the app';

  // Market Strings
  static const String bitcoin = 'Bitcoin';
  static const String buttonBuyCrypto = 'Continue';
  static const String buyCrypto = 'Buy Crypto';
  static const String coinDetails = 'Coin Details';
  static const String percentage = '15.3%';
  static const String feePercentageText = '0.05%';
  static const String btc = '/ 1 BTC';
  static const String validTill = 'Valid till';
  static const String cardNumber = '••••  ••••  ••••  3456';
  // static const String cardHolderName = 'Arafat Alam';
  static const String cardHolderName = 'NAME SURNAME';
  // static const String cardExpiry = '09/24';
  static const String cardExpiry = 'MM/YY';
  static const String priceDisplay = '\$54,382.64';
  static const String exchangeAmount = '\$26';
  static const String sell = 'Sell';
  static const String buy = 'Buy';
  static const String professional = 'professional';
  static const String aboutBitcoin = 'About Bitcoin';
  static const String appFontNameLato = 'Lato';
  static const String statics = 'Statics';
  static const String paymentTitleYouPay = 'You Pay';
  static const String paymentTitleYouReceive = 'You Receive';
  static const String paymentPriceYouPay = '\$1,800.00';
  static const String paymentPriceYouReceive = '0.9876';
  static const String cryptoExchangeRate = '1 USD = 0.00078 ETH';
  static const String circle = '•';
  static const String exchangeFee = 'Exchange fee';
  static final List cards = [
    AppAssets.visaLogo,
    AppAssets.mastercardLogo,
    AppAssets.applePayLogo,
  ];

  static const String bitcoinDescription =
      "Bitcoin is a decentralized cryptocurrency originally described in a 2008 whitepaper by a person, or group of people, using the alias Satoshi Nakamoto. It was launched soon after, in January 2009.";

  static const List<String> items = ['1h', '1d', '1w', '1m', '1y'];
  static const List<Map<String, String>> marketStats = [
    {'Current Price': '44,826.12 \$'},
    {'Market Cap': '836,819 \$'},
    {'Volume 24h': '35,867 \$'},
    {'Available Supply': '18,784'},
    {'Max Supply': '21,000'},
  ];
  static final List<String> currencies = [
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'HKD',
    'NZD',
    'BTC',
    'ETH',
    'USDT',
    'BNB',
    'ADA',
    'SOL',
    'XRP',
    'DOGE',
    'DOT',
    'MATIC',
    'LTC',
    'LINK',
    'SHIB',
    'TRX',
    'AVAX',
    'ATOM',
    'XLM',
    'ALGO',
    'FTT',
  ];
}
