// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CapCat';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonErrorTryAgain =>
      'Something went wrong, please try again later.';

  @override
  String get forgotPhoneTitle => 'Share your number with us!';

  @override
  String get forgotPhoneSubtitle =>
      'Please enter your phone number so we can recognize you!';

  @override
  String get forgotPhoneContinue => 'Continue';

  @override
  String get forgotOtpTitle => 'Verify your phone number';

  @override
  String forgotOtpSubtitle(Object phone) {
    return 'Please enter the code we sent to $phone';
  }

  @override
  String get forgotOtpHint => 'Enter the code';

  @override
  String get forgotOtpResend => 'Resend';

  @override
  String get forgotOtpIn => 'in';

  @override
  String get forgotOtpConfirm => 'Confirm';

  @override
  String get forgotNewPasswordTitle => 'Keep it secret, set a new password!';

  @override
  String get forgotNewPasswordSubtitle =>
      'Enter your new password twice so we know you’ll remember it!';

  @override
  String get forgotNewPasswordRulesError =>
      'Your new password doesn’t meet all 3 requirements.';

  @override
  String get forgotNewPasswordMismatch => 'The passwords don’t match.';

  @override
  String get forgotNewPasswordHint => 'Password';

  @override
  String get forgotNewPasswordConfirmHint => 'Re-enter password';

  @override
  String get forgotNewPasswordButton => 'Confirm';

  @override
  String get introTitle => 'Personalized pet profile';

  @override
  String get introDescription =>
      'Create a personalized profile for each of your beloved pets on PawBuddy. Share their name, breed, and age while connecting with a vibrant community.';

  @override
  String get introStart => 'Start now';

  @override
  String get socialPhoneTitle => 'Enter your phone number';

  @override
  String get socialPhoneSubtitle =>
      'Please enter your phone number to complete sign in.';

  @override
  String phoneRegisterOtpSubtitle(Object phone) {
    return 'Check your phone, we sent a code to $phone.';
  }

  @override
  String get toastLoginSuccess => 'Logged in successfully';

  @override
  String get toastLinkLoginSuccess => 'Linked login successfully';

  @override
  String get toastRegisterSuccess => 'Registered successfully';

  @override
  String get toastLinkRegisterSuccess => 'Linked registration successful';

  @override
  String get toastChangePasswordSuccess => 'Password changed successfully';

  @override
  String get tabLogin => 'Login';

  @override
  String get tabRegister => 'Register';

  @override
  String get signInPasswordHint => 'Password';

  @override
  String get signInButton => 'Login';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInTitle => 'Welcome back';

  @override
  String get signInDescription => 'Enter your login information to continue.';

  @override
  String get signInPhoneEmpty => 'Please enter your phone number.';

  @override
  String get signInPasswordEmpty => 'Please enter your password.';

  @override
  String get signInForgotPrefix => 'Forgot password? ';

  @override
  String get signInForgotLink => 'Tap here';

  @override
  String get signInOr => 'Or';

  @override
  String get signUpPasswordRuleError =>
      'Password must meet all 3 requirements.';

  @override
  String get signUpPasswordMismatch => 'Passwords do not match.';

  @override
  String get signUpPasswordHint => 'Password';

  @override
  String get signUpPasswordConfirmHint => 'Confirm password';

  @override
  String get signUpButton => 'Register';

  @override
  String get signUpFillAll => 'Please fill in all required information.';

  @override
  String get signUpInvalidPhone => 'Invalid phone number.';

  @override
  String get signUpNameHint => 'Your name';

  @override
  String get signUpTitle => 'New friend, roll call!';

  @override
  String get signUpDescription =>
      'Please enter your info so we know your name!';

  @override
  String get phoneInputHint => 'Phone number';

  @override
  String get passwordRuleLength => 'Password must be 8-20 characters long';

  @override
  String get passwordRuleNumber => 'Password must contain at least one digit';

  @override
  String get passwordRuleUpper =>
      'Password must contain at least one uppercase letter';

  @override
  String get commonRetry => 'Retry';

  @override
  String get chatLandingHeader => 'Choose a pet to chat';

  @override
  String get chatLandingConversationError => 'Could not load conversations.';

  @override
  String get chatLandingConversationTitle => 'Conversations';

  @override
  String get chatLandingSuggestionTitle => 'Suggestions';

  @override
  String get chatLandingPetError => 'Could not load pet list.';

  @override
  String get chatLandingStartConversation => 'Start a conversation';

  @override
  String chatLandingPreviewYou(Object message) {
    return 'You: $message';
  }

  @override
  String get chatLandingEmpty => 'No conversations yet.';

  @override
  String get chatLandingLoading => 'Loading...';

  @override
  String get chatLandingCannotStartConversation => 'Cannot start conversation';

  @override
  String get chatLandingFilterAll => 'All';

  @override
  String get chatLandingFilterYours => 'Your pets';

  @override
  String get chatLandingFilterCapcat => 'CAPCAT';

  @override
  String get numerologyTitle => 'Numerology';

  @override
  String get numerologySend => 'Send';

  @override
  String get numerologySending => 'Sending...';

  @override
  String get numerologyNameLabel => 'Full name';

  @override
  String get numerologyNameHint => 'Enter full name';

  @override
  String get numerologyDobLabel => 'Date of birth';

  @override
  String get numerologyDobHint => 'Select date of birth';

  @override
  String get numerologyResultLabel => 'Result';

  @override
  String get numerologyComingSoon => 'Coming soon';

  @override
  String get numerologyGetFullAnalysis => 'Get full analysis file';

  @override
  String get numerologyIntroQuote =>
      '“We’ll find your life path number. Just fill a few basics, we’ll guide you.”';

  @override
  String get numerologyNotice =>
      '“For entertainment purposes only—no fortune telling here.”';

  @override
  String get numerologyNameEmpty => 'Please enter full name';

  @override
  String get numerologyDobEmpty => 'Please select birthdate';

  @override
  String get numerologyAnalyzing => 'Analyzing numerology...';

  @override
  String get numerologySubmitFailed => 'Request failed, please try again.';

  @override
  String get zodiacTitle => 'Zodiac Insights';

  @override
  String get zodiacSend => 'Send';

  @override
  String get zodiacSending => 'Sending...';

  @override
  String get zodiacDobLabel => 'Date of birth';

  @override
  String get zodiacDobHint => 'Select date of birth';

  @override
  String get zodiacCardPlaceholderName => 'Zodiac';

  @override
  String get zodiacTopicTitle => 'What do you want to know?';

  @override
  String get zodiacTopicPersonality => 'Personality and abilities';

  @override
  String get zodiacTopicNextWeek => 'Next week\'s fate';

  @override
  String get zodiacTopicNextMonth => 'Next month\'s fate';

  @override
  String get createContentUploadingImage => 'Uploading image, please wait...';

  @override
  String get createContentSelectImage => 'Please select and upload an image';

  @override
  String get createContentEnterMood => 'Please enter how you feel';

  @override
  String get createContentAnalyzing => 'Helping you create a great caption';

  @override
  String get createContentSubmitFailed => 'Request failed, please try again.';

  @override
  String get chatNewInputHint => 'Type a message...';

  @override
  String get chatNewLoadingMessages => 'Loading messages...';

  @override
  String chatNewLoadMessagesError(Object message) {
    return 'Could not load messages.\n$message';
  }

  @override
  String get chatNewRetry => 'Retry';

  @override
  String get chatNewNoMessages => 'Start chatting with your pet!';

  @override
  String get chatNewSuggestionLoading => 'Loading suggested content...';

  @override
  String get chatNewSuggestionError => 'Could not load suggestions.';

  @override
  String get chatNewSendImages => 'Send images';

  @override
  String get chatNewToolNumerology => 'Numerology';

  @override
  String get chatNewToolZodiac => 'Zodiac insights';

  @override
  String get chatNewToolCaption => 'Great caption';

  @override
  String get chatNewToolComingSoon => 'Coming soon';

  @override
  String get chatNewUploadingImage => 'Uploading image, please wait...';

  @override
  String get chatNewUploadingAnotherImage =>
      'Uploading another image, please wait...';

  @override
  String get chatNewUploadingImageShort => 'Uploading image...';

  @override
  String get chatNewLoadingConversation => 'Loading conversation...';

  @override
  String get chatNewSuggestionErrorWithRetry => 'Could not load suggestions.';

  @override
  String get chatNewUploadFailed => 'Sending images failed, please try again.';

  @override
  String get chatNewToolDiary => 'Write a journal';

  @override
  String get chatNewToolOilPainting => 'Oil painting';

  @override
  String get chatNewToolStudio => 'Studio photoshoot';

  @override
  String get chatNewToolCompose => 'Compose';

  @override
  String get chatOldBotResponse1 => 'Hello!';

  @override
  String get chatOldBotResponse2 => 'What are you up to?';

  @override
  String get chatOldBotResponse3 => 'The weather is great today!';

  @override
  String get chatOldBotResponse4 => 'Have you eaten?';

  @override
  String get chatOldBotResponse5 => 'I am a mock chatbot.';

  @override
  String get chatOldBotResponse6 => 'Flutter is awesome!';

  @override
  String get chatOldBotResponse7 => 'You should take a break.';

  @override
  String get chatOldBotResponse8 => 'Thanks for messaging me.';

  @override
  String get chatOldBotResponse9 => 'See you later!';

  @override
  String get chatOldBotResponse10 => 'I am a robot.';

  @override
  String get chatOldBotResponse11 => 'Try again!';

  @override
  String get chatOldBotResponse12 => 'Keep it up!';

  @override
  String get chatOldSampleMessage1 => 'Hello!';

  @override
  String get chatOldSampleMessage2 => 'How are you today?';

  @override
  String get chatOldSampleMessage3 => 'I\'m learning Flutter.';

  @override
  String get chatOldSampleMessage4 => 'Do you like programming?';

  @override
  String get chatOldSampleMessage5 => 'Let\'s try this chatbot.';

  @override
  String get chatOldProductsIntro => 'Here are some products for you:';

  @override
  String get chatOldImagesIntro => 'Here are some sample images:';

  @override
  String get chatOldInputHint => 'Type a message...';

  @override
  String get createContentTitle => 'Great caption';

  @override
  String get createContentIntroQuote =>
      '“Sometimes we have great photos but no idea what to write. Let me help!”';

  @override
  String get createContentResultQuote =>
      '“Now we just need to share the content, let me guide you!”';

  @override
  String get createContentPrepTip =>
      '“You\'re about to get an attractive caption!”';

  @override
  String get createContentShareTip =>
      '“I\'ll help you post in the right resolution so it stays sharp.”';

  @override
  String get createContentResultEmpty =>
      'No result to show. Please try again or go back to edit.';

  @override
  String get createContentBackToChat => 'Back to chat';

  @override
  String get createContentShare => 'Share';

  @override
  String get createContentProcessingImage => 'Processing image...';

  @override
  String get createContentChooseImage => 'Choose image from gallery';

  @override
  String get createContentFeelingTitle => 'How do you feel right now?';

  @override
  String get createContentFeelingHint =>
      'E.g., This morning was chilly and I suddenly felt lonely';

  @override
  String get createContentStyleTitle => 'How do you want to write?';

  @override
  String get createContentStyleHumor => 'Humorous – meme style';

  @override
  String get createContentStylePoem => 'Write rhyming poetry';

  @override
  String get createContentStyleQuestion => 'Ask engaging questions';

  @override
  String get createContentStyleQuote => 'Use quotes';

  @override
  String get createContentStyleNarrative => 'Descriptive prose';

  @override
  String get createContentStyleStorytelling => 'Storytelling';

  @override
  String get createContentStyleEducation => 'Education / knowledge sharing';

  @override
  String get createContentLengthTitle => 'Short or medium, which suits you?';

  @override
  String get createContentLengthShort => 'Short';

  @override
  String get createContentLengthMedium => 'Medium';

  @override
  String get createContentLengthShortHint => 'Up to 200 characters';

  @override
  String get createContentLengthMediumHint => 'Up to 500 characters';

  @override
  String get createContentMemoryLabel => 'Memory';

  @override
  String get createContentUploadUrlError => 'Could not get upload URL';

  @override
  String get createContentUploadMissingUrl => 'Missing upload URL or file URL';

  @override
  String get createContentUploadFailed => 'Image upload failed';

  @override
  String get createContentUnknownMime => 'Cannot determine image mime type';

  @override
  String get commonShare => 'Share';

  @override
  String get myPetsTitle => 'Your pets';

  @override
  String get myPetsLoading => 'Loading...';

  @override
  String get myPetsLoadError => 'Could not load pet list.';

  @override
  String get myPetsStartChatError => 'Unable to start conversation';

  @override
  String get myPetsEmpty => 'No pets yet.';

  @override
  String get myPetsRetry => 'Retry';

  @override
  String get myPetsAddNew => 'Add a new pet';

  @override
  String get petFormLandingTitle => 'Create pet profile';

  @override
  String get petFormLandingStart => 'Start';

  @override
  String get petFormLandingHero => 'Start by taking a photo of your pet! 📸';

  @override
  String get petFormLandingTips =>
      'For accurate recognition, choose a photo with good lighting ✨, sharp focus 👀, and no obstructions 🚫.';

  @override
  String get petFormChooseProcessing => 'Processing image...';

  @override
  String get petFormNameLabel => 'Pet name';

  @override
  String get petFormGenderLabel => 'Gender';

  @override
  String get petFormNameHint => 'Pet name';

  @override
  String get petFormGenderFemale => 'Female';

  @override
  String get petFormGenderMale => 'Male';

  @override
  String get petFormNeutered => 'Neutered';

  @override
  String get petFormUploadError => 'An error occurred, please try again later.';

  @override
  String get petProfileLoadDataError => 'Could not load required data.';

  @override
  String get petProfileStartChatError => 'Unable to start conversation';

  @override
  String get petProfileNotFound => 'Pet not found.';

  @override
  String get petProfileFeatureComingSoon => 'Feature not ready yet';

  @override
  String get petProfileShortDesc => 'Short description';

  @override
  String get petProfileNoDesc => 'No description yet.';

  @override
  String get petProfileGender => 'Gender';

  @override
  String get petProfileWeight => 'Weight';

  @override
  String get petProfileAppearanceTitle => 'Appearance & markings';

  @override
  String get petProfileImportantDates => 'Important dates';

  @override
  String get petProfileBirthday => 'Birthday';

  @override
  String get petProfileAdoption => 'Adoption date';

  @override
  String get petProfileShareProfile => 'Share profile';

  @override
  String get petProfileLostMode => 'Lost mode';

  @override
  String get petProfileTraits => 'Personality';

  @override
  String get petProfileTones => 'Tone';

  @override
  String get petProfileStyles => 'Writing style';

  @override
  String get petFormStepGeneral => 'General info';

  @override
  String get petFormStepAdditional => 'Additional info';

  @override
  String get petFormStepPersona => 'Personality';

  @override
  String get petFormConfirmAndCreate => 'Confirm and create profile';

  @override
  String get petFormSave => 'Save';

  @override
  String get petFormNameRequired => 'Please enter your pet\'s name';

  @override
  String get petFormBreedRequired => 'Please select your pet\'s breed';

  @override
  String get petFormPersonaRequired => 'Please select your pet\'s personality';

  @override
  String get petFormMasterDataError =>
      'Unable to load required data. Please try again.';

  @override
  String get petFormSpeciesLabel => 'Species';

  @override
  String get petFormBreedLabel => 'Breed';

  @override
  String get petFormWeightLabel => 'Weight';

  @override
  String get petFormHairColorLabel => 'Coat color';

  @override
  String get petFormBirthdayLabel => 'Birthday';

  @override
  String get petFormAdoptionLabel => 'Adoption date';

  @override
  String get petFormDetailInfoLabel => 'Detailed information';

  @override
  String get petFormAppearanceLabel => 'Appearance and distinctive signs';

  @override
  String get petFormSpeciesDog => 'Dog';

  @override
  String get petFormSpeciesCat => 'Cat';

  @override
  String get petFormWaitingTitle => 'Hang tight!';

  @override
  String get petFormWaitingStep1 => 'Analyzing your pet\'s photo';

  @override
  String get petFormWaitingStep2 => 'Identifying species, age, and color';

  @override
  String get petFormWaitingStep3 => 'Recognizing distinctive signs';

  @override
  String get petFormWaitingStep4 => 'Your pet\'s AI profile is ready! 🎉';

  @override
  String get petFormCallPetLabel => 'What does your pet call itself';

  @override
  String get petFormCallOwnerLabel => 'What does your pet call you';

  @override
  String get petFormPersonaRepresentative => 'Representative personality';

  @override
  String get petFormPersonaTitle => 'Choose a personality for your pet';

  @override
  String get petFormPersonaIntro =>
      'Your pet\'s AI needs to know how to call you and itself so you both vibe like true \"Sen - Boss\" buddies!';

  @override
  String get petFormCallPetHint => 'E.g., Me, I, Buddy...';

  @override
  String get petFormCallOwnerHint => 'E.g., Dad, Mom, Aunt, Uncle...';

  @override
  String petFormHobbyHeader(Object count, Object max) {
    return 'Hobbies $count/$max';
  }

  @override
  String get petFormHobbyLoading => 'Loading hobbies...';

  @override
  String petFormHobbyError(Object error) {
    return 'Failed to load hobbies: $error';
  }

  @override
  String get petFormHobbyHint => 'Select hobbies';

  @override
  String get petFormHobbySheetTitle => 'Hobbies';

  @override
  String get petFormHobbyAll => 'All hobbies';

  @override
  String petFormPersonaLoadError(Object error) {
    return 'Error: $error';
  }

  @override
  String get petFormPersonaEmpty => 'No personality data';

  @override
  String get petFormCallPetRequired =>
      'Please enter what your pet calls itself';

  @override
  String get petFormCallOwnerRequired => 'Please enter what your pet calls you';

  @override
  String get petFormHobbyRequired => 'Please select hobbies for your pet';

  @override
  String get petFormPersonaRequired2 =>
      'Please select a personality for your pet';

  @override
  String get petFormCreatePersonaSuccess => 'Pet persona added successfully!';

  @override
  String get petFormGenericError => 'An error occurred, please try again later';

  @override
  String get petProfileHeader => 'Pet profile';

  @override
  String get petProfileAboutTitle => 'About my pet';

  @override
  String get petProfileGenderLabel => 'Gender';

  @override
  String get petProfileSizeLabel => 'Size';

  @override
  String get petProfileWeightLabel => 'Weight';

  @override
  String get petProfileImportantDatesTitle => 'Important dates';

  @override
  String get petProfileAdopted => 'Adoption date';

  @override
  String petProfileAge(Object age) {
    return '$age years old';
  }

  @override
  String get petProfileTabInfo => 'Info';

  @override
  String get petProfilePersonaTitle => 'Pet\'s personality';

  @override
  String get petProfilePersonaTraits => 'Personality';

  @override
  String get petProfilePersonaTone => 'Voice tone';

  @override
  String get petProfilePersonaStyle => 'Writing style';

  @override
  String get sharePetProfileTitle => 'Share profile';

  @override
  String get sharePetProfileOr => 'or';

  @override
  String get sharePetProfileShareLink => 'Share link';

  @override
  String get sharePetProfileComingSoon => 'Feature coming soon';

  @override
  String get petFormAddCollarTitle => 'Add collar';

  @override
  String get petFormAddCollarScan => 'Scan collar code';

  @override
  String get petFormFeatureComingSoon => 'Feature coming soon';

  @override
  String get editPetTitle => 'Edit pet profile';

  @override
  String get editPetCheckingImage => 'Checking image';

  @override
  String get editPetGenericError => 'Something went wrong, please try again.';

  @override
  String get editPetGetInfoError =>
      'Could not load pet info, please try again.';

  @override
  String get editPetNameRequired => 'Please enter your pet\'s name.';

  @override
  String get editPetBreedRequired => 'Please select a breed.';

  @override
  String get editPetBirthdayRequired => 'Please select a birthday.';

  @override
  String get editPetSaveSuccess => 'Profile saved!';

  @override
  String get editPetSaveFail => 'Save failed, please try again.';

  @override
  String get editPetNotRecognizedTitle => 'Pet not recognized';

  @override
  String get editPetNotRecognizedMessage =>
      'We couldn\'t detect a pet in the image you selected. We currently recognize only cats and dogs. Please upload another photo.';

  @override
  String get editPetNotRecognizedRetry => 'Re-upload pet photo';

  @override
  String get editPetTryAnotherImage => 'Please try again with another image';

  @override
  String get editPetSuggestionTitle => 'Suggested changes';

  @override
  String get editPetSuggestionMessage =>
      'Heads up! This image doesn\'t seem to match the previous info.';

  @override
  String get editPetSuggestionPrimary => 'Update with new image data';

  @override
  String get editPetSuggestionSecondary => 'Keep current info';

  @override
  String get editPetSuggestionToast => 'Info updated';

  @override
  String get editPetNameLabel => 'Pet name';

  @override
  String get editPetNameHint => 'Pet name';

  @override
  String get editPetGenderLabel => 'Gender';

  @override
  String get editPetSpeciesLabel => 'Species';

  @override
  String get editPetBreedLabel => 'Breed';

  @override
  String get editPetWeightLabel => 'Weight';

  @override
  String get editPetWeightHint => 'Weight';

  @override
  String get editPetHairColorLabel => 'Fur color';

  @override
  String get editPetBirthdayLabel => 'Birthday';

  @override
  String get editPetAdoptedLabel => 'Adoption date';

  @override
  String get editPetDetailLabel => 'Details';

  @override
  String get editPetAppearanceLabel => 'Appearance & markings';

  @override
  String get editPetSaveButton => 'Save';

  @override
  String get editPetNeuteredLabel => 'Neutered';

  @override
  String get editPetBreedHint => 'Breed';

  @override
  String get editPetBreedLoadingHint => 'Breed (loading...)';

  @override
  String get editPetBreedErrorHint => 'Breed (load failed)';

  @override
  String get editPetBreedSheetTitle => 'Select breed';

  @override
  String get editPetBreedSearchHint => 'Search breed';

  @override
  String get editPetBreedAllSection => 'All breeds';

  @override
  String get editPetInputHint => 'Enter details';

  @override
  String get petProfileSocialTitle => 'Social';

  @override
  String get petProfileSocialViews => 'Profile views';

  @override
  String get petProfileSocialComments => 'Comments';

  @override
  String get petFormTryAnotherImage => 'Please try again with another image';

  @override
  String get petFormBirthdayRequired => 'Please enter your pet\'s birthday.';

  @override
  String get petFormCreateSuccess => 'Pet created successfully!';

  @override
  String get profileLoadError => 'Failed to load profile';

  @override
  String get profileRetry => 'Try again';

  @override
  String get profileMenuAccountInfo => 'Account info';

  @override
  String get profileMenuMyPets => 'My pets';

  @override
  String get profileMenuChangePassword => 'Change password';

  @override
  String get profileMenuTerms => 'Terms & Conditions';

  @override
  String get profileLogout => 'Log out';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordInfo =>
      'Your new password should be different from any old ones you used!';

  @override
  String get changePasswordCurrent => 'Current password';

  @override
  String get changePasswordNew => 'New password';

  @override
  String get changePasswordConfirm => 'Confirm new password';

  @override
  String get changePasswordHintCurrent => 'Enter current password';

  @override
  String get changePasswordHintNew => 'Enter new password';

  @override
  String get changePasswordHintConfirm => 'Re-enter new password';

  @override
  String get changePasswordSave => 'Save changes';

  @override
  String get changePasswordSaving => 'Saving...';

  @override
  String get changePasswordFillAll => 'Please fill in all fields';

  @override
  String get changePasswordRulesNotMet =>
      'New password doesn\'t meet all 3 requirements.';

  @override
  String get changePasswordMinLength =>
      'New password must be at least 6 characters';

  @override
  String get changePasswordDifferent =>
      'New password must be different from the old password';

  @override
  String get changePasswordMismatch => 'Confirmation password doesn\'t match';

  @override
  String get changePasswordSuccess => 'Password changed successfully';

  @override
  String get changePasswordFailed => 'Password change failed';

  @override
  String get profileInfoTitle => 'Update profile';

  @override
  String get profileInfoUpdatingAvatar => 'Updating avatar';

  @override
  String get profileInfoGenericError =>
      'Something went wrong, please try again.';

  @override
  String get profileInfoAvatarSuccess => 'Avatar updated successfully';

  @override
  String get profileInfoFetchError =>
      'Failed to load user data, please try again later.';

  @override
  String get profileInfoNoChanges => 'No changes to update';

  @override
  String get profileInfoUpdateSuccess => 'Changes saved';

  @override
  String get profileInfoUpdateFailed =>
      'Update failed, please try again later.';

  @override
  String get profileInfoNameLabel => 'Full name';

  @override
  String get profileInfoNameHint => 'Your name';

  @override
  String get profileInfoEmailLabel => 'Email';

  @override
  String get profileInfoEmailHint => 'Email';

  @override
  String get profileInfoPhoneLabel => 'Phone number';

  @override
  String get profileInfoPhoneHint => 'Phone number';

  @override
  String get profileInfoAddressLabel => 'Address';

  @override
  String get profileInfoAddressHint => 'Address';

  @override
  String get profileInfoDobLabel => 'Birthday';

  @override
  String get profileInfoDobHint => 'Birthday';

  @override
  String get profileInfoGenderLabel => 'Gender';

  @override
  String get profileInfoGenderSheetTitle => 'Select gender';

  @override
  String get profileInfoGenderSearchHint => 'Search gender';

  @override
  String get profileInfoGenderAll => 'All genders';

  @override
  String get profileInfoSave => 'Save changes';

  @override
  String get profileInfoSaving => 'Saving...';

  @override
  String get termsTitle => 'Privacy Policy';

  @override
  String get termsHeroTitle => 'Privacy Policy – Capcat 🐾';

  @override
  String get termsIntro =>
      'Capcat (\"we\") is committed to protecting your personal data and privacy when using the app. This policy explains how we collect, use, store, and protect your information.';

  @override
  String get termsSection1Title => '1. Information we collect';

  @override
  String get termsSection1Body =>
      'When you use Capcat, we may collect:\\n  •  Account info: email, name, avatar, password.\\n  •  Pet info: name, age, species, photos.\\n  •  Interaction info: AI chat history, notes, journals or “Memory Box” you create.\\n  •  Device data: device type, OS, IP address (for technical and security purposes only).';

  @override
  String get termsSection2Title => '2. How we use information';

  @override
  String get termsSection2Body =>
      'We use your data to:\\n  •  Provide and improve app features.\\n  •  Personalize experience (e.g., whisper suggestions, storytelling from photos/notes).\\n  •  Send notifications about pet activities, product or policy updates.\\n  •  Detect and prevent fraud, keep accounts secure.';

  @override
  String get termsSection3Title => '3. Data sharing';

  @override
  String get termsSection3Body =>
      'We do NOT sell personal information to third parties. Data is only shared when:\\n  •  We have your consent.\\n  •  Required to comply with the law.\\n  •  Working with service providers (e.g., cloud storage) to operate the app.';

  @override
  String get termsSection4Title => '4. Storage & Security';

  @override
  String get termsSection4Body =>
      'Data is stored on secure servers. Passwords are encrypted. We apply technical and organizational security measures to protect your data.';

  @override
  String get termsSection5Title => '5. Your rights';

  @override
  String get termsSection5Body =>
      'You can:\\n  •  View, edit, or delete your profile info.\\n  •  Request to delete your account and all related data.\\n  •  Opt out of promotional notifications at any time.';

  @override
  String get termsSection6Title => '6. Retention period';

  @override
  String get termsSection6Body =>
      'We keep your information while you use the app. If you stop using it, we will delete data within 30 days.';

  @override
  String get termsSection7Title => '7. Data when signing in with Google';

  @override
  String get termsSection7Body =>
      'When you use “Sign in with Google”, we only access an anonymous email to create an account. We do not use Google data for marketing or sharing without individual consent.';

  @override
  String get termsContact =>
      'If you have questions or requests about privacy, please contact:';

  @override
  String get termsContactEmail => 'support@capcat.app';
}
