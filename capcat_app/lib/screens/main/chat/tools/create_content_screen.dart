import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/models/chat_pet.dart';
import 'package:capcat_doca/models/pet_detail.dart';
import 'package:capcat_doca/providers/chat_pet_provider.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/providers/loading_overlay_provider.dart';
import 'package:capcat_doca/gen/assets.gen.dart';
import 'package:capcat_doca/services/abilities_remote_service.dart';
import 'package:capcat_doca/services/image_service.dart';
import 'package:capcat_doca/services/image_picker_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/image_utils.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/enums/image_upload_purpose.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/image/rectangle_cached_network_image.dart';
import 'package:capcat_doca/widgets/keyboard_dismisser.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/widgets/loading/custom_lottie_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class CreateContentScreen extends ConsumerStatefulWidget {
  const CreateContentScreen({
    super.key,
    required this.conversationId,
    required this.conversationTitle,
    this.conversationAvatarUrl,
  });

  final String conversationId;
  final String conversationTitle;
  final String? conversationAvatarUrl;

  @override
  ConsumerState<CreateContentScreen> createState() =>
      _CreateContentScreenState();
}

class _CreateContentScreenState extends ConsumerState<CreateContentScreen> {
  final TextEditingController _feelingController = TextEditingController();
  List<_WritingStyle> _buildStyles(AppLocalizations l10n) => [
    _WritingStyle(l10n.createContentStyleHumor),
    _WritingStyle(l10n.createContentStylePoem),
    _WritingStyle(l10n.createContentStyleQuestion),
    _WritingStyle(l10n.createContentStyleQuote),
    _WritingStyle(l10n.createContentStyleNarrative),
    _WritingStyle(l10n.chatNewToolComingSoon, disabled: true),
    _WritingStyle(l10n.createContentStyleStorytelling, disabled: true),
    _WritingStyle(l10n.createContentStyleEducation, disabled: true),
  ];
  int _selectedStyleIndex = 0;
  double _lengthValue = 0; // 0: ngắn, 1: trung bình, 2: dài
  String? _selectedImagePath;
  String? _photoLocationLabel;
  String? _photoDateLabel;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  bool _isSubmitting = false;
  late final PageController _pageController;
  String? _generatedOutput;
  late final LoadingOverlayController _overlay;
  ChatPet? get _chatPet {
    final pets = ref.read(chatPetListProvider).value;
    if (pets == null) return null;
    try {
      return pets.firstWhere(
        (p) => p.conversationId?.toString() == widget.conversationId,
      );
    } catch (_) {
      return null;
    }
  }

  PetDetail? get _petDetail {
    final pets = ref.read(listPetDetailProvider).value;
    if (pets == null) return null;
    final chatPet = _chatPet;
    if (chatPet == null) return null;
    try {
      return pets.firstWhere((p) => p.id == chatPet.id);
    } catch (_) {
      return null;
    }
  }

  String _resolvePetName() {
    final pet = _chatPet;
    return pet?.name ?? widget.conversationTitle;
  }

  String? _resolveAvatarUrl() {
    final pet = _chatPet;
    return pet?.avatarUrl ?? widget.conversationAvatarUrl;
  }

  String? _resolvePersonaName() {
    final personaName = _petDetail?.persona?.name;
    if (personaName != null && personaName.trim().isNotEmpty) {
      return personaName;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _overlay = ref.read(loadingOverlayProvider.notifier);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _overlay.hide();
    _pageController.dispose();
    _feelingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final styles = _buildStyles(l10n);
    final screenColor = AC.white;
    final hp = SC.sw(24);
    final vpS = SC.sh(12);
    return AssistantVisibilityScope.hide(
      child: KeyboardDismisser(
        child: CustomScaffold(
          backgroundColor: screenColor,
          resizeToAvoidBottomInset: false,
          body: SafeAreaTopOnly(
            child: Column(
              children: [
                CustomAppHeader(
                  title: l10n.createContentTitle,
                  color: screenColor,
                  leftActionIcon: 'assets/icons/main-x.png',
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (_) {},
                      children: [
                        _CreateContentFormSheet(
                          hp: hp,
                          vpS: vpS,
                          name: _resolvePetName(),
                          personaName: _resolvePersonaName(),
                          avatarUrl: _resolveAvatarUrl(),
                          quote: l10n.createContentIntroQuote,
                          imageUrl: _uploadedImageUrl,
                          locationLabel: _photoLocationLabel,
                          dateLabel: _photoDateLabel,
                          isUploading: _isUploadingImage,
                          onPickImage: _handlePickImage,
                          onRemoveImage: _handleRemoveImage,
                          feelingController: _feelingController,
                          styles: styles,
                          selectedStyleIndex: _selectedStyleIndex,
                          onStyleChanged: (i) {
                            if (!styles[i].disabled) {
                              setState(() => _selectedStyleIndex = i);
                            }
                          },
                          lengthValue: _lengthValue,
                          onLengthChanged: (v) =>
                              setState(() => _lengthValue = v),
                          isSubmitting: _isSubmitting,
                          onSubmit: _handleSubmit,
                        ),
                        _CreateContentResultSheet(
                          hp: hp,
                          vpS: vpS,
                          bottomPadding: 0,
                          name: _resolvePetName(),
                          personaName: _resolvePersonaName(),
                          avatarUrl: _resolveAvatarUrl(),
                          imageUrl: _uploadedImageUrl,
                          localImagePath: _selectedImagePath,
                          output: _generatedOutput,
                          onExit: () => Navigator.of(context).pop(true),
                          shareLabel: l10n.createContentShare,
                          backLabel: l10n.createContentBackToChat,
                          emptyResultText: l10n.createContentResultEmpty,
                          tipMessage: l10n.createContentShareTip,
                          quote: l10n.createContentResultQuote,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MQ.bottomPadding(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    if (_isUploadingImage) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.createContentUploadingImage,
      );
      return;
    }
    final imageUrl = _uploadedImageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.createContentSelectImage,
      );
      return;
    }
    final mood = _feelingController.text.trim();
    if (mood.isEmpty) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.createContentEnterMood,
      );
      return;
    }
    final style = _buildStyles(
      AppLocalizations.of(context)!,
    )[_selectedStyleIndex].label;
    final length = _lengthValue < 0.5 ? 'short' : 'medium';

    _overlay.show(AppLocalizations.of(context)!.createContentAnalyzing);
    setState(() => _isSubmitting = true);
    try {
      final res = await AbilitiesRemoteService.sendContentGenerate(
        conversationId: widget.conversationId,
        imageUrl: imageUrl,
        mood: mood,
        style: style,
        length: length,
      );
      final output = _extractGeneratedOutput(res.data);
      debugPrint('📝 Content generate response: ${res.data}');
      if (output != null) {
        debugPrint('📝 Generated output: $output');
      }
      if (!res.isSuccess) {
        if (!mounted) return;
        ToastOverlay.show(
          context,
          res.message ??
              AppLocalizations.of(context)!.createContentSubmitFailed,
        );
      } else {
        if (mounted) {
          setState(() => _generatedOutput = output);
          // ToastOverlay.show(context, 'Đã gửi yêu cầu tạo caption');
          unawaited(
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _overlay.hide();
      }
    }
  }

  String? _extractGeneratedOutput(dynamic data) {
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is Map && inner['output'] is String) {
        return inner['output'] as String;
      }
      if (data['output'] is String) {
        return data['output'] as String;
      }
    }
    return null;
  }

  Future<void> _handlePickImage() async {
    final picked = await ImagePickerService.pickImages(
      context,
      allowMultiple: false,
      allowCamera: true,
      allowGallery: true,
    );
    final path = picked?.paths.firstOrNull;
    if (!mounted || path == null) return;
    setState(() {
      _isUploadingImage = true;
      _selectedImagePath = null;
      _uploadedImageUrl = null;
    });
    final info = await ImageUtils.readPhotoInfo(path);
    debugPrint(
      '📸 Photo info: path=$path, lat=${info?.lat}, lon=${info?.lon}, date=${info?.dateTaken}',
    );
    String? location;
    if (info?.lat != null && info?.lon != null) {
      location =
          'Lat ${info!.lat!.toStringAsFixed(4)}, Lon ${info.lon!.toStringAsFixed(4)}';
    }
    final date = info?.dateTaken;
    final dateLabel = date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : null;

    setState(() {
      _photoLocationLabel = location;
      _photoDateLabel = dateLabel;
    });

    unawaited(_uploadSelectedImage(path));
  }

  void _handleRemoveImage() {
    setState(() {
      _selectedImagePath = null;
      _photoLocationLabel = null;
      _photoDateLabel = null;
      _uploadedImageUrl = null;
      _isUploadingImage = false;
    });
  }

  Future<void> _uploadSelectedImage(String path) async {
    final l10n = AppLocalizations.of(context)!;
    final mime = ImageUtils.getMimeType(path);
    if (mime == null) {
      debugPrint('⚠️ ${l10n.createContentUnknownMime}');
      return;
    }
    try {
      final uploadUrlRes = await ImageService.getUploadUrl(
        ImageUploadPurpose.other,
        mime,
      );
      if (!uploadUrlRes.isSuccess ||
          uploadUrlRes.data == null ||
          uploadUrlRes.data is! Map<String, dynamic>) {
        if (!mounted) return;
        ToastOverlay.show(
          context,
          uploadUrlRes.message ?? l10n.createContentUploadUrlError,
        );
        return;
      }

      final data = uploadUrlRes.data as Map<String, dynamic>;
      final uploadUrl = data['upload_url'] as String?;
      final fileUrl = data['file_url'] as String?;
      if (uploadUrl == null || fileUrl == null) {
        if (!mounted) return;
        ToastOverlay.show(context, l10n.createContentUploadMissingUrl);
        return;
      }

      final uploadRes = await ImageService.uploadImage(
        imagePath: path,
        uploadUrl: uploadUrl,
      );
      if (!uploadRes.isSuccess) {
        if (!mounted) return;
        ToastOverlay.show(
          context,
          uploadRes.message ?? l10n.createContentUploadFailed,
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _uploadedImageUrl = fileUrl;
        _selectedImagePath = path;
      });
      debugPrint('✅ Uploaded image: $fileUrl');
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }
}

class _CreateContentFormSheet extends StatelessWidget {
  const _CreateContentFormSheet({
    required this.hp,
    required this.vpS,
    required this.name,
    required this.personaName,
    required this.avatarUrl,
    required this.quote,
    required this.imageUrl,
    required this.locationLabel,
    required this.dateLabel,
    required this.isUploading,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.feelingController,
    required this.styles,
    required this.selectedStyleIndex,
    required this.onStyleChanged,
    required this.lengthValue,
    required this.onLengthChanged,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final double hp;
  final double vpS;
  final String name;
  final String? personaName;
  final String? avatarUrl;
  final String quote;
  final String? imageUrl;
  final String? locationLabel;
  final String? dateLabel;
  final bool isUploading;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final TextEditingController feelingController;
  final List<_WritingStyle> styles;
  final int selectedStyleIndex;
  final ValueChanged<int> onStyleChanged;
  final double lengthValue;
  final ValueChanged<double> onLengthChanged;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hp, 0, hp, 0),
      child: Column(
        children: [
          SizedBox(height: vpS),
          _IntroCard(
            name: name,
            personaName: personaName,
            avatarUrl: avatarUrl,
            quote: quote,
          ),
          SizedBox(height: SC.sh(16)),
          _UploadImageCard(
            imageUrl: imageUrl,
            locationLabel: locationLabel,
            dateLabel: dateLabel,
            onPickImage: onPickImage,
            onRemoveImage: onRemoveImage,
            isUploading: isUploading,
            processingText: l10n.createContentProcessingImage,
            chooseLabel: l10n.createContentChooseImage,
          ),
          SizedBox(height: SC.sh(16)),
          _FeelingInput(
            controller: feelingController,
            title: l10n.createContentFeelingTitle,
            hint: l10n.createContentFeelingHint,
          ),
          SizedBox(height: SC.sh(16)),
          _StyleSelector(
            styles: styles,
            selectedIndex: selectedStyleIndex,
            onChanged: onStyleChanged,
            title: l10n.createContentStyleTitle,
            comingSoonLabel: l10n.chatNewToolComingSoon,
          ),
          SizedBox(height: SC.sh(16)),
          _LengthSelector(
            value: lengthValue,
            onChanged: onLengthChanged,
            title: l10n.createContentLengthTitle,
            shortLabel: l10n.createContentLengthShort,
            mediumLabel: l10n.createContentLengthMedium,
            shortHint: l10n.createContentLengthShortHint,
            mediumHint: l10n.createContentLengthMediumHint,
          ),
          SizedBox(height: SC.sh(16)),
          _TipCard(message: l10n.createContentPrepTip),
          SizedBox(height: SC.sh(16)),
          ActionButton(
            text: l10n.commonContinue,
            onTap: isSubmitting ? () {} : onSubmit,
          ),
        ],
      ),
    );
  }
}

class _CreateContentResultSheet extends StatelessWidget {
  const _CreateContentResultSheet({
    required this.hp,
    required this.vpS,
    required this.bottomPadding,
    required this.name,
    required this.personaName,
    required this.avatarUrl,
    required this.imageUrl,
    required this.localImagePath,
    required this.output,
    required this.onExit,
    required this.shareLabel,
    required this.backLabel,
    required this.emptyResultText,
    required this.tipMessage,
    required this.quote,
  });

  final double hp;
  final double vpS;
  final double bottomPadding;
  final String name;
  final String? personaName;
  final String? avatarUrl;
  final String? imageUrl;
  final String? localImagePath;
  final String? output;
  final VoidCallback onExit;
  final String shareLabel;
  final String backLabel;
  final String emptyResultText;
  final String tipMessage;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final displayText = output?.trim().isNotEmpty == true
        ? output!
        : emptyResultText;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hp, 0, hp, bottomPadding),
      child: Column(
        children: [
          SizedBox(height: vpS),
          _IntroCard(
            name: name,
            personaName: personaName,
            avatarUrl: avatarUrl,
            quote: quote,
          ),
          SizedBox(height: SC.sh(16)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(SC.smin(16)),
            decoration: BoxDecoration(
              color: AC.greyTab1,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AC.greyBorder2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _ResultImageCard(
                    imageUrl: imageUrl,
                    memoryLabel: AppLocalizations.of(
                      context,
                    )!.createContentMemoryLabel,
                  ),
                ),

                SizedBox(height: SC.sh(16)),
                // Text(
                //   'Caption cho Sen',
                //   style: TextStyle(
                //     fontFamily: 'Quicksand',
                //     fontWeight: FontWeight.w700,
                //     fontSize: SC.sf(14),
                //     color: AC.blackText4,
                //   ),
                // ),
                // SizedBox(height: SC.sh(8)),
                Text(
                  displayText,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(14),
                    color: AC.greyText4,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SC.sh(12)),
          _TipCard(message: tipMessage),
          SizedBox(height: SC.sh(16)),
          ActionButton(
            leadingIcon: Icon(
              Icons.ios_share_outlined,
              color: AC.white,
              size: SC.sh(16),
            ),
            text: shareLabel,
            onTap: () {
              final files = <XFile>[];
              if (localImagePath != null && localImagePath!.isNotEmpty) {
                final file = File(localImagePath!);
                if (file.existsSync()) {
                  files.add(XFile(localImagePath!));
                }
              }
              if (files.isNotEmpty) {
                Share.shareXFiles(files, text: displayText).then((_) {
                  if (!context.mounted) return;
                  // ToastOverlay.show(context, 'Chia sẻ thành công');
                });
              } else {
                Share.share(displayText).then((_) {
                  if (!context.mounted) return;
                  // ToastOverlay.show(context, 'Chia sẻ thành công');
                });
              }
            },
          ),
          SizedBox(height: SC.sh(12)),
          ActionButton(
            text: backLabel,
            color: AC.white,
            borderColor: AC.greenStrong1,
            textColor: AC.greenStrong1,
            onTap: onExit,
          ),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  const _ResultItem({
    required this.title,
    required this.body,
    this.selected = false,
  });

  final String title;
  final String body;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AC.greenStrong1 : AC.greyText3;
    return Container(
      padding: EdgeInsets.all(SC.smin(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.greyBorder1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: color,
            size: SC.smin(22),
          ),
          SizedBox(width: SC.sw(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(14),
                    color: AC.blackText6,
                  ),
                ),
                SizedBox(height: SC.sh(6)),
                Text(
                  body,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(14),
                    color: AC.greyText4,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultImageCard extends StatelessWidget {
  const _ResultImageCard({required this.imageUrl, required this.memoryLabel});

  final String? imageUrl;
  final String memoryLabel;

  @override
  Widget build(BuildContext context) {
    final double frameWidth = SC.sw(275);
    final double frameHeight = SC.sh(306);
    final double imageSize = SC.smin(259);

    return Container(
      width: frameWidth,
      // height: frameHeight,
      padding: EdgeInsets.fromLTRB(SC.smin(8), SC.smin(8), SC.smin(8), 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AC.yellowToolPanel),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          RectangleCachedNetworkImage(
            imageUrl: imageUrl,
            width: imageSize,
            height: imageSize,
            radius: 8,
            fit: BoxFit.cover,
            subject: ImageSubject.pet,
          ),
          SizedBox(height: SC.sh(4)),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              memoryLabel,
              style: TextStyle(
                fontFamily: 'Motterdam',
                fontWeight: FontWeight.w400,
                fontSize: SC.sf(24),
                color: AC.blackText6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.name,
    required this.avatarUrl,
    required this.personaName,
    required this.quote,
  });

  final String name;
  final String? avatarUrl;
  final String? personaName;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(13)),
      decoration: BoxDecoration(
        color: AC.greyTab1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.greyBorder2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleCachedNetworkImage(
                imageUrl: avatarUrl,
                size: SC.smin(40),
                subject: ImageSubject.pet,
              ),
              SizedBox(width: SC.sw(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: SC.sf(14),
                        color: AC.blackText6,
                      ),
                    ),
                    Row(
                      children: [
                        personaName != null && personaName!.trim().isNotEmpty
                            ? Text(
                                personaName!,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w700,
                                  fontSize: SC.sf(12),
                                  color: AC.greyText4,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.format_quote_rounded,
                color: AC.greyCheckbox,
                size: SC.smin(24),
              ),
            ],
          ),
          SizedBox(height: SC.sh(12)),
          Text(
            quote,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: SC.sf(12),
              color: AC.neutralPrimaryText,
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadImageCard extends StatelessWidget {
  const _UploadImageCard({
    required this.imageUrl,
    required this.locationLabel,
    required this.dateLabel,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.isUploading,
    required this.processingText,
    required this.chooseLabel,
  });

  final String? imageUrl;
  final String? locationLabel;
  final String? dateLabel;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final bool isUploading;
  final String processingText;
  final String chooseLabel;

  @override
  Widget build(BuildContext context) {
    final double chooseCardHeight = SC.sh(56);

    if (isUploading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(SC.smin(12)),
        decoration: BoxDecoration(
          color: AC.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AC.greyTab1),
        ),
        child: SizedBox(
          height: SC.smin(120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomLottieIndicator(height: SC.smin(64), color: AC.greyText1),
              SizedBox(height: SC.sh(8)),
              Text(
                processingText,
                style: TextStyle(fontSize: SC.sf(12), color: AC.greyText1),
              ),
            ],
          ),
        ),
      );
    }

    if (imageUrl == null || imageUrl!.isEmpty) {
      return TapEffect(
        // behavior: HitTestBehavior.opaque,
        onTap: onPickImage,
        child: Container(
          width: double.infinity,
          height: chooseCardHeight,
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(16),
            vertical: SC.sh(16),
          ),
          decoration: BoxDecoration(
            color: AC.greyBox1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AC.greyBorder1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/pet-tool-content-chon-anh.png',
                width: SC.smin(24),
              ),
              SizedBox(width: SC.sw(8)),
              Text(
                chooseLabel,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(14),
                  color: AC.blackPure,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final hasLocation =
        locationLabel != null && locationLabel!.trim().isNotEmpty;
    final hasDate = dateLabel != null && dateLabel!.trim().isNotEmpty;

    Widget imageStack = Stack(
      children: [
        RectangleCachedNetworkImage(
          imageUrl: imageUrl,
          width: SC.smin(120),
          height: SC.smin(120),
          radius: 8,
          subject: ImageSubject.pet,
        ),
        Positioned(
          top: SC.smin(4),
          right: SC.smin(4),
          child: GestureDetector(
            onTap: onRemoveImage,
            child: Image.asset(
              'assets/icons/remove-image.png',
              width: SC.smin(16),
            ),
          ),
        ),
      ],
    );

    if (!hasLocation && !hasDate) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(SC.smin(12)),
        decoration: BoxDecoration(
          color: AC.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AC.greyTab1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [imageStack],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SC.smin(12)),
      decoration: BoxDecoration(
        color: AC.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.greyTab1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageStack,
          SizedBox(width: SC.sw(12)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasLocation)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: SC.smin(16),
                        color: AC.greyText4,
                      ),
                      SizedBox(width: SC.sw(4)),
                      Text(
                        locationLabel!,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: SC.sf(12),
                          color: AC.greyText4,
                        ),
                      ),
                    ],
                  ),
                if (hasLocation) SizedBox(height: SC.sh(6)),
                if (hasDate)
                  Row(
                    children: [
                      Text(
                        dateLabel!,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: SC.sf(12),
                          color: AC.greyText4,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeelingInput extends StatelessWidget {
  const _FeelingInput({
    required this.controller,
    required this.title,
    required this.hint,
  });
  final TextEditingController controller;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.blackText4,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(16),
            vertical: SC.sh(12),
          ),
          decoration: BoxDecoration(
            color: AC.greyBox1,
            border: Border.all(color: AC.greyBorder1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                maxLines: 4,
                maxLength: 100,
                buildCounter:
                    (
                      _, {
                      required currentLength,
                      maxLength,
                      required isFocused,
                    }) => const SizedBox.shrink(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SC.sf(14),
                    color: AC.greyText3,
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: SC.sf(14),
                  color: AC.blackText4,
                ),
              ),
              SizedBox(height: SC.sh(8)),
              Align(
                alignment: Alignment.centerRight,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    final count = value.text.length;
                    return Text(
                      '$count/100',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                        fontSize: SC.sf(12),
                        color: AC.greyText3,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StyleSelector extends StatelessWidget {
  const _StyleSelector({
    required this.styles,
    required this.selectedIndex,
    required this.onChanged,
    required this.title,
    required this.comingSoonLabel,
  });

  final List<_WritingStyle> styles;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final String title;
  final String comingSoonLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.neutralToolTitle,
          ),
        ),
        SizedBox(height: SC.sh(12)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(SC.smin(16)),
          decoration: BoxDecoration(
            color: AC.greyBox1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AC.greyBorder1),
          ),
          child: Column(
            children: List.generate(styles.length, (index) {
              final style = styles[index];
              final selected = index == selectedIndex && !style.disabled;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == styles.length - 1 ? 0 : SC.sh(12),
                ),
                child: GestureDetector(
                  onTap: style.disabled ? null : () => onChanged(index),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: selected ? AC.greenStrong1 : AC.greyText3,
                        size: SC.smin(22),
                      ),
                      SizedBox(width: SC.sw(10)),
                      Expanded(
                        child: Text(
                          style.label,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: SC.sf(14),
                            color: style.disabled ? AC.greyText3 : AC.blackPure,
                          ),
                        ),
                      ),
                      if (style.disabled)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: SC.sw(8),
                            vertical: SC.sh(2),
                          ),
                          decoration: BoxDecoration(
                            color: AC.redValidationText,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            comingSoonLabel,
                            style: TextStyle(
                              fontSize: SC.sf(8),
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _LengthSelector extends StatelessWidget {
  const _LengthSelector({
    required this.value,
    required this.onChanged,
    required this.title,
    required this.shortLabel,
    required this.mediumLabel,
    required this.shortHint,
    required this.mediumHint,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String title;
  final String shortLabel;
  final String mediumLabel;
  final String shortHint;
  final String mediumHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.neutralToolTitle,
          ),
        ),
        SizedBox(height: SC.sh(12)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(16),
            vertical: SC.sh(12),
          ),
          decoration: BoxDecoration(
            color: AC.greyBox1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AC.greyBorder1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AC.greenStrong1,
                  inactiveTrackColor: AC.greenLight1,
                  thumbColor: AC.greenStrong1,
                ),
                child: Slider(
                  value: value,
                  min: 0,
                  max: 1,
                  divisions: 1,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(height: SC.sh(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    shortLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: AC.greenSelectedAccent,
                    ),
                  ),
                  Text(
                    mediumLabel,
                    style: TextStyle(fontSize: 12, color: AC.greyText3),
                  ),
                ],
              ),
              SizedBox(height: SC.sh(4)),
              Text(
                value < 0.5 ? shortHint : mediumHint,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(12),
                  color: AC.greyText3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(13)),
      decoration: BoxDecoration(
        color: AC.greenSelectedBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.greenInfoBorder),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w500,
          fontSize: SC.sf(12),
          color: AC.neutralPrimaryText,
          height: 1.5,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _WritingStyle {
  final String label;
  final bool disabled;
  const _WritingStyle(this.label, {this.disabled = false});
}
