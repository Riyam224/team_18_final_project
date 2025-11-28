class AppStrings {
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

  // Navigation
  static const home = 'Home';
  static const market = 'Market';
  static const portfolio = 'Portfolio';
  static const settings = 'Settings';

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
  static String greetingTemplate(String userName) => "Hi, $userName 👋";

  // Auth - Registration & Login Messages
  static const registrationSuccessful = 'Registration Successful';
  static const biometricSetupQuestion = 'Would you like to set up biometric authentication?';
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

  // Error Template
  static String errorTemplate(String error) => 'Error: $error';

  // Settings Screen
  static const profile = 'Profile';
  static const avatarDescription = 'Avatar will use a default image until you choose a new one.';
  static const securityWarningFooter =
      'For your security, avoid using this app on rooted or jailbroken devices.';

  // Common
  static const notFound = '404 Not Found';
}
