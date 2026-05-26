import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CapCat'**
  String get appTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonErrorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get commonErrorTryAgain;

  /// No description provided for @forgotPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your number with us!'**
  String get forgotPhoneTitle;

  /// No description provided for @forgotPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number so we can recognize you!'**
  String get forgotPhoneSubtitle;

  /// No description provided for @forgotPhoneContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get forgotPhoneContinue;

  /// No description provided for @forgotOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number'**
  String get forgotOtpTitle;

  /// No description provided for @forgotOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code we sent to {phone}'**
  String forgotOtpSubtitle(Object phone);

  /// No description provided for @forgotOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get forgotOtpHint;

  /// No description provided for @forgotOtpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get forgotOtpResend;

  /// No description provided for @forgotOtpIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get forgotOtpIn;

  /// No description provided for @forgotOtpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get forgotOtpConfirm;

  /// No description provided for @forgotNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it secret, set a new password!'**
  String get forgotNewPasswordTitle;

  /// No description provided for @forgotNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password twice so we know you’ll remember it!'**
  String get forgotNewPasswordSubtitle;

  /// No description provided for @forgotNewPasswordRulesError.
  ///
  /// In en, this message translates to:
  /// **'Your new password doesn’t meet all 3 requirements.'**
  String get forgotNewPasswordRulesError;

  /// No description provided for @forgotNewPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords don’t match.'**
  String get forgotNewPasswordMismatch;

  /// No description provided for @forgotNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get forgotNewPasswordHint;

  /// No description provided for @forgotNewPasswordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get forgotNewPasswordConfirmHint;

  /// No description provided for @forgotNewPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get forgotNewPasswordButton;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized pet profile'**
  String get introTitle;

  /// No description provided for @introDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a personalized profile for each of your beloved pets on PawBuddy. Share their name, breed, and age while connecting with a vibrant community.'**
  String get introDescription;

  /// No description provided for @introStart.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get introStart;

  /// No description provided for @socialPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get socialPhoneTitle;

  /// No description provided for @socialPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number to complete sign in.'**
  String get socialPhoneSubtitle;

  /// No description provided for @phoneRegisterOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your phone, we sent a code to {phone}.'**
  String phoneRegisterOtpSubtitle(Object phone);

  /// No description provided for @toastLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get toastLoginSuccess;

  /// No description provided for @toastLinkLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Linked login successfully'**
  String get toastLinkLoginSuccess;

  /// No description provided for @toastRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registered successfully'**
  String get toastRegisterSuccess;

  /// No description provided for @toastLinkRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'Linked registration successful'**
  String get toastLinkRegisterSuccess;

  /// No description provided for @toastChangePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get toastChangePasswordSuccess;

  /// No description provided for @tabLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get tabLogin;

  /// No description provided for @tabRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get tabRegister;

  /// No description provided for @signInPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signInPasswordHint;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signInButton;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get signInTitle;

  /// No description provided for @signInDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your login information to continue.'**
  String get signInDescription;

  /// No description provided for @signInPhoneEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get signInPhoneEmpty;

  /// No description provided for @signInPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get signInPasswordEmpty;

  /// No description provided for @signInForgotPrefix.
  ///
  /// In en, this message translates to:
  /// **'Forgot password? '**
  String get signInForgotPrefix;

  /// No description provided for @signInForgotLink.
  ///
  /// In en, this message translates to:
  /// **'Tap here'**
  String get signInForgotLink;

  /// No description provided for @signInOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get signInOr;

  /// No description provided for @signUpPasswordRuleError.
  ///
  /// In en, this message translates to:
  /// **'Password must meet all 3 requirements.'**
  String get signUpPasswordRuleError;

  /// No description provided for @signUpPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get signUpPasswordMismatch;

  /// No description provided for @signUpPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPasswordHint;

  /// No description provided for @signUpPasswordConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get signUpPasswordConfirmHint;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get signUpButton;

  /// No description provided for @signUpFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required information.'**
  String get signUpFillAll;

  /// No description provided for @signUpInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number.'**
  String get signUpInvalidPhone;

  /// No description provided for @signUpNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get signUpNameHint;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'New friend, roll call!'**
  String get signUpTitle;

  /// No description provided for @signUpDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter your info so we know your name!'**
  String get signUpDescription;

  /// No description provided for @phoneInputHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneInputHint;

  /// No description provided for @passwordRuleLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8-20 characters long'**
  String get passwordRuleLength;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get passwordRuleNumber;

  /// No description provided for @passwordRuleUpper.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordRuleUpper;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @chatLandingHeader.
  ///
  /// In en, this message translates to:
  /// **'Choose a pet to chat'**
  String get chatLandingHeader;

  /// No description provided for @chatLandingConversationError.
  ///
  /// In en, this message translates to:
  /// **'Could not load conversations.'**
  String get chatLandingConversationError;

  /// No description provided for @chatLandingConversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get chatLandingConversationTitle;

  /// No description provided for @chatLandingSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get chatLandingSuggestionTitle;

  /// No description provided for @chatLandingPetError.
  ///
  /// In en, this message translates to:
  /// **'Could not load pet list.'**
  String get chatLandingPetError;

  /// No description provided for @chatLandingStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get chatLandingStartConversation;

  /// No description provided for @chatLandingPreviewYou.
  ///
  /// In en, this message translates to:
  /// **'You: {message}'**
  String chatLandingPreviewYou(Object message);

  /// No description provided for @chatLandingEmpty.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet.'**
  String get chatLandingEmpty;

  /// No description provided for @chatLandingLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get chatLandingLoading;

  /// No description provided for @chatLandingCannotStartConversation.
  ///
  /// In en, this message translates to:
  /// **'Cannot start conversation'**
  String get chatLandingCannotStartConversation;

  /// No description provided for @chatLandingFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chatLandingFilterAll;

  /// No description provided for @chatLandingFilterYours.
  ///
  /// In en, this message translates to:
  /// **'Your pets'**
  String get chatLandingFilterYours;

  /// No description provided for @chatLandingFilterCapcat.
  ///
  /// In en, this message translates to:
  /// **'CAPCAT'**
  String get chatLandingFilterCapcat;

  /// No description provided for @numerologyTitle.
  ///
  /// In en, this message translates to:
  /// **'Numerology'**
  String get numerologyTitle;

  /// No description provided for @numerologySend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get numerologySend;

  /// No description provided for @numerologySending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get numerologySending;

  /// No description provided for @numerologyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get numerologyNameLabel;

  /// No description provided for @numerologyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get numerologyNameHint;

  /// No description provided for @numerologyDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get numerologyDobLabel;

  /// No description provided for @numerologyDobHint.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get numerologyDobHint;

  /// No description provided for @numerologyResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get numerologyResultLabel;

  /// No description provided for @numerologyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get numerologyComingSoon;

  /// No description provided for @numerologyGetFullAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Get full analysis file'**
  String get numerologyGetFullAnalysis;

  /// No description provided for @numerologyIntroQuote.
  ///
  /// In en, this message translates to:
  /// **'“We’ll find your life path number. Just fill a few basics, we’ll guide you.”'**
  String get numerologyIntroQuote;

  /// No description provided for @numerologyNotice.
  ///
  /// In en, this message translates to:
  /// **'“For entertainment purposes only—no fortune telling here.”'**
  String get numerologyNotice;

  /// No description provided for @numerologyNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get numerologyNameEmpty;

  /// No description provided for @numerologyDobEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please select birthdate'**
  String get numerologyDobEmpty;

  /// No description provided for @numerologyAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing numerology...'**
  String get numerologyAnalyzing;

  /// No description provided for @numerologySubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed, please try again.'**
  String get numerologySubmitFailed;

  /// No description provided for @zodiacTitle.
  ///
  /// In en, this message translates to:
  /// **'Zodiac Insights'**
  String get zodiacTitle;

  /// No description provided for @zodiacSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get zodiacSend;

  /// No description provided for @zodiacSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get zodiacSending;

  /// No description provided for @zodiacDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get zodiacDobLabel;

  /// No description provided for @zodiacDobHint.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get zodiacDobHint;

  /// No description provided for @zodiacCardPlaceholderName.
  ///
  /// In en, this message translates to:
  /// **'Zodiac'**
  String get zodiacCardPlaceholderName;

  /// No description provided for @zodiacTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to know?'**
  String get zodiacTopicTitle;

  /// No description provided for @zodiacTopicPersonality.
  ///
  /// In en, this message translates to:
  /// **'Personality and abilities'**
  String get zodiacTopicPersonality;

  /// No description provided for @zodiacTopicNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week\'s fate'**
  String get zodiacTopicNextWeek;

  /// No description provided for @zodiacTopicNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month\'s fate'**
  String get zodiacTopicNextMonth;

  /// No description provided for @createContentUploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image, please wait...'**
  String get createContentUploadingImage;

  /// No description provided for @createContentSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select and upload an image'**
  String get createContentSelectImage;

  /// No description provided for @createContentEnterMood.
  ///
  /// In en, this message translates to:
  /// **'Please enter how you feel'**
  String get createContentEnterMood;

  /// No description provided for @createContentAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'Helping you create a great caption'**
  String get createContentAnalyzing;

  /// No description provided for @createContentSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed, please try again.'**
  String get createContentSubmitFailed;

  /// No description provided for @chatNewInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatNewInputHint;

  /// No description provided for @chatNewLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Loading messages...'**
  String get chatNewLoadingMessages;

  /// No description provided for @chatNewLoadMessagesError.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages.\n{message}'**
  String chatNewLoadMessagesError(Object message);

  /// No description provided for @chatNewRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatNewRetry;

  /// No description provided for @chatNewNoMessages.
  ///
  /// In en, this message translates to:
  /// **'Start chatting with your pet!'**
  String get chatNewNoMessages;

  /// No description provided for @chatNewSuggestionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading suggested content...'**
  String get chatNewSuggestionLoading;

  /// No description provided for @chatNewSuggestionError.
  ///
  /// In en, this message translates to:
  /// **'Could not load suggestions.'**
  String get chatNewSuggestionError;

  /// No description provided for @chatNewSendImages.
  ///
  /// In en, this message translates to:
  /// **'Send images'**
  String get chatNewSendImages;

  /// No description provided for @chatNewToolNumerology.
  ///
  /// In en, this message translates to:
  /// **'Numerology'**
  String get chatNewToolNumerology;

  /// No description provided for @chatNewToolZodiac.
  ///
  /// In en, this message translates to:
  /// **'Zodiac insights'**
  String get chatNewToolZodiac;

  /// No description provided for @chatNewToolCaption.
  ///
  /// In en, this message translates to:
  /// **'Great caption'**
  String get chatNewToolCaption;

  /// No description provided for @chatNewToolComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get chatNewToolComingSoon;

  /// No description provided for @chatNewUploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image, please wait...'**
  String get chatNewUploadingImage;

  /// No description provided for @chatNewUploadingAnotherImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading another image, please wait...'**
  String get chatNewUploadingAnotherImage;

  /// No description provided for @chatNewUploadingImageShort.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get chatNewUploadingImageShort;

  /// No description provided for @chatNewLoadingConversation.
  ///
  /// In en, this message translates to:
  /// **'Loading conversation...'**
  String get chatNewLoadingConversation;

  /// No description provided for @chatNewSuggestionErrorWithRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not load suggestions.'**
  String get chatNewSuggestionErrorWithRetry;

  /// No description provided for @chatNewUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Sending images failed, please try again.'**
  String get chatNewUploadFailed;

  /// No description provided for @chatNewToolDiary.
  ///
  /// In en, this message translates to:
  /// **'Write a journal'**
  String get chatNewToolDiary;

  /// No description provided for @chatNewToolOilPainting.
  ///
  /// In en, this message translates to:
  /// **'Oil painting'**
  String get chatNewToolOilPainting;

  /// No description provided for @chatNewToolStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio photoshoot'**
  String get chatNewToolStudio;

  /// No description provided for @chatNewToolCompose.
  ///
  /// In en, this message translates to:
  /// **'Compose'**
  String get chatNewToolCompose;

  /// No description provided for @chatOldBotResponse1.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get chatOldBotResponse1;

  /// No description provided for @chatOldBotResponse2.
  ///
  /// In en, this message translates to:
  /// **'What are you up to?'**
  String get chatOldBotResponse2;

  /// No description provided for @chatOldBotResponse3.
  ///
  /// In en, this message translates to:
  /// **'The weather is great today!'**
  String get chatOldBotResponse3;

  /// No description provided for @chatOldBotResponse4.
  ///
  /// In en, this message translates to:
  /// **'Have you eaten?'**
  String get chatOldBotResponse4;

  /// No description provided for @chatOldBotResponse5.
  ///
  /// In en, this message translates to:
  /// **'I am a mock chatbot.'**
  String get chatOldBotResponse5;

  /// No description provided for @chatOldBotResponse6.
  ///
  /// In en, this message translates to:
  /// **'Flutter is awesome!'**
  String get chatOldBotResponse6;

  /// No description provided for @chatOldBotResponse7.
  ///
  /// In en, this message translates to:
  /// **'You should take a break.'**
  String get chatOldBotResponse7;

  /// No description provided for @chatOldBotResponse8.
  ///
  /// In en, this message translates to:
  /// **'Thanks for messaging me.'**
  String get chatOldBotResponse8;

  /// No description provided for @chatOldBotResponse9.
  ///
  /// In en, this message translates to:
  /// **'See you later!'**
  String get chatOldBotResponse9;

  /// No description provided for @chatOldBotResponse10.
  ///
  /// In en, this message translates to:
  /// **'I am a robot.'**
  String get chatOldBotResponse10;

  /// No description provided for @chatOldBotResponse11.
  ///
  /// In en, this message translates to:
  /// **'Try again!'**
  String get chatOldBotResponse11;

  /// No description provided for @chatOldBotResponse12.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get chatOldBotResponse12;

  /// No description provided for @chatOldSampleMessage1.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get chatOldSampleMessage1;

  /// No description provided for @chatOldSampleMessage2.
  ///
  /// In en, this message translates to:
  /// **'How are you today?'**
  String get chatOldSampleMessage2;

  /// No description provided for @chatOldSampleMessage3.
  ///
  /// In en, this message translates to:
  /// **'I\'m learning Flutter.'**
  String get chatOldSampleMessage3;

  /// No description provided for @chatOldSampleMessage4.
  ///
  /// In en, this message translates to:
  /// **'Do you like programming?'**
  String get chatOldSampleMessage4;

  /// No description provided for @chatOldSampleMessage5.
  ///
  /// In en, this message translates to:
  /// **'Let\'s try this chatbot.'**
  String get chatOldSampleMessage5;

  /// No description provided for @chatOldProductsIntro.
  ///
  /// In en, this message translates to:
  /// **'Here are some products for you:'**
  String get chatOldProductsIntro;

  /// No description provided for @chatOldImagesIntro.
  ///
  /// In en, this message translates to:
  /// **'Here are some sample images:'**
  String get chatOldImagesIntro;

  /// No description provided for @chatOldInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatOldInputHint;

  /// No description provided for @createContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Great caption'**
  String get createContentTitle;

  /// No description provided for @createContentIntroQuote.
  ///
  /// In en, this message translates to:
  /// **'“Sometimes we have great photos but no idea what to write. Let me help!”'**
  String get createContentIntroQuote;

  /// No description provided for @createContentResultQuote.
  ///
  /// In en, this message translates to:
  /// **'“Now we just need to share the content, let me guide you!”'**
  String get createContentResultQuote;

  /// No description provided for @createContentPrepTip.
  ///
  /// In en, this message translates to:
  /// **'“You\'re about to get an attractive caption!”'**
  String get createContentPrepTip;

  /// No description provided for @createContentShareTip.
  ///
  /// In en, this message translates to:
  /// **'“I\'ll help you post in the right resolution so it stays sharp.”'**
  String get createContentShareTip;

  /// No description provided for @createContentResultEmpty.
  ///
  /// In en, this message translates to:
  /// **'No result to show. Please try again or go back to edit.'**
  String get createContentResultEmpty;

  /// No description provided for @createContentBackToChat.
  ///
  /// In en, this message translates to:
  /// **'Back to chat'**
  String get createContentBackToChat;

  /// No description provided for @createContentShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get createContentShare;

  /// No description provided for @createContentProcessingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get createContentProcessingImage;

  /// No description provided for @createContentChooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose image from gallery'**
  String get createContentChooseImage;

  /// No description provided for @createContentFeelingTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you feel right now?'**
  String get createContentFeelingTitle;

  /// No description provided for @createContentFeelingHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., This morning was chilly and I suddenly felt lonely'**
  String get createContentFeelingHint;

  /// No description provided for @createContentStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want to write?'**
  String get createContentStyleTitle;

  /// No description provided for @createContentStyleHumor.
  ///
  /// In en, this message translates to:
  /// **'Humorous – meme style'**
  String get createContentStyleHumor;

  /// No description provided for @createContentStylePoem.
  ///
  /// In en, this message translates to:
  /// **'Write rhyming poetry'**
  String get createContentStylePoem;

  /// No description provided for @createContentStyleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask engaging questions'**
  String get createContentStyleQuestion;

  /// No description provided for @createContentStyleQuote.
  ///
  /// In en, this message translates to:
  /// **'Use quotes'**
  String get createContentStyleQuote;

  /// No description provided for @createContentStyleNarrative.
  ///
  /// In en, this message translates to:
  /// **'Descriptive prose'**
  String get createContentStyleNarrative;

  /// No description provided for @createContentStyleStorytelling.
  ///
  /// In en, this message translates to:
  /// **'Storytelling'**
  String get createContentStyleStorytelling;

  /// No description provided for @createContentStyleEducation.
  ///
  /// In en, this message translates to:
  /// **'Education / knowledge sharing'**
  String get createContentStyleEducation;

  /// No description provided for @createContentLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Short or medium, which suits you?'**
  String get createContentLengthTitle;

  /// No description provided for @createContentLengthShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get createContentLengthShort;

  /// No description provided for @createContentLengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get createContentLengthMedium;

  /// No description provided for @createContentLengthShortHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 200 characters'**
  String get createContentLengthShortHint;

  /// No description provided for @createContentLengthMediumHint.
  ///
  /// In en, this message translates to:
  /// **'Up to 500 characters'**
  String get createContentLengthMediumHint;

  /// No description provided for @createContentMemoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get createContentMemoryLabel;

  /// No description provided for @createContentUploadUrlError.
  ///
  /// In en, this message translates to:
  /// **'Could not get upload URL'**
  String get createContentUploadUrlError;

  /// No description provided for @createContentUploadMissingUrl.
  ///
  /// In en, this message translates to:
  /// **'Missing upload URL or file URL'**
  String get createContentUploadMissingUrl;

  /// No description provided for @createContentUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get createContentUploadFailed;

  /// No description provided for @createContentUnknownMime.
  ///
  /// In en, this message translates to:
  /// **'Cannot determine image mime type'**
  String get createContentUnknownMime;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @myPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your pets'**
  String get myPetsTitle;

  /// No description provided for @myPetsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get myPetsLoading;

  /// No description provided for @myPetsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load pet list.'**
  String get myPetsLoadError;

  /// No description provided for @myPetsStartChatError.
  ///
  /// In en, this message translates to:
  /// **'Unable to start conversation'**
  String get myPetsStartChatError;

  /// No description provided for @myPetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pets yet.'**
  String get myPetsEmpty;

  /// No description provided for @myPetsRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get myPetsRetry;

  /// No description provided for @myPetsAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add a new pet'**
  String get myPetsAddNew;

  /// No description provided for @petFormLandingTitle.
  ///
  /// In en, this message translates to:
  /// **'Create pet profile'**
  String get petFormLandingTitle;

  /// No description provided for @petFormLandingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get petFormLandingStart;

  /// No description provided for @petFormLandingHero.
  ///
  /// In en, this message translates to:
  /// **'Start by taking a photo of your pet! 📸'**
  String get petFormLandingHero;

  /// No description provided for @petFormLandingTips.
  ///
  /// In en, this message translates to:
  /// **'For accurate recognition, choose a photo with good lighting ✨, sharp focus 👀, and no obstructions 🚫.'**
  String get petFormLandingTips;

  /// No description provided for @petFormChooseProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get petFormChooseProcessing;

  /// No description provided for @petFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Pet name'**
  String get petFormNameLabel;

  /// No description provided for @petFormGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get petFormGenderLabel;

  /// No description provided for @petFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Pet name'**
  String get petFormNameHint;

  /// No description provided for @petFormGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get petFormGenderFemale;

  /// No description provided for @petFormGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get petFormGenderMale;

  /// No description provided for @petFormNeutered.
  ///
  /// In en, this message translates to:
  /// **'Neutered'**
  String get petFormNeutered;

  /// No description provided for @petFormUploadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again later.'**
  String get petFormUploadError;

  /// No description provided for @petProfileLoadDataError.
  ///
  /// In en, this message translates to:
  /// **'Could not load required data.'**
  String get petProfileLoadDataError;

  /// No description provided for @petProfileStartChatError.
  ///
  /// In en, this message translates to:
  /// **'Unable to start conversation'**
  String get petProfileStartChatError;

  /// No description provided for @petProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Pet not found.'**
  String get petProfileNotFound;

  /// No description provided for @petProfileFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature not ready yet'**
  String get petProfileFeatureComingSoon;

  /// No description provided for @petProfileShortDesc.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get petProfileShortDesc;

  /// No description provided for @petProfileNoDesc.
  ///
  /// In en, this message translates to:
  /// **'No description yet.'**
  String get petProfileNoDesc;

  /// No description provided for @petProfileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get petProfileGender;

  /// No description provided for @petProfileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get petProfileWeight;

  /// No description provided for @petProfileAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance & markings'**
  String get petProfileAppearanceTitle;

  /// No description provided for @petProfileImportantDates.
  ///
  /// In en, this message translates to:
  /// **'Important dates'**
  String get petProfileImportantDates;

  /// No description provided for @petProfileBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get petProfileBirthday;

  /// No description provided for @petProfileAdoption.
  ///
  /// In en, this message translates to:
  /// **'Adoption date'**
  String get petProfileAdoption;

  /// No description provided for @petProfileShareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get petProfileShareProfile;

  /// No description provided for @petProfileLostMode.
  ///
  /// In en, this message translates to:
  /// **'Lost mode'**
  String get petProfileLostMode;

  /// No description provided for @petProfileTraits.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get petProfileTraits;

  /// No description provided for @petProfileTones.
  ///
  /// In en, this message translates to:
  /// **'Tone'**
  String get petProfileTones;

  /// No description provided for @petProfileStyles.
  ///
  /// In en, this message translates to:
  /// **'Writing style'**
  String get petProfileStyles;

  /// No description provided for @petFormStepGeneral.
  ///
  /// In en, this message translates to:
  /// **'General info'**
  String get petFormStepGeneral;

  /// No description provided for @petFormStepAdditional.
  ///
  /// In en, this message translates to:
  /// **'Additional info'**
  String get petFormStepAdditional;

  /// No description provided for @petFormStepPersona.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get petFormStepPersona;

  /// No description provided for @petFormConfirmAndCreate.
  ///
  /// In en, this message translates to:
  /// **'Confirm and create profile'**
  String get petFormConfirmAndCreate;

  /// No description provided for @petFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get petFormSave;

  /// No description provided for @petFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your pet\'s name'**
  String get petFormNameRequired;

  /// No description provided for @petFormBreedRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your pet\'s breed'**
  String get petFormBreedRequired;

  /// No description provided for @petFormPersonaRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your pet\'s personality'**
  String get petFormPersonaRequired;

  /// No description provided for @petFormMasterDataError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load required data. Please try again.'**
  String get petFormMasterDataError;

  /// No description provided for @petFormSpeciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get petFormSpeciesLabel;

  /// No description provided for @petFormBreedLabel.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get petFormBreedLabel;

  /// No description provided for @petFormWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get petFormWeightLabel;

  /// No description provided for @petFormHairColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Coat color'**
  String get petFormHairColorLabel;

  /// No description provided for @petFormBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get petFormBirthdayLabel;

  /// No description provided for @petFormAdoptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Adoption date'**
  String get petFormAdoptionLabel;

  /// No description provided for @petFormDetailInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Detailed information'**
  String get petFormDetailInfoLabel;

  /// No description provided for @petFormAppearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance and distinctive signs'**
  String get petFormAppearanceLabel;

  /// No description provided for @petFormSpeciesDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get petFormSpeciesDog;

  /// No description provided for @petFormSpeciesCat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get petFormSpeciesCat;

  /// No description provided for @petFormWaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'Hang tight!'**
  String get petFormWaitingTitle;

  /// No description provided for @petFormWaitingStep1.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your pet\'s photo'**
  String get petFormWaitingStep1;

  /// No description provided for @petFormWaitingStep2.
  ///
  /// In en, this message translates to:
  /// **'Identifying species, age, and color'**
  String get petFormWaitingStep2;

  /// No description provided for @petFormWaitingStep3.
  ///
  /// In en, this message translates to:
  /// **'Recognizing distinctive signs'**
  String get petFormWaitingStep3;

  /// No description provided for @petFormWaitingStep4.
  ///
  /// In en, this message translates to:
  /// **'Your pet\'s AI profile is ready! 🎉'**
  String get petFormWaitingStep4;

  /// No description provided for @petFormCallPetLabel.
  ///
  /// In en, this message translates to:
  /// **'What does your pet call itself'**
  String get petFormCallPetLabel;

  /// No description provided for @petFormCallOwnerLabel.
  ///
  /// In en, this message translates to:
  /// **'What does your pet call you'**
  String get petFormCallOwnerLabel;

  /// No description provided for @petFormPersonaRepresentative.
  ///
  /// In en, this message translates to:
  /// **'Representative personality'**
  String get petFormPersonaRepresentative;

  /// No description provided for @petFormPersonaTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a personality for your pet'**
  String get petFormPersonaTitle;

  /// No description provided for @petFormPersonaIntro.
  ///
  /// In en, this message translates to:
  /// **'Your pet\'s AI needs to know how to call you and itself so you both vibe like true \"Sen - Boss\" buddies!'**
  String get petFormPersonaIntro;

  /// No description provided for @petFormCallPetHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Me, I, Buddy...'**
  String get petFormCallPetHint;

  /// No description provided for @petFormCallOwnerHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Dad, Mom, Aunt, Uncle...'**
  String get petFormCallOwnerHint;

  /// No description provided for @petFormHobbyHeader.
  ///
  /// In en, this message translates to:
  /// **'Hobbies {count}/{max}'**
  String petFormHobbyHeader(Object count, Object max);

  /// No description provided for @petFormHobbyLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading hobbies...'**
  String get petFormHobbyLoading;

  /// No description provided for @petFormHobbyError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load hobbies: {error}'**
  String petFormHobbyError(Object error);

  /// No description provided for @petFormHobbyHint.
  ///
  /// In en, this message translates to:
  /// **'Select hobbies'**
  String get petFormHobbyHint;

  /// No description provided for @petFormHobbySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get petFormHobbySheetTitle;

  /// No description provided for @petFormHobbyAll.
  ///
  /// In en, this message translates to:
  /// **'All hobbies'**
  String get petFormHobbyAll;

  /// No description provided for @petFormPersonaLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String petFormPersonaLoadError(Object error);

  /// No description provided for @petFormPersonaEmpty.
  ///
  /// In en, this message translates to:
  /// **'No personality data'**
  String get petFormPersonaEmpty;

  /// No description provided for @petFormCallPetRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter what your pet calls itself'**
  String get petFormCallPetRequired;

  /// No description provided for @petFormCallOwnerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter what your pet calls you'**
  String get petFormCallOwnerRequired;

  /// No description provided for @petFormHobbyRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select hobbies for your pet'**
  String get petFormHobbyRequired;

  /// No description provided for @petFormPersonaRequired2.
  ///
  /// In en, this message translates to:
  /// **'Please select a personality for your pet'**
  String get petFormPersonaRequired2;

  /// No description provided for @petFormCreatePersonaSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pet persona added successfully!'**
  String get petFormCreatePersonaSuccess;

  /// No description provided for @petFormGenericError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please try again later'**
  String get petFormGenericError;

  /// No description provided for @petProfileHeader.
  ///
  /// In en, this message translates to:
  /// **'Pet profile'**
  String get petProfileHeader;

  /// No description provided for @petProfileAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About my pet'**
  String get petProfileAboutTitle;

  /// No description provided for @petProfileGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get petProfileGenderLabel;

  /// No description provided for @petProfileSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get petProfileSizeLabel;

  /// No description provided for @petProfileWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get petProfileWeightLabel;

  /// No description provided for @petProfileImportantDatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Important dates'**
  String get petProfileImportantDatesTitle;

  /// No description provided for @petProfileAdopted.
  ///
  /// In en, this message translates to:
  /// **'Adoption date'**
  String get petProfileAdopted;

  /// No description provided for @petProfileAge.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String petProfileAge(Object age);

  /// No description provided for @petProfileTabInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get petProfileTabInfo;

  /// No description provided for @petProfilePersonaTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet\'s personality'**
  String get petProfilePersonaTitle;

  /// No description provided for @petProfilePersonaTraits.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get petProfilePersonaTraits;

  /// No description provided for @petProfilePersonaTone.
  ///
  /// In en, this message translates to:
  /// **'Voice tone'**
  String get petProfilePersonaTone;

  /// No description provided for @petProfilePersonaStyle.
  ///
  /// In en, this message translates to:
  /// **'Writing style'**
  String get petProfilePersonaStyle;

  /// No description provided for @sharePetProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get sharePetProfileTitle;

  /// No description provided for @sharePetProfileOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get sharePetProfileOr;

  /// No description provided for @sharePetProfileShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share link'**
  String get sharePetProfileShareLink;

  /// No description provided for @sharePetProfileComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get sharePetProfileComingSoon;

  /// No description provided for @petFormAddCollarTitle.
  ///
  /// In en, this message translates to:
  /// **'Add collar'**
  String get petFormAddCollarTitle;

  /// No description provided for @petFormAddCollarScan.
  ///
  /// In en, this message translates to:
  /// **'Scan collar code'**
  String get petFormAddCollarScan;

  /// No description provided for @petFormFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get petFormFeatureComingSoon;

  /// No description provided for @editPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit pet profile'**
  String get editPetTitle;

  /// No description provided for @editPetCheckingImage.
  ///
  /// In en, this message translates to:
  /// **'Checking image'**
  String get editPetCheckingImage;

  /// No description provided for @editPetGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again.'**
  String get editPetGenericError;

  /// No description provided for @editPetGetInfoError.
  ///
  /// In en, this message translates to:
  /// **'Could not load pet info, please try again.'**
  String get editPetGetInfoError;

  /// No description provided for @editPetNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your pet\'s name.'**
  String get editPetNameRequired;

  /// No description provided for @editPetBreedRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a breed.'**
  String get editPetBreedRequired;

  /// No description provided for @editPetBirthdayRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a birthday.'**
  String get editPetBirthdayRequired;

  /// No description provided for @editPetSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile saved!'**
  String get editPetSaveSuccess;

  /// No description provided for @editPetSaveFail.
  ///
  /// In en, this message translates to:
  /// **'Save failed, please try again.'**
  String get editPetSaveFail;

  /// No description provided for @editPetNotRecognizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet not recognized'**
  String get editPetNotRecognizedTitle;

  /// No description provided for @editPetNotRecognizedMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t detect a pet in the image you selected. We currently recognize only cats and dogs. Please upload another photo.'**
  String get editPetNotRecognizedMessage;

  /// No description provided for @editPetNotRecognizedRetry.
  ///
  /// In en, this message translates to:
  /// **'Re-upload pet photo'**
  String get editPetNotRecognizedRetry;

  /// No description provided for @editPetTryAnotherImage.
  ///
  /// In en, this message translates to:
  /// **'Please try again with another image'**
  String get editPetTryAnotherImage;

  /// No description provided for @editPetSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested changes'**
  String get editPetSuggestionTitle;

  /// No description provided for @editPetSuggestionMessage.
  ///
  /// In en, this message translates to:
  /// **'Heads up! This image doesn\'t seem to match the previous info.'**
  String get editPetSuggestionMessage;

  /// No description provided for @editPetSuggestionPrimary.
  ///
  /// In en, this message translates to:
  /// **'Update with new image data'**
  String get editPetSuggestionPrimary;

  /// No description provided for @editPetSuggestionSecondary.
  ///
  /// In en, this message translates to:
  /// **'Keep current info'**
  String get editPetSuggestionSecondary;

  /// No description provided for @editPetSuggestionToast.
  ///
  /// In en, this message translates to:
  /// **'Info updated'**
  String get editPetSuggestionToast;

  /// No description provided for @editPetNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Pet name'**
  String get editPetNameLabel;

  /// No description provided for @editPetNameHint.
  ///
  /// In en, this message translates to:
  /// **'Pet name'**
  String get editPetNameHint;

  /// No description provided for @editPetGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get editPetGenderLabel;

  /// No description provided for @editPetSpeciesLabel.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get editPetSpeciesLabel;

  /// No description provided for @editPetBreedLabel.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get editPetBreedLabel;

  /// No description provided for @editPetWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get editPetWeightLabel;

  /// No description provided for @editPetWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get editPetWeightHint;

  /// No description provided for @editPetHairColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Fur color'**
  String get editPetHairColorLabel;

  /// No description provided for @editPetBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get editPetBirthdayLabel;

  /// No description provided for @editPetAdoptedLabel.
  ///
  /// In en, this message translates to:
  /// **'Adoption date'**
  String get editPetAdoptedLabel;

  /// No description provided for @editPetDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get editPetDetailLabel;

  /// No description provided for @editPetAppearanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance & markings'**
  String get editPetAppearanceLabel;

  /// No description provided for @editPetSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editPetSaveButton;

  /// No description provided for @editPetNeuteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Neutered'**
  String get editPetNeuteredLabel;

  /// No description provided for @editPetBreedHint.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get editPetBreedHint;

  /// No description provided for @editPetBreedLoadingHint.
  ///
  /// In en, this message translates to:
  /// **'Breed (loading...)'**
  String get editPetBreedLoadingHint;

  /// No description provided for @editPetBreedErrorHint.
  ///
  /// In en, this message translates to:
  /// **'Breed (load failed)'**
  String get editPetBreedErrorHint;

  /// No description provided for @editPetBreedSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Select breed'**
  String get editPetBreedSheetTitle;

  /// No description provided for @editPetBreedSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search breed'**
  String get editPetBreedSearchHint;

  /// No description provided for @editPetBreedAllSection.
  ///
  /// In en, this message translates to:
  /// **'All breeds'**
  String get editPetBreedAllSection;

  /// No description provided for @editPetInputHint.
  ///
  /// In en, this message translates to:
  /// **'Enter details'**
  String get editPetInputHint;

  /// No description provided for @petProfileSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get petProfileSocialTitle;

  /// No description provided for @petProfileSocialViews.
  ///
  /// In en, this message translates to:
  /// **'Profile views'**
  String get petProfileSocialViews;

  /// No description provided for @petProfileSocialComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get petProfileSocialComments;

  /// No description provided for @petFormTryAnotherImage.
  ///
  /// In en, this message translates to:
  /// **'Please try again with another image'**
  String get petFormTryAnotherImage;

  /// No description provided for @petFormBirthdayRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your pet\'s birthday.'**
  String get petFormBirthdayRequired;

  /// No description provided for @petFormCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pet created successfully!'**
  String get petFormCreateSuccess;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadError;

  /// No description provided for @profileRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get profileRetry;

  /// No description provided for @profileMenuAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account info'**
  String get profileMenuAccountInfo;

  /// No description provided for @profileMenuMyPets.
  ///
  /// In en, this message translates to:
  /// **'My pets'**
  String get profileMenuMyPets;

  /// No description provided for @profileMenuChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileMenuChangePassword;

  /// No description provided for @profileMenuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileMenuTerms;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordInfo.
  ///
  /// In en, this message translates to:
  /// **'Your new password should be different from any old ones you used!'**
  String get changePasswordInfo;

  /// No description provided for @changePasswordCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get changePasswordCurrent;

  /// No description provided for @changePasswordNew.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get changePasswordNew;

  /// No description provided for @changePasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get changePasswordConfirm;

  /// No description provided for @changePasswordHintCurrent.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get changePasswordHintCurrent;

  /// No description provided for @changePasswordHintNew.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get changePasswordHintNew;

  /// No description provided for @changePasswordHintConfirm.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get changePasswordHintConfirm;

  /// No description provided for @changePasswordSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get changePasswordSave;

  /// No description provided for @changePasswordSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get changePasswordSaving;

  /// No description provided for @changePasswordFillAll.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get changePasswordFillAll;

  /// No description provided for @changePasswordRulesNotMet.
  ///
  /// In en, this message translates to:
  /// **'New password doesn\'t meet all 3 requirements.'**
  String get changePasswordRulesNotMet;

  /// No description provided for @changePasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least 6 characters'**
  String get changePasswordMinLength;

  /// No description provided for @changePasswordDifferent.
  ///
  /// In en, this message translates to:
  /// **'New password must be different from the old password'**
  String get changePasswordDifferent;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Confirmation password doesn\'t match'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Password change failed'**
  String get changePasswordFailed;

  /// No description provided for @profileInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get profileInfoTitle;

  /// No description provided for @profileInfoUpdatingAvatar.
  ///
  /// In en, this message translates to:
  /// **'Updating avatar'**
  String get profileInfoUpdatingAvatar;

  /// No description provided for @profileInfoGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again.'**
  String get profileInfoGenericError;

  /// No description provided for @profileInfoAvatarSuccess.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get profileInfoAvatarSuccess;

  /// No description provided for @profileInfoFetchError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data, please try again later.'**
  String get profileInfoFetchError;

  /// No description provided for @profileInfoNoChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes to update'**
  String get profileInfoNoChanges;

  /// No description provided for @profileInfoUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get profileInfoUpdateSuccess;

  /// No description provided for @profileInfoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed, please try again later.'**
  String get profileInfoUpdateFailed;

  /// No description provided for @profileInfoNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileInfoNameLabel;

  /// No description provided for @profileInfoNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get profileInfoNameHint;

  /// No description provided for @profileInfoEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileInfoEmailLabel;

  /// No description provided for @profileInfoEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileInfoEmailHint;

  /// No description provided for @profileInfoPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileInfoPhoneLabel;

  /// No description provided for @profileInfoPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profileInfoPhoneHint;

  /// No description provided for @profileInfoAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileInfoAddressLabel;

  /// No description provided for @profileInfoAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileInfoAddressHint;

  /// No description provided for @profileInfoDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get profileInfoDobLabel;

  /// No description provided for @profileInfoDobHint.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get profileInfoDobHint;

  /// No description provided for @profileInfoGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileInfoGenderLabel;

  /// No description provided for @profileInfoGenderSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get profileInfoGenderSheetTitle;

  /// No description provided for @profileInfoGenderSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search gender'**
  String get profileInfoGenderSearchHint;

  /// No description provided for @profileInfoGenderAll.
  ///
  /// In en, this message translates to:
  /// **'All genders'**
  String get profileInfoGenderAll;

  /// No description provided for @profileInfoSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileInfoSave;

  /// No description provided for @profileInfoSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get profileInfoSaving;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get termsTitle;

  /// No description provided for @termsHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy – Capcat 🐾'**
  String get termsHeroTitle;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'Capcat (\"we\") is committed to protecting your personal data and privacy when using the app. This policy explains how we collect, use, store, and protect your information.'**
  String get termsIntro;

  /// No description provided for @termsSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Information we collect'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Body.
  ///
  /// In en, this message translates to:
  /// **'When you use Capcat, we may collect:\\n  •  Account info: email, name, avatar, password.\\n  •  Pet info: name, age, species, photos.\\n  •  Interaction info: AI chat history, notes, journals or “Memory Box” you create.\\n  •  Device data: device type, OS, IP address (for technical and security purposes only).'**
  String get termsSection1Body;

  /// No description provided for @termsSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. How we use information'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Body.
  ///
  /// In en, this message translates to:
  /// **'We use your data to:\\n  •  Provide and improve app features.\\n  •  Personalize experience (e.g., whisper suggestions, storytelling from photos/notes).\\n  •  Send notifications about pet activities, product or policy updates.\\n  •  Detect and prevent fraud, keep accounts secure.'**
  String get termsSection2Body;

  /// No description provided for @termsSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Data sharing'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Body.
  ///
  /// In en, this message translates to:
  /// **'We do NOT sell personal information to third parties. Data is only shared when:\\n  •  We have your consent.\\n  •  Required to comply with the law.\\n  •  Working with service providers (e.g., cloud storage) to operate the app.'**
  String get termsSection3Body;

  /// No description provided for @termsSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Storage & Security'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Body.
  ///
  /// In en, this message translates to:
  /// **'Data is stored on secure servers. Passwords are encrypted. We apply technical and organizational security measures to protect your data.'**
  String get termsSection4Body;

  /// No description provided for @termsSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Your rights'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Body.
  ///
  /// In en, this message translates to:
  /// **'You can:\\n  •  View, edit, or delete your profile info.\\n  •  Request to delete your account and all related data.\\n  •  Opt out of promotional notifications at any time.'**
  String get termsSection5Body;

  /// No description provided for @termsSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Retention period'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Body.
  ///
  /// In en, this message translates to:
  /// **'We keep your information while you use the app. If you stop using it, we will delete data within 30 days.'**
  String get termsSection6Body;

  /// No description provided for @termsSection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Data when signing in with Google'**
  String get termsSection7Title;

  /// No description provided for @termsSection7Body.
  ///
  /// In en, this message translates to:
  /// **'When you use “Sign in with Google”, we only access an anonymous email to create an account. We do not use Google data for marketing or sharing without individual consent.'**
  String get termsSection7Body;

  /// No description provided for @termsContact.
  ///
  /// In en, this message translates to:
  /// **'If you have questions or requests about privacy, please contact:'**
  String get termsContact;

  /// No description provided for @termsContactEmail.
  ///
  /// In en, this message translates to:
  /// **'support@capcat.app'**
  String get termsContactEmail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
