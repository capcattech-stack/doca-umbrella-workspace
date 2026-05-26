// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'CapCat';

  @override
  String get commonContinue => 'Tiếp tục';

  @override
  String get commonBack => 'Quay lại';

  @override
  String get commonErrorTryAgain => 'Đã có lỗi, vui lòng thử lại sau';

  @override
  String get forgotPhoneTitle => 'Gửi số của sen vô đây đi!';

  @override
  String get forgotPhoneSubtitle =>
      'Sen ơi, nhập số điện thoại để tụi mình nhận ra nha!';

  @override
  String get forgotPhoneContinue => 'Tiếp tục';

  @override
  String get forgotOtpTitle => 'Xác minh số điện thoại';

  @override
  String forgotOtpSubtitle(Object phone) {
    return 'Vui lòng nhập mã mà chúng mình đã gửi đến\n$phone';
  }

  @override
  String get forgotOtpHint => 'Nhập mã code';

  @override
  String get forgotOtpResend => 'Gửi lại';

  @override
  String get forgotOtpIn => 'trong';

  @override
  String get forgotOtpConfirm => 'Xác nhận';

  @override
  String get forgotNewPasswordTitle =>
      'Boss giữ bí mật giùm nè,\ntạo mật khẩu mới lẹ đi sen!';

  @override
  String get forgotNewPasswordSubtitle =>
      'Nhập mật khẩu mới 2 lần để boss chắc chắn là bạn sẽ nhớ nha!';

  @override
  String get forgotNewPasswordRulesError =>
      'Mật khẩu mới chưa đáp ứng đủ 3 yêu cầu.';

  @override
  String get forgotNewPasswordMismatch => 'Mật khẩu nhập lại không khớp';

  @override
  String get forgotNewPasswordHint => 'Mật khẩu';

  @override
  String get forgotNewPasswordConfirmHint => 'Nhập lại mật khẩu';

  @override
  String get forgotNewPasswordButton => 'Xác nhận';

  @override
  String get introTitle => 'Hồ sơ thú cưng cá nhân hóa';

  @override
  String get introDescription =>
      'Tạo hồ sơ cá nhân hóa cho từng thú cưng yêu quý của bạn trên PawBuddy. Chia sẻ tên, giống, và tuổi của chúng trong khi kết nối với một cộng đồng sôi động.';

  @override
  String get introStart => 'Bắt đầu ngay';

  @override
  String get socialPhoneTitle => 'Nhập số điện thoại';

  @override
  String get socialPhoneSubtitle =>
      'Vui lòng nhập số điện thoại để hoàn thành đăng nhập nhé.';

  @override
  String phoneRegisterOtpSubtitle(Object phone) {
    return 'Check điện thoại nha sen, mã đã gửi về số\n$phone rồi đó';
  }

  @override
  String get toastLoginSuccess => 'Đăng nhập thành công';

  @override
  String get toastLinkLoginSuccess => 'Đăng nhập liên kết thành công';

  @override
  String get toastRegisterSuccess => 'Đăng ký thành công';

  @override
  String get toastLinkRegisterSuccess => 'Đăng ký liên kết thành công';

  @override
  String get toastChangePasswordSuccess => 'Đổi mật khẩu thành công';

  @override
  String get tabLogin => 'Đăng nhập';

  @override
  String get tabRegister => 'Đăng ký';

  @override
  String get signInPasswordHint => 'Mật khẩu';

  @override
  String get signInButton => 'Đăng nhập';

  @override
  String get signInWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get signInTitle => 'Chào mừng trở lại';

  @override
  String get signInDescription =>
      'Nhập thông tin đăng nhập của bạn để tiếp tục.';

  @override
  String get signInPhoneEmpty => 'Vui lòng nhập số điện thoại.';

  @override
  String get signInPasswordEmpty => 'Vui lòng nhập mật khẩu.';

  @override
  String get signInForgotPrefix => 'Quên mật khẩu? ';

  @override
  String get signInForgotLink => 'Nhấn vào đây';

  @override
  String get signInOr => 'Hoặc';

  @override
  String get signUpPasswordRuleError => 'Mật khẩu phải đáp ứng đủ 3 yêu cầu.';

  @override
  String get signUpPasswordMismatch => 'Mật khẩu không khớp.';

  @override
  String get signUpPasswordHint => 'Mật khẩu';

  @override
  String get signUpPasswordConfirmHint => 'Nhập lại mật khẩu';

  @override
  String get signUpButton => 'Đăng ký';

  @override
  String get signUpFillAll => 'Vui lòng điền đầy đủ thông tin.';

  @override
  String get signUpInvalidPhone => 'Số điện thoại không hợp lệ';

  @override
  String get signUpNameHint => 'Tên của bạn';

  @override
  String get signUpTitle => 'Sen mới, điểm danh!';

  @override
  String get signUpDescription =>
      'Sen ơi, nhập thông tin để boss biết tên nha!';

  @override
  String get phoneInputHint => 'Số điện thoại';

  @override
  String get passwordRuleLength => 'Mật khẩu phải dài 8-20 ký tự';

  @override
  String get passwordRuleNumber => 'Mật khẩu phải chứa ít nhất một chữ số';

  @override
  String get passwordRuleUpper => 'Mật khẩu phải có ít nhất 1 chữ viết hoa';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get chatLandingHeader => 'Chọn bé cưng để nói chuyện';

  @override
  String get chatLandingConversationError =>
      'Không tải được danh sách cuộc trò chuyện.';

  @override
  String get chatLandingConversationTitle => 'Cuộc trò chuyện';

  @override
  String get chatLandingSuggestionTitle => 'Gợi ý';

  @override
  String get chatLandingPetError => 'Không tải được danh sách bé cưng.';

  @override
  String get chatLandingStartConversation => 'Bắt đầu cuộc trò chuyện';

  @override
  String chatLandingPreviewYou(Object message) {
    return 'Bạn: $message';
  }

  @override
  String get chatLandingEmpty => 'Chưa có cuộc trò chuyện nào.';

  @override
  String get chatLandingLoading => 'Đang tải...';

  @override
  String get chatLandingCannotStartConversation =>
      'Không thể bắt đầu cuộc trò chuyện';

  @override
  String get chatLandingFilterAll => 'Tất cả';

  @override
  String get chatLandingFilterYours => 'Nhà bạn';

  @override
  String get chatLandingFilterCapcat => 'Nhà CAPCAT';

  @override
  String get numerologyTitle => 'Thần số học';

  @override
  String get numerologySend => 'Gửi';

  @override
  String get numerologySending => 'Đang gửi...';

  @override
  String get numerologyNameLabel => 'Họ và tên';

  @override
  String get numerologyNameHint => 'Nhập họ tên';

  @override
  String get numerologyDobLabel => 'Ngày sinh';

  @override
  String get numerologyDobHint => 'Chọn ngày sinh';

  @override
  String get numerologyResultLabel => 'Kết quả';

  @override
  String get numerologyComingSoon => 'Sắp ra mắt';

  @override
  String get numerologyGetFullAnalysis => 'Nhận file phân tích đầy đủ';

  @override
  String get numerologyIntroQuote =>
      '“Tụi con sẽ tìm cho Sen con số chủ đạo, Sen điền vài thông tin cơ bản thôi, lại đây con chỉ cho”';

  @override
  String get numerologyNotice =>
      '“Tính năng mang tính giải trí, không phải mê tín hay dự đoán vận mệnh đâu Sen ơi.”';

  @override
  String get numerologyNameEmpty => 'Vui lòng nhập họ và tên';

  @override
  String get numerologyDobEmpty => 'Vui lòng chọn ngày sinh';

  @override
  String get numerologyAnalyzing => 'Đang phân tích Thần số học';

  @override
  String get numerologySubmitFailed =>
      'Gửi yêu cầu thất bại, vui lòng thử lại.';

  @override
  String get zodiacTitle => 'Mật ngữ chòm sao';

  @override
  String get zodiacSend => 'Gửi';

  @override
  String get zodiacSending => 'Đang gửi...';

  @override
  String get zodiacDobLabel => 'Ngày sinh';

  @override
  String get zodiacDobHint => 'Chọn ngày sinh';

  @override
  String get zodiacCardPlaceholderName => 'Cung hoàng đạo';

  @override
  String get zodiacTopicTitle => 'Sen muốn biết gì ?';

  @override
  String get zodiacTopicPersonality => 'Đặc điểm tính cách và năng lực';

  @override
  String get zodiacTopicNextWeek => 'Vận mệnh tuần tới';

  @override
  String get zodiacTopicNextMonth => 'Vận mệnh tháng tới';

  @override
  String get createContentUploadingImage => 'Đang tải ảnh, vui lòng đợi...';

  @override
  String get createContentSelectImage => 'Vui lòng chọn và tải ảnh lên';

  @override
  String get createContentEnterMood => 'Vui lòng nhập cảm xúc';

  @override
  String get createContentAnalyzing => 'Đang giúp Sen tạo caption hay';

  @override
  String get createContentSubmitFailed =>
      'Gửi yêu cầu thất bại, vui lòng thử lại.';

  @override
  String get chatNewInputHint => 'Nhập tin nhắn...';

  @override
  String get chatNewLoadingMessages => 'Đang tải tin nhắn...';

  @override
  String chatNewLoadMessagesError(Object message) {
    return 'Không tải được tin nhắn.\n$message';
  }

  @override
  String get chatNewRetry => 'Thử lại';

  @override
  String get chatNewNoMessages =>
      'Hãy bắt đầu cuộc trò chuyện với bé yêu của mình!';

  @override
  String get chatNewSuggestionLoading => 'Đang tải nội dung gợi ý...';

  @override
  String get chatNewSuggestionError => 'Không tải được nội dung gợi ý.';

  @override
  String get chatNewSendImages => 'Gửi hình ảnh';

  @override
  String get chatNewToolNumerology => 'Thần số học';

  @override
  String get chatNewToolZodiac => 'Mật ngữ chòm sao';

  @override
  String get chatNewToolCaption => 'Caption hay';

  @override
  String get chatNewToolComingSoon => 'Sắp ra mắt';

  @override
  String get chatNewUploadingImage => 'Đang tải ảnh, vui lòng đợi...';

  @override
  String get chatNewUploadingAnotherImage =>
      'Đang tải ảnh khác, vui lòng đợi...';

  @override
  String get chatNewUploadingImageShort => 'Đang tải ảnh...';

  @override
  String get chatNewLoadingConversation => 'Đang tải cuộc trò chuyện...';

  @override
  String get chatNewSuggestionErrorWithRetry =>
      'Không tải được nội dung gợi ý, vui lòng thử lại.';

  @override
  String get chatNewUploadFailed => 'Gửi ảnh thất bại, vui lòng thử lại.';

  @override
  String get chatNewToolDiary => 'Viết nhật ký';

  @override
  String get chatNewToolOilPainting => 'Vẽ tranh sơn dầu';

  @override
  String get chatNewToolStudio => 'Chụp Studio';

  @override
  String get chatNewToolCompose => 'Sáng tác';

  @override
  String get chatOldBotResponse1 => 'Chào bạn!';

  @override
  String get chatOldBotResponse2 => 'Bạn đang làm gì đó?';

  @override
  String get chatOldBotResponse3 => 'Trời hôm nay đẹp quá!';

  @override
  String get chatOldBotResponse4 => 'Bạn ăn cơm chưa?';

  @override
  String get chatOldBotResponse5 => 'Tôi là chatbot giả lập.';

  @override
  String get chatOldBotResponse6 => 'Flutter rất tuyệt!';

  @override
  String get chatOldBotResponse7 => 'Bạn cần nghỉ ngơi đó.';

  @override
  String get chatOldBotResponse8 => 'Cảm ơn vì đã nhắn cho tôi.';

  @override
  String get chatOldBotResponse9 => 'Gặp lại sau nhé!';

  @override
  String get chatOldBotResponse10 => 'Tôi là robot.';

  @override
  String get chatOldBotResponse11 => 'Thử lại xem sao!';

  @override
  String get chatOldBotResponse12 => 'Cố gắng lên!';

  @override
  String get chatOldSampleMessage1 => 'Xin chào!';

  @override
  String get chatOldSampleMessage2 => 'Hôm nay bạn thế nào?';

  @override
  String get chatOldSampleMessage3 => 'Tôi đang học Flutter.';

  @override
  String get chatOldSampleMessage4 => 'Bạn thích lập trình chứ?';

  @override
  String get chatOldSampleMessage5 => 'Chúng ta cùng thử chatbot nhé.';

  @override
  String get chatOldProductsIntro => 'Đây là một số sản phẩm dành cho bạn:';

  @override
  String get chatOldImagesIntro => 'Đây là những hình ảnh mẫu:';

  @override
  String get chatOldInputHint => 'Nhập tin nhắn...';

  @override
  String get createContentTitle => 'Caption hay';

  @override
  String get createContentIntroQuote =>
      '“Nhiều khi mình có mấy cái hình thiệt là đẹp mà không biết viết gì cho hay, lại đây con chỉ cho”';

  @override
  String get createContentResultQuote =>
      '“Giờ mình chỉ việc chia sẻ nội dung thôi nè, lại đây con chỉ cho nha!”';

  @override
  String get createContentPrepTip =>
      '“Vậy là Sen sắp có được 1 caption hấp dẫn rồi đó!”';

  @override
  String get createContentShareTip =>
      '“Con sẽ giúp Sen đăng bài đúng độ phân giải sao cho sắc nét nhất nhen”';

  @override
  String get createContentResultEmpty =>
      'Chưa có kết quả hiển thị. Vui lòng thử lại hoặc quay lại chỉnh sửa.';

  @override
  String get createContentBackToChat => 'Trở về đoạn chat';

  @override
  String get createContentShare => 'Chia sẻ';

  @override
  String get createContentProcessingImage => 'Đang xử lý ảnh...';

  @override
  String get createContentChooseImage => 'Chọn ảnh từ thư viện';

  @override
  String get createContentFeelingTitle => 'Lúc này Sen cảm thấy thế nào ?';

  @override
  String get createContentFeelingHint =>
      'VD: Sáng hôm đó trời se lạnh tự nhiên thấy cô đơn';

  @override
  String get createContentStyleTitle => 'Sen muốn viết thế nào?';

  @override
  String get createContentStyleHumor => 'Hài hước – meme style';

  @override
  String get createContentStylePoem => 'Làm thơ gieo vần';

  @override
  String get createContentStyleQuestion => 'Đặt câu hỏi tăng tương tác';

  @override
  String get createContentStyleQuote => 'Sử dụng câu Quote (trích dẫn)';

  @override
  String get createContentStyleNarrative => 'Tản văn mô tả cảm xúc, tả cảnh';

  @override
  String get createContentStyleStorytelling => 'Kể chuyện (Storytelling)';

  @override
  String get createContentStyleEducation => 'Giáo dục / chia sẻ kiến thức';

  @override
  String get createContentLengthTitle => 'Viết ngắn hay dài đây Sen?';

  @override
  String get createContentLengthShort => 'Ngắn';

  @override
  String get createContentLengthMedium => 'Trung bình';

  @override
  String get createContentLengthShortHint => 'Tối đa 200 kí tự';

  @override
  String get createContentLengthMediumHint => 'Tối đa 500 kí tự';

  @override
  String get createContentMemoryLabel => 'Memory';

  @override
  String get createContentUploadUrlError => 'Không lấy được upload URL';

  @override
  String get createContentUploadMissingUrl => 'Thiếu upload URL hoặc file URL';

  @override
  String get createContentUploadFailed => 'Tải ảnh lên thất bại';

  @override
  String get createContentUnknownMime =>
      'Không xác định được mime type của ảnh';

  @override
  String get commonShare => 'Chia sẻ';

  @override
  String get myPetsTitle => 'Danh sách thú cưng';

  @override
  String get myPetsLoading => 'Đang tải...';

  @override
  String get myPetsLoadError => 'Không tải được danh sách thú cưng.';

  @override
  String get myPetsStartChatError => 'Không thể bắt đầu cuộc trò chuyện';

  @override
  String get myPetsEmpty => 'Chưa có thú cưng nào.';

  @override
  String get myPetsRetry => 'Thử lại';

  @override
  String get myPetsAddNew => 'Thêm thú cưng mới';

  @override
  String get petFormLandingTitle => 'Tạo thông tin thú cưng';

  @override
  String get petFormLandingStart => 'Bắt đầu';

  @override
  String get petFormLandingHero =>
      'Bắt đầu bằng cách\nchụp ảnh bé cưng nhé! 📸';

  @override
  String get petFormLandingTips =>
      'Để nhận diện chính xác các đặc điểm của bé, bạn hãy chọn ảnh có: ánh sáng tốt ✨, rõ nét 👀, không bị che khuất 🚫.';

  @override
  String get petFormChooseProcessing => 'Đang xử lý hình ảnh';

  @override
  String get petFormNameLabel => 'Tên bé cưng';

  @override
  String get petFormGenderLabel => 'Giới tính';

  @override
  String get petFormNameHint => 'Tên bé cưng';

  @override
  String get petFormGenderFemale => 'Cái';

  @override
  String get petFormGenderMale => 'Đực';

  @override
  String get petFormNeutered => 'Đã triệt sản';

  @override
  String get petFormUploadError => 'Đã có lỗi, vui lòng thử lại sau.';

  @override
  String get petProfileLoadDataError => 'Không tải được dữ liệu cần thiết.';

  @override
  String get petProfileStartChatError => 'Không thể bắt đầu cuộc trò chuyện';

  @override
  String get petProfileNotFound => 'Không tìm thấy thú cưng.';

  @override
  String get petProfileFeatureComingSoon => 'Tính năng chưa sẵn sàng';

  @override
  String get petProfileShortDesc => 'Mô tả ngắn';

  @override
  String get petProfileNoDesc => 'Chưa có mô tả về bé.';

  @override
  String get petProfileGender => 'Giới tính';

  @override
  String get petProfileWeight => 'Cân nặng';

  @override
  String get petProfileAppearanceTitle => 'Ngoại hình và dấu hiệu đặc trưng';

  @override
  String get petProfileImportantDates => 'Ngày Quan Trọng';

  @override
  String get petProfileBirthday => 'Ngày sinh nhật';

  @override
  String get petProfileAdoption => 'Ngày nhận nuôi';

  @override
  String get petProfileShareProfile => 'Chia sẻ hồ sơ';

  @override
  String get petProfileLostMode => 'Chế độ thất lạc';

  @override
  String get petProfileTraits => 'Tính cách';

  @override
  String get petProfileTones => 'Tone giọng';

  @override
  String get petProfileStyles => 'Văn phong';

  @override
  String get petFormStepGeneral => 'Thông tin chung';

  @override
  String get petFormStepAdditional => 'Thông tin thêm';

  @override
  String get petFormStepPersona => 'Tính cách';

  @override
  String get petFormConfirmAndCreate => 'Xác nhận thông tin và tạo hồ sơ';

  @override
  String get petFormSave => 'Lưu lại';

  @override
  String get petFormNameRequired => 'Bạn hãy nhập tên cho bé cưng nhé';

  @override
  String get petFormBreedRequired => 'Bạn hãy chọn giống của bé cưng nhé';

  @override
  String get petFormPersonaRequired => 'Vui lòng chọn tính cách của bé';

  @override
  String get petFormMasterDataError =>
      'Không tải được dữ liệu cần thiết. Vui lòng thử lại.';

  @override
  String get petFormSpeciesLabel => 'Loài';

  @override
  String get petFormBreedLabel => 'Giống';

  @override
  String get petFormWeightLabel => 'Cân nặng';

  @override
  String get petFormHairColorLabel => 'Màu lông';

  @override
  String get petFormBirthdayLabel => 'Ngày sinh';

  @override
  String get petFormAdoptionLabel => 'Ngày nhận nuôi';

  @override
  String get petFormDetailInfoLabel => 'Thông tin chi tiết';

  @override
  String get petFormAppearanceLabel => 'Ngoại hình và dấu hiệu đặc trưng';

  @override
  String get petFormSpeciesDog => 'Chó';

  @override
  String get petFormSpeciesCat => 'Mèo';

  @override
  String get petFormWaitingTitle => 'Chờ xíu nha !!!';

  @override
  String get petFormWaitingStep1 => 'Đang phân tích ảnh thú cưng của bạn';

  @override
  String get petFormWaitingStep2 => 'Xác định giống loài, tuổi và màu sắc';

  @override
  String get petFormWaitingStep3 => 'Nhận diện dấu hiệu đặc trưng';

  @override
  String get petFormWaitingStep4 => 'Hồ sơ AI của thú cưng sẵn sàng rồi! 🎉';

  @override
  String get petFormCallPetLabel => 'Bé tự xưng là';

  @override
  String get petFormCallOwnerLabel => 'Bé gọi bạn là';

  @override
  String get petFormPersonaRepresentative => 'Tính cách đại diện';

  @override
  String get petFormPersonaTitle => 'Chọn tính cách cho bé cưng';

  @override
  String get petFormPersonaIntro =>
      'Pet AI của bạn cũng giống thú cưng ngoài đời — cần biết bạn là người thế nào, gọi bạn ra sao và bạn muốn được bé gọi thế nào. Như vậy mới tám chuyện hợp vibe, cưng chiều nhau đúng kiểu ‘Sen - Boss’ nhé!';

  @override
  String get petFormCallPetHint => 'VD: Con, Em, Tui,...';

  @override
  String get petFormCallOwnerHint => 'VD: Ba, Mẹ, Cô, Chú,...';

  @override
  String petFormHobbyHeader(Object count, Object max) {
    return 'Sở thích $count/$max';
  }

  @override
  String get petFormHobbyLoading => 'Đang tải sở thích...';

  @override
  String petFormHobbyError(Object error) {
    return 'Lỗi tải danh sách sở thích: $error';
  }

  @override
  String get petFormHobbyHint => 'Chọn sở thích';

  @override
  String get petFormHobbySheetTitle => 'Sở thích';

  @override
  String get petFormHobbyAll => 'Tất cả sở thích';

  @override
  String petFormPersonaLoadError(Object error) {
    return 'Lỗi: $error';
  }

  @override
  String get petFormPersonaEmpty => 'Không có dữ liệu tính cách';

  @override
  String get petFormCallPetRequired => 'Bạn hãy điền mục \"Bé tự xưng là\" nhé';

  @override
  String get petFormCallOwnerRequired =>
      'Bạn hãy điền mục \"Bé gọi bạn là\" nhé';

  @override
  String get petFormHobbyRequired => 'Bạn hãy chọn sở thích cho bé nhé';

  @override
  String get petFormPersonaRequired2 => 'Bạn hãy chọn tính cách của bé nhé';

  @override
  String get petFormCreatePersonaSuccess =>
      'Thêm tính cách thú cưng thành công!';

  @override
  String get petFormGenericError => 'Đã có lỗi, vui lòng thử lại sau';

  @override
  String get petProfileHeader => 'Hồ sơ bé yêu';

  @override
  String get petProfileAboutTitle => 'Về bé yêu';

  @override
  String get petProfileGenderLabel => 'Giới tính';

  @override
  String get petProfileSizeLabel => 'Kích thước';

  @override
  String get petProfileWeightLabel => 'Cân nặng';

  @override
  String get petProfileImportantDatesTitle => 'Ngày quan trọng';

  @override
  String get petProfileAdopted => 'Ngày nhận nuôi';

  @override
  String petProfileAge(Object age) {
    return '$age tuổi';
  }

  @override
  String get petProfileTabInfo => 'Thông tin';

  @override
  String get petProfilePersonaTitle => 'Tính cách của bé';

  @override
  String get petProfilePersonaTraits => 'Tính cách';

  @override
  String get petProfilePersonaTone => 'Tone giọng';

  @override
  String get petProfilePersonaStyle => 'Văn phong';

  @override
  String get sharePetProfileTitle => 'Chia sẻ hồ sơ';

  @override
  String get sharePetProfileOr => 'hoặc';

  @override
  String get sharePetProfileShareLink => 'Chia sẻ liên kết';

  @override
  String get sharePetProfileComingSoon => 'Tính năng chưa sẵn sàng';

  @override
  String get petFormAddCollarTitle => 'Thêm vòng cổ';

  @override
  String get petFormAddCollarScan => 'Scan code vòng cổ';

  @override
  String get petFormFeatureComingSoon => 'Tính năng chưa sẵn sàng';

  @override
  String get editPetTitle => 'Chỉnh sửa thông tin';

  @override
  String get editPetCheckingImage => 'Đang kiểm tra hình ảnh';

  @override
  String get editPetGenericError => 'Đã có lỗi, vui lòng thử lại sau';

  @override
  String get editPetGetInfoError =>
      'Đã có lỗi khi lấy thông tin của bé, vui lòng thử lại sau.';

  @override
  String get editPetNameRequired => 'Vui lòng nhập tên cho bé.';

  @override
  String get editPetBreedRequired => 'Vui lòng chọn giống.';

  @override
  String get editPetBirthdayRequired => 'Vui lòng chọn ngày sinh.';

  @override
  String get editPetSaveSuccess => 'Lưu hồ sơ thành công!';

  @override
  String get editPetSaveFail => 'Lưu thất bại, vui lòng thử lại.';

  @override
  String get editPetNotRecognizedTitle => 'Chưa nhận diện được thú cưng';

  @override
  String get editPetNotRecognizedMessage =>
      'Chúng mình không nhận ra thú cưng trong hình ảnh bạn vừa chọn. Hiện tại chúng mình chỉ nhận diện được Mèo và Chó. Sen vui lòng tải lại hình ảnh nhé!';

  @override
  String get editPetNotRecognizedRetry => 'Tải lại ảnh bé cưng';

  @override
  String get editPetTryAnotherImage => 'Bạn hãy thử lại với hình ảnh khác nhé';

  @override
  String get editPetSuggestionTitle => 'Đề xuất sửa đổi';

  @override
  String get editPetSuggestionMessage =>
      'Cẩn thận nhen, hình ảnh này coi bộ không khớp với thông tin trước đó đâu!';

  @override
  String get editPetSuggestionPrimary => 'Đổi thông tin theo hình ảnh mới';

  @override
  String get editPetSuggestionSecondary => 'Giữ thông tin cũ';

  @override
  String get editPetSuggestionToast => 'Thông tin đã được cập nhật';

  @override
  String get editPetNameLabel => 'Tên bé cưng';

  @override
  String get editPetNameHint => 'Tên bé cưng';

  @override
  String get editPetGenderLabel => 'Giới tính';

  @override
  String get editPetSpeciesLabel => 'Loài';

  @override
  String get editPetBreedLabel => 'Giống';

  @override
  String get editPetWeightLabel => 'Cân nặng';

  @override
  String get editPetWeightHint => 'Cân nặng';

  @override
  String get editPetHairColorLabel => 'Màu lông';

  @override
  String get editPetBirthdayLabel => 'Ngày sinh';

  @override
  String get editPetAdoptedLabel => 'Ngày nhận nuôi';

  @override
  String get editPetDetailLabel => 'Thông tin chi tiết';

  @override
  String get editPetAppearanceLabel => 'Ngoại hình và dấu hiệu đặc trưng';

  @override
  String get editPetSaveButton => 'Lưu lại';

  @override
  String get editPetNeuteredLabel => 'Đã triệt sản';

  @override
  String get editPetBreedHint => 'Giống';

  @override
  String get editPetBreedLoadingHint => 'Giống (đang tải...)';

  @override
  String get editPetBreedErrorHint => 'Giống (tải lỗi)';

  @override
  String get editPetBreedSheetTitle => 'Chọn giống';

  @override
  String get editPetBreedSearchHint => 'Tìm giống';

  @override
  String get editPetBreedAllSection => 'Tất cả các giống';

  @override
  String get editPetInputHint => 'Nhập thông tin';

  @override
  String get petProfileSocialTitle => 'Mạng xã hội';

  @override
  String get petProfileSocialViews => 'Lượt xem profile';

  @override
  String get petProfileSocialComments => 'Bình luận';

  @override
  String get petFormTryAnotherImage => 'Bạn hãy thử lại với hình ảnh khác nhé';

  @override
  String get petFormBirthdayRequired =>
      'Bạn hãy nhập ngày sinh cho bé cưng nhé';

  @override
  String get petFormCreateSuccess => 'Tạo thú cưng thành công!';

  @override
  String get profileLoadError => 'Không tải được hồ sơ';

  @override
  String get profileRetry => 'Thử lại';

  @override
  String get profileMenuAccountInfo => 'Thông tin tài khoản';

  @override
  String get profileMenuMyPets => 'Thú cưng của tôi';

  @override
  String get profileMenuChangePassword => 'Đổi mật khẩu';

  @override
  String get profileMenuTerms => 'Điều khoản & Điều kiện';

  @override
  String get profileLogout => 'Đăng xuất';

  @override
  String get changePasswordTitle => 'Đổi mật khẩu';

  @override
  String get changePasswordInfo =>
      'Mật khẩu mới nên khác mấy “xương cũ” mà Sen từng dùng nha!';

  @override
  String get changePasswordCurrent => 'Mật khẩu hiện tại';

  @override
  String get changePasswordNew => 'Mật khẩu mới';

  @override
  String get changePasswordConfirm => 'Nhập lại mật khẩu mới';

  @override
  String get changePasswordHintCurrent => 'Nhập mật khẩu hiện tại';

  @override
  String get changePasswordHintNew => 'Nhập mật khẩu mới';

  @override
  String get changePasswordHintConfirm => 'Nhập lại mật khẩu mới';

  @override
  String get changePasswordSave => 'Lưu thay đổi';

  @override
  String get changePasswordSaving => 'Đang lưu...';

  @override
  String get changePasswordFillAll => 'Vui lòng nhập đầy đủ thông tin';

  @override
  String get changePasswordRulesNotMet =>
      'Mật khẩu mới chưa đáp ứng đủ 3 yêu cầu.';

  @override
  String get changePasswordMinLength => 'Mật khẩu mới phải từ 6 ký tự trở lên';

  @override
  String get changePasswordDifferent => 'Mật khẩu mới phải khác mật khẩu cũ';

  @override
  String get changePasswordMismatch => 'Nhập lại mật khẩu không khớp';

  @override
  String get changePasswordSuccess => 'Đổi mật khẩu thành công';

  @override
  String get changePasswordFailed => 'Đổi mật khẩu thất bại';

  @override
  String get profileInfoTitle => 'Thay đổi thông tin';

  @override
  String get profileInfoUpdatingAvatar => 'Đang cập nhật ảnh đại diện';

  @override
  String get profileInfoGenericError => 'Đã có lỗi, vui lòng thử lại sau';

  @override
  String get profileInfoAvatarSuccess => 'Đổi ảnh đại diện thành công';

  @override
  String get profileInfoFetchError =>
      'Lấy dữ liệu người dùng thất bại, vui lòng thử lại sau.';

  @override
  String get profileInfoNoChanges => 'Không có thay đổi nào để cập nhật';

  @override
  String get profileInfoUpdateSuccess => 'Đã lưu thay đổi';

  @override
  String get profileInfoUpdateFailed =>
      'Cập nhật thất bại, vui lòng thử lại sau.';

  @override
  String get profileInfoNameLabel => 'Họ và tên';

  @override
  String get profileInfoNameHint => 'Tên của bạn';

  @override
  String get profileInfoEmailLabel => 'Email';

  @override
  String get profileInfoEmailHint => 'Email';

  @override
  String get profileInfoPhoneLabel => 'Số điện thoại';

  @override
  String get profileInfoPhoneHint => 'Số điện thoại';

  @override
  String get profileInfoAddressLabel => 'Địa chỉ';

  @override
  String get profileInfoAddressHint => 'Địa chỉ';

  @override
  String get profileInfoDobLabel => 'Chọn ngày sinh';

  @override
  String get profileInfoDobHint => 'Ngày sinh';

  @override
  String get profileInfoGenderLabel => 'Giới tính';

  @override
  String get profileInfoGenderSheetTitle => 'Chọn giới tính';

  @override
  String get profileInfoGenderSearchHint => 'Tìm giới tính';

  @override
  String get profileInfoGenderAll => 'Tất cả giới tính';

  @override
  String get profileInfoSave => 'Lưu thay đổi';

  @override
  String get profileInfoSaving => 'Đang lưu...';

  @override
  String get termsTitle => 'Chính sách bảo mật';

  @override
  String get termsHeroTitle => 'Chính sách Bảo mật – Capcat 🐾';

  @override
  String get termsIntro =>
      'Capcat (“chúng mình”) cam kết bảo vệ dữ liệu cá nhân và quyền riêng tư của bạn khi sử dụng ứng dụng. Chính sách này giải thích cách thu thập, sử dụng, lưu trữ và bảo vệ thông tin của bạn.';

  @override
  String get termsSection1Title => '1. Thông tin chúng tôi thu thập';

  @override
  String get termsSection1Body =>
      'Khi bạn dùng Capcat, chúng tôi có thể thu thập:\n  •  Thông tin tài khoản: email, tên, ảnh đại diện, mật khẩu.\n  •  Thông tin thú cưng: tên, tuổi, giống loài, ảnh.\n  •  Thông tin tương tác: lịch sử chat AI, ghi chú, nhật ký hoặc “Memory Box” bạn tạo.\n  •  Dữ liệu thiết bị: loại thiết bị, hệ điều hành, địa chỉ IP (chỉ dùng cho mục đích kỹ thuật và bảo mật).';

  @override
  String get termsSection2Title => '2. Cách chúng tôi sử dụng thông tin';

  @override
  String get termsSection2Body =>
      'Chúng tôi dùng dữ liệu của bạn để:\n  •  Cung cấp và cải thiện tính năng app.\n  •  Cá nhân hoá trải nghiệm (ví dụ: gợi ý whisper, storytelling từ ảnh/note).\n  •  Gửi thông báo về hoạt động thú cưng, cập nhật sản phẩm hoặc chính sách.\n  •  Phát hiện và ngăn chặn hành vi gian lận, đảm bảo an toàn tài khoản.';

  @override
  String get termsSection3Title => '3. Chia sẻ dữ liệu';

  @override
  String get termsSection3Body =>
      'Chúng tôi KHÔNG bán thông tin cá nhân cho bên thứ ba. Thông tin chỉ được chia sẻ khi:\n  •  Có sự đồng ý của bạn.\n  •  Cần thiết để tuân thủ pháp luật.\n  •  Hợp tác với nhà cung cấp dịch vụ (ví dụ: lưu trữ cloud) để vận hành app.';

  @override
  String get termsSection4Title => '4. Lưu trữ & Bảo mật';

  @override
  String get termsSection4Body =>
      'Dữ liệu được lưu trữ trên máy chủ an toàn. Mật khẩu được mã hoá. Chúng tôi áp dụng các biện pháp bảo mật kỹ thuật và tổ chức để bảo vệ dữ liệu của bạn.';

  @override
  String get termsSection5Title => '5. Quyền của bạn';

  @override
  String get termsSection5Body =>
      'Bạn có thể:\n  •  Xem, chỉnh sửa, hoặc xoá thông tin hồ sơ.\n  •  Yêu cầu xoá tài khoản và toàn bộ dữ liệu liên quan.\n  •  Từ chối nhận thông báo quảng cáo bất kỳ lúc nào.';

  @override
  String get termsSection6Title => '6. Thời gian lưu trữ';

  @override
  String get termsSection6Body =>
      'Chúng tôi sẽ lưu trữ thông tin của bạn trong suốt quá trình bạn sử dụng ứng dụng. Nếu bạn ngừng sử dụng. Chúng tôi sẽ xóa dữ liệu trong vòng 30 ngày.';

  @override
  String get termsSection7Title => '7. Dữ liệu khi đăng nhập với Google';

  @override
  String get termsSection7Body =>
      'Khi bạn sử dụng tính năng “Đăng nhập với Google”, chúng tôi chỉ truy cập email ẩn danh và sử dụng để tạo tài khoản. Không sử dụng dữ liệu Google để tiếp thị hoặc chia sẻ mà không có sự đồng ý của cá nhân.';

  @override
  String get termsContact =>
      'Nếu có câu hỏi hoặc yêu cầu về quyền riêng tư, vui lòng liên hệ:';

  @override
  String get termsContactEmail => 'support@capcat.app';
}
