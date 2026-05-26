import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/models/chat_pet.dart';
import 'package:flutter_chat_mock_app/providers/chat_pet_provider.dart';
import 'package:flutter_chat_mock_app/providers/list_pet_detail_provider.dart';
import 'package:flutter_chat_mock_app/providers/loading_overlay_provider.dart';
import 'package:flutter_chat_mock_app/services/abilities_remote_service.dart';
import 'package:flutter_chat_mock_app/storage/user_detail_local_storage.dart';
import 'package:flutter_chat_mock_app/models/conversation.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/chat_thread_screen.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/input/date_input_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class NumerologyScreen extends ConsumerStatefulWidget {
  const NumerologyScreen({
    super.key,
    required this.conversationId,
    required this.conversationTitle,
    this.conversationAvatarUrl,
  });

  final String conversationId;
  final String conversationTitle;
  final String? conversationAvatarUrl;

  @override
  ConsumerState<NumerologyScreen> createState() => NumerologyScreenState();
}

class NumerologyScreenState extends ConsumerState<NumerologyScreen> {
  late final TextEditingController _nameController;
  late final LoadingOverlayController _overlay;
  DateTime? _birthDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _overlay = ref.read(loadingOverlayProvider.notifier);
    _prefillFromLocal();
  }

  @override
  void dispose() {
    _overlay.hide();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hp = SC.sw(24);
    final double vpS = SC.sh(8);
    final double vpM = SC.sh(16);
    final double vpL = SC.sh(24);
    final screenColor = AC.white;
    final l10n = AppLocalizations.of(context)!;

    return AssistantVisibilityScope.hide(
      child: PopScope(
        canPop: true,
        onPopInvoked: _handlePopInvoked,
        child: CustomScaffold(
          backgroundColor: screenColor,
          resizeToAvoidBottomInset: false,
          body: SafeAreaTopOnly(
            child: Column(
              children: [
                CustomAppHeader(
                  title: l10n.numerologyTitle,
                  color: screenColor,
                  leftActionIcon: 'assets/icons/main-x.png',
                ),
                Expanded(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            hp,
                            vpS,
                            hp,
                            MQ.bottomPadding(context),
                          ),
                          child: Column(
                            children: [
                              _NumerologyIntroCard(
                                name: _resolvePetName(),
                                avatarUrl: _resolveAvatarUrl(),
                                personaName: _resolvePersonaName(),
                              ),
                              SizedBox(height: SC.sh(24)),
                              _NumerologyForm(
                                nameController: _nameController,
                                onNameChanged: (value) {},
                                birthDate: _birthDate,
                                onBirthDateChanged: (date) {
                                  setState(() => _birthDate = date);
                                },
                              ),
                              SizedBox(height: SC.sh(24)),
                              const _NumerologyNotice(),
                              SizedBox(height: SC.sh(24)),
                              ActionButton(
                                text: _isSubmitting
                                    ? l10n.numerologySending
                                    : l10n.numerologySend,
                                onTap: _isSubmitting ? () {} : _handleSubmit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _prefillFromLocal() async {
    final user = await UserDetailLocalStorage().read();
    if (!mounted || user == null) return;

    final cachedName = user.fullName?.trim();
    final cachedDob = _parseDateOfBirth(user.dateOfBirth);

    if (cachedName?.isNotEmpty == true && _nameController.text != cachedName) {
      _nameController.text = cachedName!;
    }
    if (cachedDob != null) {
      setState(() => _birthDate = cachedDob);
    }
  }

  String _resolvePetName() {
    final chatPet = _findChatPet();
    return chatPet?.name ?? widget.conversationTitle;
  }

  String? _resolveAvatarUrl() {
    final chatPet = _findChatPet();
    return chatPet?.avatarUrl ?? widget.conversationAvatarUrl;
  }

  String? _resolvePersonaName() {
    final petDetail = _findPetDetailForChatPet();
    final personaName = petDetail?.persona?.name;
    if (personaName != null && personaName.trim().isNotEmpty) {
      return personaName;
    }
    return null;
  }

  ChatPet? _findChatPet() {
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

  PetDetail? _findPetDetailForChatPet() {
    final chatPet = _findChatPet();
    if (chatPet == null) return null;
    final pets = ref.read(listPetDetailProvider).value;
    if (pets == null) return null;
    try {
      return pets.firstWhere((p) => p.id == chatPet.id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    final name = _nameController.text.trim();
    final dob = _birthDate;

    if (name.isEmpty) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.numerologyNameEmpty,
      );
      return;
    }
    if (dob == null) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.numerologyDobEmpty,
      );
      return;
    }

    final birthdate = DateFormat('yyyy-MM-dd').format(dob);

    _overlay.show(AppLocalizations.of(context)!.numerologyAnalyzing);
    setState(() => _isSubmitting = true);
    try {
      final res = await AbilitiesRemoteService.sendNumerology(
        conversationId: widget.conversationId,
        fullName: name,
        birthdate: birthdate,
      );
      if (!mounted) return;

      if (res.isSuccess) {
        _handleNavigateToThread(res.data);
      } else {
        ToastOverlay.show(
          context,
          res.message ?? AppLocalizations.of(context)!.numerologySubmitFailed,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _overlay.hide();
      }
    }
  }

  void _handlePopInvoked(bool didPop) {
    _overlay.hide();
  }

  void _handleNavigateToThread(dynamic responseData) {
    final rootId = _extractThreadRootId(responseData);
    if (rootId == null) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.numerologySubmitFailed,
      );
      return;
    }
    final conversation = Conversation(
      id: widget.conversationId,
      title: widget.conversationTitle,
      avatarUrl: widget.conversationAvatarUrl,
    );
    Navigator.of(context)
        .pushReplacement(
          MaterialPageRoute(
            builder: (_) => ChatThreadScreen(
              conversation: conversation,
              rootMessageId: rootId,
            ),
          ),
        )
        .then((result) {
          if (result == true && mounted) {
            Navigator.of(context).pop(true);
          }
        });
  }

  String? _extractThreadRootId(dynamic data) {
    if (data is Map<String, dynamic>) {
      final list = data['data'];
      if (list is List) {
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final isRoot = item['is_thread_root'] == true;
            final id = item['id'];
            if (isRoot && id is String && id.isNotEmpty) {
              return id;
            }
          }
        }
      }
    }
    return null;
  }

  DateTime? _parseDateOfBirth(String? dob) {
    if (dob == null) return null;
    final value = dob.trim();
    if (value.isEmpty) return null;

    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;

    final slashParts = value.split('/');
    if (slashParts.length == 3) {
      final day = int.tryParse(slashParts[0]);
      final month = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final dashParts = value.split('-');
    if (dashParts.length == 3) {
      final day = int.tryParse(dashParts[0]);
      final month = int.tryParse(dashParts[1]);
      final year = int.tryParse(dashParts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    return null;
  }
}

class _NumerologyIntroCard extends StatelessWidget {
  const _NumerologyIntroCard({
    required this.name,
    required this.avatarUrl,
    required this.personaName,
  });

  final String name;
  final String? avatarUrl;
  final String? personaName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.numerologyIntroQuote,
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

class _NumerologyForm extends StatelessWidget {
  const _NumerologyForm({
    required this.nameController,
    required this.onNameChanged,
    required this.birthDate,
    required this.onBirthDateChanged,
  });

  final TextEditingController nameController;
  final ValueChanged<String> onNameChanged;
  final DateTime? birthDate;
  final ValueChanged<DateTime?> onBirthDateChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.numerologyNameLabel,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.neutralToolTitle,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        InputField(
          hintText: l10n.numerologyNameHint,
          controller: nameController,
          onChanged: onNameChanged,
        ),
        SizedBox(height: SC.sh(16)),
        Text(
          l10n.numerologyDobLabel,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.neutralToolTitle,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        DateInputField(
          hintText: l10n.numerologyDobHint,
          initialDate: birthDate,
          onChanged: onBirthDateChanged,
        ),
        SizedBox(height: SC.sh(16)),
        Row(
          children: [
            Text(
              l10n.numerologyResultLabel,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: SC.sf(14),
              ),
            ),
            SizedBox(width: SC.sw(8)),
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
                l10n.numerologyComingSoon,
                style: TextStyle(fontSize: SC.sf(8), color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: SC.sh(8)),
        Container(
          width: double.infinity,
          height: SC.sh(56),
          padding: EdgeInsets.symmetric(horizontal: SC.sw(20)),
          decoration: BoxDecoration(
            color: AC.greyBox1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AC.greyBorder1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.numerologyGetFullAnalysis,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400,
                    fontSize: SC.sf(12),
                    color: AC.neutralPrimaryText,
                  ),
                ),
              ),
              Icon(
                Icons.toggle_off_outlined,
                size: SC.smin(32),
                color: AC.neutralPrimaryText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NumerologyNotice extends StatelessWidget {
  const _NumerologyNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(13)),
      decoration: BoxDecoration(
        color: AC.greenSelectedBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.greenInfoBorder),
      ),
      child: Text(
        l10n.numerologyNotice,
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
