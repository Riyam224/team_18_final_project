import 'package:team_18_final_project/core/constants/app_assets.dart';

class AppStrings {
  AppStrings._();

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

  static const onboardingTitle1Part1 = "Welcome To ";
  static const onboardingTitle1Part2 = "Crypto X";

  static const onboardingTitleSecurity = "Transaction Security";
  static const onboardingTitleMarket = "Fast And Reliable Market Updated";
  static const onboardingTitleGetStarted = "Get Started Now!";

  static const onboardingLogin = "Login";
  static const onboardingRegister = "Register";
  static const onboardingSkip = "Skip";

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

  static const loginToYourAccount = 'Login To Your Account';
  static const welcomeBack = "Welcome back you've\nbeen missed!";
  static const rememberMe = 'Remember me';
  static const forgetPassword = 'Forget Password?';
  static const loginButton = 'Login';
  static const orLoginWith = 'Or login with';
  static const dontHaveAccount = "Don't have an account? ";
  static const signUp = 'Sign Up';
  static const myAccount = 'My Account';
  static const manageYourProfile = 'Manage your profile';
  static const billingPayment = 'Billing/Payment';
  static const faqSupport = 'FAQ & Support';
  static const language = 'Language';

  // Billing/Payment Screen
  static const paymentMethods = 'Payment Methods';
  static const primaryCard = 'Primary Card';
  static const backupCard = 'Backup Card';
  static const cardVisa = 'Visa';
  static const cardMastercard = 'Mastercard';
  static const billing = 'Billing';
  static const viewInvoices = 'View Invoices';
  static const addNewPaymentMethod = 'Add new payment method';
  static const managePaymentDetails = 'Manage payment details';
  static const cardNumberHidden = '**** **** **** ';

  // FAQ & Support Screen
  static const popularQuestions = 'Popular questions';
  static const needMoreHelp = 'Need more help?';
  static const startChat = 'Start a chat';
  static const supportResponseTime = 'Our team typically replies within a few hours.';
  static const faqUpdateBillingQuestion = 'How do I update my billing method?';
  static const faqUpdateBillingAnswer = 'Go to Billing/Payment in Settings and tap "Add new payment method".';
  static const faqExportInvoicesQuestion = 'Can I export my invoices?';
  static const faqExportInvoicesAnswer = 'Yes, download a PDF copy from the invoices list.';
  static const faqContactSupportQuestion = 'How do I contact support?';
  static const faqContactSupportAnswer = 'Use the contact form below or email support@fintech.app.';
  static const darkMode = 'Dark Mode';
  static const contactSupport = 'Contact Support';
  static const security = 'Security';
  static const enableBiometrics = 'Enable Biometrics';
  static const enableBiometricsHint = 'Use Face ID / Touch ID to unlock';
  static const autoLockTimeout = 'Auto-lock timeout';
  static String autoLockSubtitle(int minutes) =>
      'After $minutes minutes of inactivity';
  static const minutesShort = 'min';
  static const saveChanges = 'Save changes';
  static const requiredField = 'Required';
  static const chooseAvatar = 'Choose an avatar';

  static const setYourFingerPrint = 'Set Your Finger Print';
  static const addFingerprintSecure =
      'Add a fingerprint to make your account\nmore secure.';
  static const placeFingerprintInstruction =
      'Place your finger in fingerprint\nsensor until the icon completely';
  static const skipFingerprint = 'Skip';

  static const yourScanningIsComplete = 'Your scanning is complete';
  static const youWillBeAbleToSignIn =
      'you will be able to sign in by using fingerprint';
  static const continueButton = 'Continue';

  static const setYourFaceID = 'Set Your Face ID';
  static const addFaceIDSecure =
      'Add your face ID to make your account more secure.';
  static const faceID = 'Face ID';

  static const placeFaceIDInstruction =
      'Place your face ID in face\nscanner until the icon completely';
  static const faceIDScanComplete =
      'Once your scanning is complete, you will be able to sign in by using face ID';

  static const youreReady = "You're Ready!";

  static const touchIdVerifyTitle = "Touch ID sensor to verify yourself";

  static const touchIdFooter =
      "Please verify your identity using touch ID and it will proceed automatically.";

  static const youreVerified = "You're verified";
  static const verificationComplete =
      "You have been verified your \ninformation completely. Let's make \n transactions!";
  static const continueToHome = "Continue To Home";

  static const faceIDPleaseWaitLogin =
      "Please wait until your scanning is complete";

  static const verificationCompleteTransactions =
      "You have been verified your information completely. Let's make transactions!";

  static const faceIDPleaseWaitScanning =
      "Please wait until your scanning is\ncomplete";

  static const currentBalance = 'Current Balance';
  static const weeklyProfit = 'Weekly Profit';
  static const retry = 'Retry';
  static const noTrendingCoinsAvailable = 'No trending coins available';
  static const noTopGainersAvailable = 'No top gainers available';

  static String greetingTemplate(String userName) => "Hi $userName";

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
  static const biometricLoginTitle = 'Biometric Login';
  static const biometricLoginNotAvailable =
      'Biometric login is not available. Please enable biometrics on your device and in settings, or use your password.';
  static const biometricNotEnrolledForAccount =
      'Biometric login is not set up for this account. Log in with email and password, then enable biometrics in My Account.';
  static const biometricStoredCredentialsInvalid =
      'Stored biometric login is missing valid credentials. Please log in with email and password once to refresh biometric login.';
  static const ok = 'OK';

  static const authNoAccountFound = 'No account found with this email.';
  static const authInvalidCredentials = 'Invalid email or password.';
  static const authEmailExists = 'An account with this email already exists.';
  static const authWeakPassword = 'Weak password.';
  static const authInvalidEmail = 'Invalid email.';
  static const authNetworkError = 'Network error.';
  static const authTooManyRequests = 'Too many attempts. Try later.';
  static const authAccountDisabled = 'Account disabled.';

  static const fingerprintAuthFailed = 'Fingerprint authentication failed';
  static const faceIDAuthFailed = 'Face ID authentication failed';

  static const authenticateSetupFingerprint =
      'Authenticate to set up fingerprint';
  static const authenticateSetupFaceID = 'Authenticate to set up Face ID';

  static String errorTemplate(String error) => 'Error: $error';

  static const profile = 'Profile';
  static const avatarDescription =
      'Avatar will use a default image until you choose a new one.';
  static const securityWarningFooter =
      'For your security, avoid using this app on rooted or jailbroken devices.';

  static const notFound = '404 Not Found';

  static const appTitle = 'Team 18 Fintech';

  static const unlockWithBiometrics = 'Unlock with Biometrics';
  static const authenticateToUnlock = 'Authenticate to unlock the app';

  static const String bitcoin = 'Bitcoin';
  static const String buttonBuyCrypto = 'Continue';
  static const String buyCrypto = 'Buy Crypto';
  static const String coinDetails = 'Coin Details';
  static const String percentage = '15.3%';
  static const String feePercentageText = '0.05%';
  static const String btc = '/ 1 BTC';
  static const String validTill = 'Valid till';
  static const String cardNumber = '••••  ••••  ••••  3456';
  static const String cardHolderName = 'NAME SURNAME';
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

  static const String portfolioTitle = 'Portfolio';
  static const String totalValue = 'Total Value';
  static const String myHoldings = 'My Holdings';
  static const String recentTransactions = 'Recent Transactions';
  static const String buyBitcoin = 'Buy Bitcoin';
  static const String sellEthereum = 'Sell Ethereum';
  static const String buyTransaction = 'Buy';
  static const String sellTransaction = 'Sell';
  static const String hour = 'hour';
  static const String hours = 'hours';
  static const String day = 'day';
  static const String days = 'days';
  static const String ago = 'ago';
  static const String hoursAgo = 'hours ago';
  static const String dayAgo = 'day ago';
  static const String daysAgo = 'days ago';
  static const List<String> monthsShort = [
    'Nov',
    'Dec',
    'Jan',
    'Feb',
    'Mar',
    'Apr'
  ];

  static const String greeting = 'Hi, riyam 👋';
  static const String marketCap = 'Market Cap';
  static const String volume24h = '24h Volume';
  static const String btcDominance = 'BTC Dominance';
  static const String activeCoins = 'Active Coins';
  static const String ethereum = 'Ethereum';
  static const String binanceCoin = 'Binance Coin';
  static const String litecoin = 'Litecoin';
  static const String marketOverview = 'Market Overview';
  static const String trendingNow = 'Trending Now';
  static const String topGainers = 'Top Gainers';
  static const String viewAll = 'View all';
}
