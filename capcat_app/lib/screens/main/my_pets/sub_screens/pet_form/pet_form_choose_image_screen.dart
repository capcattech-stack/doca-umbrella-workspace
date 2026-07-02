import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/enums/edit_pet_screen_action.dart';
import 'package:capcat_doca/enums/image_upload_purpose.dart';
import 'package:capcat_doca/providers/loading_overlay_provider.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/pet_form_screen.dart';
import 'package:capcat_doca/services/image_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PetFormChooseImageScreen extends ConsumerStatefulWidget {
  const PetFormChooseImageScreen({super.key});

  @override
  ConsumerState<PetFormChooseImageScreen> createState() =>
      _PetFormChooseImageScreenState();
}

class _PetFormChooseImageScreenState
    extends ConsumerState<PetFormChooseImageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pickImage();
    });
  }

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
      Navigator.of(context).pop();
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AssistantVisibilityScope.hide(
      child: CustomScaffold(
        backgroundColor: AC.greenBackground1,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AC.greenStrong1),
                SizedBox(height: SC.sh(16)),
                Text(
                  'Đang chờ chọn ảnh...',
                  style: TextStyle(
                    fontSize: SC.sf(14),
                    fontWeight: FontWeight.w600,
                    color: AC.blackText1,
                  ),
                ),
                // const SizedBox(height: 8),
                // Text(
                //   'Đang mở lựa chọn ảnh...',
                //   style: TextStyle(
                //     fontSize: SC.sf(12),
                //     fontWeight: FontWeight.w500,
                //     color: AC.greyLine1,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
