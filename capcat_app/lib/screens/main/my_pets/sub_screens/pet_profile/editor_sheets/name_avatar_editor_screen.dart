import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/enums/image_upload_purpose.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/services/image_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/input/input_field.dart';
import 'package:capcat_doca/widgets/keyboard_dismisser.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/widgets/shared/avatar_widget.dart';

class NameAvatarEditorScreen extends StatefulWidget {
  const NameAvatarEditorScreen({
    super.key,
    required this.initialName,
    required this.initialAvatarUrl,
    required this.onConfirm,
  });

  final String? initialName;
  final String? initialAvatarUrl;
  final Future<void> Function(String name, String? avatarUrl) onConfirm;

  @override
  State<NameAvatarEditorScreen> createState() => _NameAvatarEditorScreenState();
}

class _NameAvatarEditorScreenState extends State<NameAvatarEditorScreen> {
  late final TextEditingController _nameCtrl;
  String? _avatarUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _avatarUrl = widget.initialAvatarUrl;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isUploading = true);
    final picked = await ImagePickerService.pickImages(
      context,
      allowMultiple: false,
      allowCamera: true,
      allowGallery: true,
    );
    final path = picked?.paths.firstOrNull;
    if (path == null) {
      setState(() => _isUploading = false);
      return;
    }

    final upload = await ImageService.uploadImageFromPath(
      imagePath: path,
      purpose: ImageUploadPurpose.petAvatar,
    );
    setState(() => _isUploading = false);

    if (!upload.isSuccess || upload.fileUrl == null) {
      if (mounted) {
        TO.show(context, upload.error ?? l10n.editPetGenericError);
      }
      return;
    }

    setState(() => _avatarUrl = upload.fileUrl);
  }

  Future<void> _handleConfirm() async {
    if (_isUploading) return;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      TO.show(context, 'Vui lòng nhập tên thú cưng');
      return;
    }
    await widget.onConfirm(name, _avatarUrl);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.white,
          body: SafeAreaTopOnly(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SC.sw(16),
                    right: SC.sw(16),
                    bottom: SC.sh(88), // space for button
                  ),
                  child: Column(
                    children: [
                      CustomAppHeader(
                        title: 'Ảnh đại diện & tên',
                        color: AC.white,
                        leftActionIcon: 'assets/icons/main-x.png',
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: SC.sh(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: AvatarWidget(
                                  imageUrl: _avatarUrl,
                                  isPet: true,
                                  size: SC.sh(100),
                                  editIconPath: 'assets/icons/take-avatar.png',
                                  onEditTap: _isUploading ? null : _pickAvatar,
                                ),
                              ),
                              SizedBox(height: SC.sh(16)),
                              Text(
                                l10n.editPetNameLabel,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  fontSize: SC.sf(14),
                                  color: AC.blackText4,
                                ),
                              ),
                              SizedBox(height: SC.sh(8)),
                              InputField(
                                controller: _nameCtrl,
                                hintText: l10n.editPetNameHint,
                              ),
                              SizedBox(height: SC.sh(24)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: SC.sw(16),
                  right: SC.sw(16),
                  bottom: MQ.bottomPadding(context) + SC.sh(16),
                  child: ActionButton(text: 'Xác nhận', onTap: _handleConfirm),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
