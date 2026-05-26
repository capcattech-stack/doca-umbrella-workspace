import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/models/user_detail.dart';
import 'package:flutter_chat_mock_app/providers/loading_overlay_provider.dart';
import 'package:flutter_chat_mock_app/providers/user_detail_provider.dart';
import 'package:flutter_chat_mock_app/services/user_detail_remote_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/auth_util.dart';
import 'package:flutter_chat_mock_app/utils/date_format_config.dart';
import 'package:flutter_chat_mock_app/services/image_picker_service.dart';
import 'package:flutter_chat_mock_app/utils/image_utils.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/input/date_input_field.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/input/select_text_field.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/shared/avatar_widget.dart';
import 'package:flutter_chat_mock_app/widgets/text/section_header_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class UserProfileInfoScreen extends ConsumerStatefulWidget {
  const UserProfileInfoScreen({super.key});

  @override
  ConsumerState<UserProfileInfoScreen> createState() =>
      ProfileInfoScreenState();
}

class ProfileInfoScreenState extends ConsumerState<UserProfileInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  late DateTime? _dateOfBirth;
  final TextEditingController _genderController = TextEditingController();
  late UserGender? _gender;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final initial = ref.read(userDetailProvider).value;
    if (initial != null) {
      _nameController.text = initial.fullName ?? '';
      _emailController.text = initial.email ?? '';
      _phoneController.text = initial.phoneNumber;
      _addressController.text = initial.address ?? '';
      _dateOfBirth = initial.dateOfBirth != null
          ? DateFormatConfig.isoToDateTime(initial.dateOfBirth!)
          : null;
      _dateOfBirthController.text = initial.dateOfBirth != null
          ? DateFormatConfig.isoToShortDisplay(initial.dateOfBirth!)
          : '';
      _gender = UserGenderExtension.fromValue(initial.gender);
      _genderController.text = _gender != null ? _gender!.label : '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _onAvatarPicked(String imagePath) async {
    final l10n = AppLocalizations.of(context)!;
    final mimeType = ImageUtils.getMimeType(imagePath);
    if (mimeType == null) return;
    final overlay = ref.read(loadingOverlayProvider.notifier);
    overlay.show(l10n.profileInfoUpdatingAvatar);

    try {
      final serviceResponse = await UserDetailRemoteService.updateUserAvatar(
        imagePath,
        mimeType,
      );
      if (!mounted) return;
      if (!serviceResponse.isSuccess) {
        TO.show(
          context,
          (serviceResponse.message?.trim().isNotEmpty == true)
              ? serviceResponse.message!
              : l10n.profileInfoGenericError,
        );
        return;
      }

      final currentUser = ref.read(userDetailProvider).value;
      if (currentUser != null) {
        final responseData = serviceResponse.data;
        final newAvatar =
            (responseData is Map &&
                responseData['avatarUrl'] != null &&
                responseData['avatarUrl'].toString().trim().isNotEmpty)
            ? responseData['avatarUrl'] as String
            : currentUser.avatarUrl;
        final updatedUser = currentUser.copyWith(avatarUrl: newAvatar);
        ref.read(userDetailProvider.notifier).setFromServer(updatedUser);
      }

      TO.show(context, l10n.profileInfoAvatarSuccess);
    } finally {
      overlay.hide();
    }
  }

  Future<void> _onSaveButtonTap() async {
    final l10n = AppLocalizations.of(context)!;
    //--Check isSaving to avoid spamming Save button
    if (_isSaving) return;

    final currentUserDetail = ref.read(userDetailProvider).value;
    if (currentUserDetail == null) {
      TO.show(context, l10n.profileInfoFetchError);
      return;
    }

    //--Check changed fields to avoid updating using old data
    final changedFields = _getChangedFields(
      currentUserDetail,
      nextFullName: _nameController.text,
      nextEmail: _emailController.text,
      nextAddress: _addressController.text,
      nextDateOfBirth: _dateOfBirth != null
          ? DateFormatConfig.dateOnlyToIsoLocal(_dateOfBirth!)
          : '',
      nextGender: _gender != null ? _gender!.value : '',
    );

    if (changedFields.isEmpty) {
      TO.show(context, l10n.profileInfoNoChanges);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final serviceResponse = await UserDetailRemoteService.updateProfile(
        fullName: changedFields['full_name'] as String?,
        email: changedFields['email'] as String?,
        address: changedFields['address'] as String?,
        dateOfBirth: changedFields['dob'] as String?,
        gender: changedFields['gender'] as String?,
      );
      if (!mounted) return;
      if (serviceResponse.isSuccess && serviceResponse.data != null) {
        ref
            .read(userDetailProvider.notifier)
            .setFromServer(serviceResponse.data as UserDetail);
        TO.show(context, l10n.profileInfoUpdateSuccess);
        return;
      }
      if (serviceResponse.message?.contains('Phiên đăng nhập đã hết hạn') ==
          true) {
        await AuthUtil.performLogout(context: context, ref: ref);
        return;
      }
      TO.show(context, l10n.profileInfoUpdateFailed);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Map<String, dynamic> _getChangedFields(
    UserDetail currentUserDetail, {
    required String nextFullName,
    required String nextEmail,
    required String nextAddress,
    required String nextDateOfBirth,
    required String nextGender,
  }) {
    final changedFields = <String, dynamic>{};

    // So sánh họ tên
    final currentName = (currentUserDetail.fullName ?? '').trim();
    final newName = nextFullName.trim();
    if (newName.isNotEmpty && newName != currentName) {
      changedFields['full_name'] = newName;
    }

    // So sánh email
    final currentEmail = (currentUserDetail.email ?? '').trim();
    final newEmail = nextEmail.trim();
    if (newEmail.isNotEmpty && newEmail != currentEmail) {
      changedFields['email'] = newEmail;
    }

    // So sánh địa chỉ
    final currentAddress = (currentUserDetail.address ?? '').trim();
    final newAddress = nextAddress.trim();
    if (newAddress.isNotEmpty && newAddress != currentAddress) {
      changedFields['address'] = newAddress;
    }

    // So sánh ngày sinh (giả định định dạng chuỗi 'yyyy-MM-dd' đồng nhất)
    final currentDob = (currentUserDetail.dateOfBirth ?? '').trim();
    final newDob = nextDateOfBirth.trim();
    if (newDob.isNotEmpty && newDob != currentDob) {
      changedFields['dob'] = newDob;
    }

    // So sánh giới tính (giả định lưu dưới dạng lowercase, ex: 'male', 'female')
    final currentGender = (currentUserDetail.gender ?? '').trim();
    final newGender = nextGender.trim();
    if (newGender.isNotEmpty && newGender != currentGender) {
      changedFields['gender'] = newGender;
    }

    return changedFields;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double hp = SC.sw(24);
    final double vpS = SC.sh(8);
    final double vpM = SC.sh(16);
    final double vpL = SC.sh(24);
    final screenColor = AC.white;

    final userAsync = ref.watch(userDetailProvider);

    // Đồng bộ controller mỗi khi data sẵn sàng/cập nhật
    // final current = userAsync.value;
    // if (current != null) {
    //   final newName = current.fullName ?? '';
    //   final newEmail = current.email ?? '';
    //   if (_nameController.text != newName) _nameController.text = newName;
    //   if (_emailController.text != newEmail) _emailController.text = newEmail;
    // }

    return AssistantVisibilityScope.hide(
      child: userAsync.when(
        loading: () => CustomScaffold(
          backgroundColor: screenColor,
          body: SafeAreaTopOnly(
            child: Center(
              child: const CircularProgressIndicator(color: AC.greenStrong1),
            ),
          ),
        ),
        error: (e, st) => CustomScaffold(
          backgroundColor: screenColor,
          body: SafeAreaTopOnly(
            child: Center(child: Text(l10n.profileLoadError)),
          ),
        ),
        data: (user) {
          if (user == null) {
            return CustomScaffold(
              backgroundColor: screenColor,
              body: const SafeAreaTopOnly(
                child: Center(
                  child: CircularProgressIndicator(color: AC.greenStrong1),
                ),
              ),
            );
          }

          return CustomScaffold(
            backgroundColor: screenColor,

            body: SafeAreaTopOnly(
              child: Column(
                children: [
                  CustomAppHeader(
                    title: l10n.profileInfoTitle,
                    color: screenColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MQ.bottomPadding(context),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          hp,
                          vpL,
                          hp,
                          // SC.physicPaddingBottom + vpL,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: _SelectAvatarWidget(
                                onImagePicked: (imagePath) =>
                                    _onAvatarPicked(imagePath),
                                avatarUrl: user.avatarUrl,
                              ),
                            ),
                            SizedBox(height: vpM),

                            SectionHeaderText(
                              l10n.profileInfoNameLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: vpS),
                            InputField(
                              hintText: l10n.profileInfoNameHint,
                              controller: _nameController,
                            ),
                            SizedBox(height: vpM),

                            SectionHeaderText(
                              l10n.profileInfoEmailLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: vpS),
                            InputField(
                              hintText: l10n.profileInfoEmailHint,
                              controller: _emailController,
                            ),
                            SizedBox(height: vpM),

                            SectionHeaderText(
                              l10n.profileInfoPhoneLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: vpS),
                            InputField(
                              hintText: l10n.profileInfoPhoneHint,
                              isDisabled: true,
                              controller: _phoneController,
                            ),
                            SizedBox(height: vpM),

                            SectionHeaderText(
                              l10n.profileInfoAddressLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: vpS),
                            InputField(
                              hintText: l10n.profileInfoAddressHint,
                              controller: _addressController,
                            ),
                            SizedBox(height: vpM),

                            SectionHeaderText(l10n.profileInfoDobLabel),
                            SizedBox(height: vpS),
                            DateInputField(
                              hintText: l10n.profileInfoDobHint,
                              initialDate: _dateOfBirth,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              onChanged: (value) {
                                _dateOfBirth = value;
                              },
                            ),
                            SizedBox(height: vpM),

                            SectionHeaderText(
                              l10n.profileInfoGenderLabel,
                              isOptional: true,
                            ),
                            SizedBox(height: vpS),
                            SelectTextField(
                              fullOptions: [
                                UserGender.male.label,
                                UserGender.female.label,
                                UserGender.other.label,
                              ],
                              isMiniVersion: true,
                              quickOptions: [],
                              hintText: l10n.profileInfoGenderLabel,
                              sheetTitle: l10n.profileInfoGenderSheetTitle,
                              searchHint: l10n.profileInfoGenderSearchHint,
                              allSectionText: l10n.profileInfoGenderAll,
                              controller: _genderController,
                              icon: null,
                              onChanged: (selected) {
                                _gender = UserGenderExtension.fromLabel(
                                  selected,
                                );
                              },
                            ),
                            SizedBox(height: vpL),

                            /// ✅ ActionButton moved here
                            ActionButton(
                              text: _isSaving
                                  ? l10n.profileInfoSaving
                                  : l10n.profileInfoSave,
                              color: AppColors.greenStrong1,
                              onTap: () {
                                _isSaving ? null : _onSaveButtonTap();
                              },
                            ),
                            SizedBox(height: vpM),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SelectAvatarWidget extends StatelessWidget {
  const _SelectAvatarWidget({this.onImagePicked, this.avatarUrl});
  final void Function(String imageUrl)? onImagePicked;
  final String? avatarUrl;

  Future<void> _onEditTap(BuildContext context) async {
    final picked = await ImagePickerService.pickImages(
      context,
      allowMultiple: false,
      allowCamera: true,
      allowGallery: true,
    );
    final imagePath = picked?.paths.firstOrNull;
    if (!context.mounted) return;
    if (imagePath == null) {
      // TO.show(context, 'Đã có lỗi, vui lòng thử lại sau.');
      return;
    }
    onImagePicked?.call(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(
      imageUrl: avatarUrl,
      isPet: false,
      editIconPath: 'assets/icons/edit-avatar.png',
      size: SC.smin(80),
      onEditTap: () => _onEditTap(context),
    );
  }
}
