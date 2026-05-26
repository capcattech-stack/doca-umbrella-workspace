import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/enums/image_upload_purpose.dart';
import 'package:flutter_chat_mock_app/services/image_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/image_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/keyboard_dismisser.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/models/moment.dart';
import 'package:flutter_chat_mock_app/models/moment_type.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/select_pets_sheet.dart';
import 'package:flutter_chat_mock_app/config/moment_ui_config.dart';
import 'package:flutter_chat_mock_app/services/moment_remote_service.dart';
import 'package:flutter_chat_mock_app/services/image_picker_service.dart';
import 'package:flutter_chat_mock_app/widgets/loading/custom_lottie_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/providers/list_pet_detail_provider.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';

class MomentFormScreen extends ConsumerStatefulWidget {
  const MomentFormScreen({
    super.key,
    this.existingMoment,
    this.showMomentTypePicker = false,
    this.momentType = MomentType.emotion,
  });

  final Moment? existingMoment;
  final bool showMomentTypePicker;
  final MomentType momentType;

  @override
  ConsumerState<MomentFormScreen> createState() => _MomentFormScreenState();
}

class _MomentFormScreenState extends ConsumerState<MomentFormScreen> {
  final List<String> _uploadedUrls = [];
  bool _isUploading = false;
  List<PetDetail> _selectedPets = [];
  final TextEditingController _captionController = TextEditingController();
  bool get _isEditing => widget.existingMoment != null;
  bool _hydratedExisting = false;
  late MomentType _selectedMomentType;

  @override
  void initState() {
    super.initState();
    _selectedMomentType = widget.momentType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hydratedExisting) {
      _hydrateExisting();
      _hydratedExisting = true;
    }
  }

  void _hydrateExisting() {
    final moment = widget.existingMoment;
    if (moment == null) return;
    _captionController.text = moment.caption;
    _uploadedUrls
      ..clear()
      ..addAll(moment.media.map((m) => m.url));
    final pets = ref.read(listPetDetailProvider).value;
    if (pets != null) {
      _selectedPets = pets.where((p) {
        return moment.pets.any((mp) => mp.id == p.id);
      }).toList();
    }
  }

  Future<void> _pickImages() async {
    if (_isUploading) return;
    final picked = await ImagePickerService.pickImages(context);
    if (picked == null || picked.paths.isEmpty) return;
    if (picked.replaceExisting) {
      setState(() {
        _uploadedUrls.clear();
      });
    }
    final paths = picked.paths;
    final mimeTypes = <String>[];
    for (final p in paths) {
      final mime = ImageUtils.getMimeType(p);
      if (mime == null) {
        _showSnack('Không xác định được định dạng của một ảnh');
        return;
      }
      mimeTypes.add(mime);
    }

    setState(() => _isUploading = true);
    try {
      final presigned = await ImageService.getUploadUrlsMultiple(
        ImageUploadPurpose.moment,
        mimeTypes,
      );
      if (!presigned.isSuccess || presigned.data == null) {
        _showSnack(presigned.message ?? 'Không lấy được upload URL');
        return;
      }
      final entries = presigned.data!;
      if (entries.length != paths.length) {
        _showSnack('Số lượng URL trả về không khớp với số ảnh');
        return;
      }

      final urls = <String>[];
      for (var i = 0; i < paths.length; i++) {
        final uploadUrl = entries[i]['upload_url'] as String?;
        final fileUrl = entries[i]['file_url'] as String?;
        if (uploadUrl == null || fileUrl == null) {
          _showSnack('Thiếu thông tin upload cho một ảnh');
          return;
        }
        final uploadResult = await ImageService.uploadImage(
          imagePath: paths[i],
          uploadUrl: uploadUrl,
        );
        if (!uploadResult.isSuccess) {
          _showSnack(uploadResult.message ?? 'Tải ảnh lên thất bại');
          return;
        }
        urls.add(fileUrl);
      }

      setState(() {
        _uploadedUrls
          ..clear()
          ..addAll(urls);
      });
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ToastOverlay.show(context, msg);
  }

  void _setSelectedEventType(MomentType type) {
    setState(() {
      _selectedMomentType = type;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _submitMoment() async {
    if (_isUploading) return;
    // if (_uploadedUrls.isEmpty) {
    //   _showSnack('Vui lòng chọn ít nhất một hình ảnh');
    //   return;
    // }
    final caption = _captionController.text.trim();
    final petIds = _selectedPets.map((e) => e.id).toList();
    final bodyPreview = {
      'caption': caption,
      'pet_ids': petIds,
      'media': _uploadedUrls.map((e) => {'url': e}).toList(),
    };
    debugPrint('[MomentForm] body: $bodyPreview');
    setState(() => _isUploading = true);
    try {
      final resp = _isEditing
          ? await MomentRemoteService.updateMoment(
              id: widget.existingMoment!.id,
              caption: caption,
              petIds: petIds,
              mediaUrls: _uploadedUrls,
            )
          : await MomentRemoteService.createMoment(
              caption: caption,
              petIds: petIds,
              mediaUrls: _uploadedUrls,
            );
      if (!mounted) return;
      if (resp.isSuccess) {
        _showSnack(
          _isEditing
              ? 'Cập nhật kỷ niệm thành công'
              : 'Đăng kỷ niệm thành công',
        );
        Navigator.of(context).pop(true);
      } else {
        _showSnack(
          resp.message ??
              (_isEditing
                  ? 'Cập nhật kỷ niệm thất bại'
                  : 'Đăng kỷ niệm thất bại'),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = _isEditing ? 'Chỉnh sửa kỷ niệm' : 'Kỷ niệm mới';
    final actionLabel = _isEditing ? 'Lưu thay đổi' : 'Đăng kỷ niệm';
    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.white,

          body: SafeAreaTopOnly(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomAppHeader(title: headerTitle, color: AppColors.white),

                  InputField(
                    hintText: 'Viết điều bạn muốn lưu lại...',
                    isLarge: true,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    controller: _captionController,
                  ),
                  const Divider(height: 1, thickness: 1, color: AC.greyBorder2),
                  if (_uploadedUrls.isNotEmpty || _isUploading) ...[
                    _MediaSection(
                      imageUrls: _uploadedUrls,
                      isUploading: _isUploading,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AC.greyBorder2,
                    ),
                  ],
                  if (MomentUiConfig.enableMomentType &&
                      widget.showMomentTypePicker) ...[
                    _PickerRow(
                      icon: Icons.event,
                      label: 'Loại kỷ niệm',
                      hintText: 'Chọn phân loại',
                      selectedValue: _SelectedEventDisplay(
                        momentType: _selectedMomentType,
                      ),
                      onTap: () =>
                          _showEventPicker(context, _setSelectedEventType),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AC.greyBorder2,
                    ),
                  ],
                  _PickerRow(
                    icon: Icons.image,
                    label: 'Hình ảnh',
                    hintText: 'Chọn ảnh',
                    selectedValue: _uploadedUrls.isEmpty
                        ? null
                        : Text(
                            'Đã chọn ${_uploadedUrls.length} ảnh',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: SC.sf(12),
                              color: AC.blackText6,
                            ),
                          ),
                    onTap: () async {
                      await _pickImages();
                    },
                  ),
                  const Divider(height: 1, thickness: 1, color: AC.greyBorder2),
                  _PickerRow(
                    icon: Icons.groups,
                    label: 'Tham gia cùng với',
                    hintText: 'Chọn thú cưng',
                    selectedValue: _selectedPets.isEmpty
                        ? null
                        : Text(
                            '${_selectedPets.length} bé cưng',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: SC.sf(12),
                              color: AC.blackText6,
                            ),
                          ),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final result =
                          await showModalBottomSheet<List<PetDetail>>(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (_) =>
                                SelectPetsSheet(initialSelected: _selectedPets),
                          ).whenComplete(() {
                            // Đảm bảo không trả focus lại InputField sau khi đóng sheet.
                            FocusScope.of(context).requestFocus(FocusNode());
                          });
                      if (result != null) {
                        setState(() => _selectedPets = result);
                      }
                    },
                  ),
                  const Divider(height: 1, thickness: 1, color: AC.greyBorder2),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      SC.sw(16),
                      SC.sh(12),
                      SC.sw(16),
                      SC.sh(16),
                    ),
                    child: ActionButton(
                      text: actionLabel,
                      onTap: _submitMoment,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({required this.imageUrls, required this.isUploading});

  final List<String> imageUrls;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    if (isUploading) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          SC.sw(16),
          SC.sh(16),
          SC.sw(16),
          SC.sh(16),
        ),
        child: SizedBox(
          height: SC.sh(152),
          child: Center(
            child: CustomLottieIndicator(
              height: SC.sh(64),
              color: AC.greyText1,
            ),
          ),
        ),
      );
    }

    if (imageUrls.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          SC.sw(16),
          SC.sh(16),
          SC.sw(16),
          SC.sh(16),
        ),
        child: SizedBox(
          height: SC.sh(152),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            separatorBuilder: (_, __) => SizedBox(width: SC.sw(10)),
            itemBuilder: (_, index) {
              final url = imageUrls[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: RectangleCachedNetworkImage(
                  imageUrl: url,
                  width: SC.sw(140),
                  height: SC.sh(140),
                  fit: BoxFit.cover,
                  radius: 8,
                  subject: ImageSubject.others,
                ),
              );
            },
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.label,
    required this.hintText,
    this.selectedValue,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String hintText;
  final Widget? selectedValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      effect: TapEffectType.both,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(16),
          vertical: SC.sh(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: SC.smin(24), color: AC.neutralIconDark),
            SizedBox(width: SC.sw(8)),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w400,
                fontSize: SC.sf(14),
                color: AC.blackText6,
              ),
            ),
            const Spacer(),
            selectedValue ??
                Text(
                  hintText,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400,
                    fontSize: SC.sf(12),
                    color: AC.blackText6,
                  ),
                ),
            SizedBox(width: SC.sw(4)),
            Icon(
              Icons.chevron_right,
              size: SC.smin(16),
              color: AC.neutralPrimaryText,
            ),
          ],
        ),
      ),
    );
  }
}

void _showEventPicker(
  BuildContext context,
  void Function(MomentType type) onSelected,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _MomentTypePickerSheet(onSelected: onSelected),
  );
}

class _MomentTypePickerSheet extends StatelessWidget {
  const _MomentTypePickerSheet({required this.onSelected});

  final void Function(MomentType type) onSelected;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.55;
    return Container(
      padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(39, 39, 39, 0.1),
            blurRadius: 8,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SC.sh(12)),
            Container(
              width: SC.sw(65),
              height: SC.sh(5),
              decoration: BoxDecoration(
                color: AC.neutralPrimaryText,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(height: SC.sh(16)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
              child: Column(
                children: [
                  const _InfoHighlight(),
                  SizedBox(height: SC.sh(12)),
                  _EventCard(
                    iconAsset: momentTypeMeta[MomentType.emotion]!.icon,
                    fallbackIcon:
                        momentTypeMeta[MomentType.emotion]!.fallbackIcon,
                    title: 'Cảm xúc',
                    subtitle: 'Chia sẻ những bức ảnh và cảm xúc của bạn.',
                    onTap: () => onSelected(MomentType.emotion),
                  ),
                  const _EventCardDivider(),
                  _EventCard(
                    iconAsset: momentTypeMeta[MomentType.note]!.icon,
                    fallbackIcon: momentTypeMeta[MomentType.note]!.fallbackIcon,
                    title: 'Ghi chú',
                    subtitle: 'Ghi nhận những sự kiện, hoạt động đáng chú ý.',
                    onTap: () => onSelected(MomentType.note),
                  ),
                ],
              ),
            ),
            SizedBox(height: SC.sh(16)),
          ],
        ),
      ),
    );
  }
}

class _InfoHighlight extends StatelessWidget {
  const _InfoHighlight();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AC.greenSelectedBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: SC.sw(56),
            height: SC.sh(74),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(30, 111, 66, 0.1),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/moment-type-hint.png',
                width: SC.smin(24),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SC.sw(12),
                vertical: SC.sh(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sổ tay sử dụng như thế nào?',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: SC.sf(12),
                      color: AC.neutralPrimaryText,
                    ),
                  ),
                  SizedBox(height: SC.sh(4)),
                  Text(
                    'Nơi ghi lại những khoảnh khắc, cũng như sự kiện của bạn và bé.',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(10),
                      color: AC.blackText6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.iconAsset,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String iconAsset;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SC.sh(4)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
              child: Image.asset(
                iconAsset,
                width: SC.smin(24),
                height: SC.smin(24),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(fallbackIcon, size: SC.smin(24)),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: SC.sf(12),
                      color: AC.blackText6,
                    ),
                  ),
                  SizedBox(height: SC.sh(2)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(12),
                      color: AC.greyText4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCardDivider extends StatelessWidget {
  const _EventCardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SC.sh(4)),
      child: const Divider(height: 1, thickness: 1, color: AC.greyBorder2),
    );
  }
}

class _SelectedEventDisplay extends StatelessWidget {
  const _SelectedEventDisplay({required this.momentType});

  final MomentType momentType;

  @override
  Widget build(BuildContext context) {
    final meta = momentTypeMeta[momentType]!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          meta.icon,
          width: SC.smin(16),
          height: SC.smin(16),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(meta.fallbackIcon, size: SC.smin(16), color: AC.blackText6),
        ),
        SizedBox(width: SC.sw(4)),
        Text(
          meta.title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
            fontSize: SC.sf(12),
            color: AC.blackText6,
          ),
        ),
      ],
    );
  }
}
