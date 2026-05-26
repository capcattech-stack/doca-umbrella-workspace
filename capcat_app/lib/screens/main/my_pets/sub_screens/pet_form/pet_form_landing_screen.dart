import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/enums/edit_pet_screen_action.dart';
import 'package:flutter_chat_mock_app/enums/image_upload_purpose.dart';
import 'package:flutter_chat_mock_app/providers/loading_overlay_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_form_providers.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_form/pet_form_screen.dart';
import 'package:flutter_chat_mock_app/services/image_picker_service.dart';
import 'package:flutter_chat_mock_app/services/image_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter/services.dart';

class PetFormLandingScreen extends ConsumerStatefulWidget {
  const PetFormLandingScreen({super.key});

  static final _hp = SC.sw(24.0);
  static final _vpM = SC.sh(16.0);

  @override
  ConsumerState<PetFormLandingScreen> createState() =>
      _PetFormLandingScreenState();
}

class _PetFormLandingScreenState extends ConsumerState<PetFormLandingScreen> {
  Color get _screenColor => AC.greenBackground1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  Future<void> _onTapContinueWithAI(BuildContext context) async {
    await _pickImage();
  }

  // Future<XFile?> _pickImage(BuildContext context) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   return pickedFile;
  // }

  // void _onTapContinueManually(BuildContext context) {}

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    final overlay = ref.read(loadingOverlayProvider.notifier);

    final picked = await ImagePickerService.pickImages(
      context,
      allowMultiple: false,
      allowCamera: true,
      allowGallery: true,
    );

    if (!mounted) return;

    final path = picked?.paths.firstOrNull;
    if (path == null) {
      return;
    }

    overlay.show(l10n.petFormChooseProcessing);

    final result = await ImageService.uploadImageFromPath(
      imagePath: path,
      purpose: ImageUploadPurpose.petAvatar,
    );

    if (result.isSuccess && result.fileUrl != null) {
      ref.read(petFormDataProvider.notifier).setAvatarUrl(result.fileUrl!);
      overlay.hide();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PetFormScreen(
            action: EditPetScreenAction.create,
            pet: null,
            isManual: false,
          ),
        ),
      );
      return;
    }

    overlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenColor = _screenColor;
    return AssistantVisibilityScope.hide(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: CustomScaffold(
          backgroundColor: screenColor,
          body: SafeAreaTopOnly(
            child: Column(
              children: [
                //--Header
                CustomAppHeader(
                  color: screenColor,
                  leftActionSeperatorColor: screenColor,
                  title: l10n.petFormLandingTitle,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      PetFormLandingScreen._hp,
                      SC.sh(32),
                      PetFormLandingScreen._hp,
                      MQ.bottomPadding(context),
                    ),
                    child: Column(
                      children: [
                        const _TitleText(),
                        SizedBox(height: PetFormLandingScreen._vpM),
                        const _GreetingsText(),
                        SizedBox(height: PetFormLandingScreen._vpM),
                        const _BodyPicture(),
                        const Spacer(),
                        // ActionButton(
                        //   leadingIcon: Image.asset('assets/icons/sparkles.png'),
                        //   text: 'Hãy để AI giúp bạn tạo hồ sơ',
                        //   subText: 'Nhanh hơn và dễ hơn',
                        //   onTap: () => _onTapContinueWithAI(context),
                        // ),
                        ActionButton(
                          leadingIcon: Image.asset(
                            'assets/icons/ab-camera.png',
                          ),
                          text: l10n.petFormLandingStart,
                          onTap: () => _onTapContinueWithAI(context),
                        ),
                        SizedBox(height: SC.sh(16)),
                        // SizedBox(height: PetFormLandingScreen._vpM),
                        // _ManualCreatePetButtonGroup(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Text(
        l10n.petFormLandingHero,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w700,
          fontSize: SC.sf(24),
          height: 26 / 24,
          letterSpacing: 0.2,
          color: AC.greenStrong1,
        ),
      ),
    );
  }
}

class _GreetingsText extends StatelessWidget {
  const _GreetingsText();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Text(
        l10n.petFormLandingTips,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
          fontSize: SC.sf(14),
          height: 24 / 14,
          letterSpacing: 0,
          color: AC.neutralPrimaryText,
        ),
      ),
    );
  }
}

class _BodyPicture extends StatelessWidget {
  const _BodyPicture();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/pet-form-landing-cat.jpg',
        width: SC.sw(288),
        height: SC.sh(343),
      ),
    );
  }
}

// class _ManualCreatePetButtonGroup extends StatelessWidget {
//   const _ManualCreatePetButtonGroup();
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           'Bạn muốn tự tay điền chi tiết? ',
//           style: TextStyle(
//             fontFamily: 'Quicksand',
//             fontStyle: FontStyle.normal,
//             fontWeight: FontWeight.w500,
//             fontSize: SC.sf(12),
//             height: 15 / 12,
//             color: AC.neutralLandingSubtext,
//           ),
//         ),
//         TapEffect(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => PetFormScreen(
//                   action: EditPetScreenAction.create,
//                   pet: null,
//                   isManual: true,
//                 ),
//               ),
//             );
//           },
//           child: Text(
//             'Tạo hồ sơ bằng tay',
//             style: TextStyle(
//               fontFamily: 'Quicksand',
//               fontStyle: FontStyle.normal,
//               fontWeight: FontWeight.w700,
//               fontSize: SC.sf(12),
//               height: 15 / 12,
//               color: AC.neutralLandingSubtext,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
