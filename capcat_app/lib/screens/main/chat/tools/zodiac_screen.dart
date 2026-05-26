import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/models/chat_pet.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
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
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/input/date_input_field.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';

class ZodiacScreen extends ConsumerStatefulWidget {
  const ZodiacScreen({
    super.key,
    required this.conversationId,
    required this.conversationTitle,
    this.conversationAvatarUrl,
  });

  final String conversationId;
  final String conversationTitle;
  final String? conversationAvatarUrl;

  @override
  ConsumerState<ZodiacScreen> createState() => _ConstellationScreenState();
}

class _ConstellationScreenState extends ConsumerState<ZodiacScreen> {
  late final LoadingOverlayController _overlay;
  DateTime? _birthDate;
  bool _topicPersonality = true;
  bool _topicNextWeek = true;
  bool _topicNextMonth = false;
  bool _isSubmitting = false;
  String _zodiacName = '';
  String _zodiacModality = '';
  String? _zodiacIconUrl;

  static const List<_ZodiacInfo> _zodiacData = [
    _ZodiacInfo(
      name: 'Bạch Dương',
      modality: 'Thủ lĩnh tiên phong',
      icon: 'https://unia.vn/wp-content/uploads/2023/09/Aries-2.png',
      from: 321,
      to: 419,
    ),
    _ZodiacInfo(
      name: 'Kim Ngưu',
      modality: 'Ổn định bền vững',
      icon: 'https://unia.vn/wp-content/uploads/2022/12/cung-kim-nguu.jpg',
      from: 420,
      to: 520,
    ),
    _ZodiacInfo(
      name: 'Song Tử',
      modality: 'Thích ứng linh hoạt',
      icon:
          'https://unia.vn/wp-content/uploads/2022/12/Gemini-Song-Tu-215-216.png',
      from: 521,
      to: 620,
    ),
    _ZodiacInfo(
      name: 'Cự Giải',
      modality: 'Thủ lĩnh tiên phong',
      icon:
          'https://unia.vn/wp-content/uploads/2022/12/truyen-thuyet-cung-cu-giai.jpg',
      from: 621,
      to: 722,
    ),
    _ZodiacInfo(
      name: 'Sư Tử',
      modality: 'Ổn định bền vững',
      icon: 'https://unia.vn/wp-content/uploads/2022/12/Leo-Su-tu-237-228.png',
      from: 723,
      to: 822,
    ),
    _ZodiacInfo(
      name: 'Xử Nữ',
      modality: 'Thích ứng linh hoạt',
      icon: 'https://unia.vn/wp-content/uploads/2022/12/Virgo-1-1.png',
      from: 823,
      to: 922,
    ),
    _ZodiacInfo(
      name: 'Thiên Bình',
      modality: 'Thủ lĩnh tiên phong',
      icon: 'https://unia.vn/wp-content/uploads/2021/05/cung-thien-binh.jpg',
      from: 923,
      to: 1022,
    ),
    _ZodiacInfo(
      name: 'Bọ Cạp',
      modality: 'Ổn định bền vững',
      icon:
          'https://vmstyle.vn/wp-content/uploads/2025/09/cau-chuyen-than-thoai-ve-thien-yet-va-chom-sao-scorpius-trong-nen-vu-tru.jpg',
      from: 1023,
      to: 1121,
    ),
    _ZodiacInfo(
      name: 'Nhân Mã',
      modality: 'Thích ứng linh hoạt',
      icon:
          'https://unia.vn/wp-content/uploads/2022/12/cung-hoang-dao-nhan-ma-1.jpg',
      from: 1122,
      to: 1221,
    ),
    _ZodiacInfo(
      name: 'Ma Kết',
      modality: 'Thủ lĩnh tiên phong',
      icon:
          'https://unia.vn/wp-content/uploads/2022/12/Capricorn-Ma-ket-2212-191.jpg',
      from: 1222,
      to: 119,
    ),
    _ZodiacInfo(
      name: 'Bảo Bình',
      modality: 'Ổn định bền vững',
      icon:
          'https://unia.vn/wp-content/uploads/2022/12/Aquarius-Bao-Binh-201-192-2.png',
      from: 120,
      to: 218,
    ),
    _ZodiacInfo(
      name: 'Song Ngư',
      modality: 'Thích ứng linh hoạt',
      icon:
          'https://unia.vn/wp-content/uploads/2022/12/Pisces-Song-ngu-202-20-3.jpg',
      from: 219,
      to: 320,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _overlay = ref.read(loadingOverlayProvider.notifier);
    _prefillFromLocal();
  }

  @override
  void dispose() {
    _overlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hp = SC.sw(24);
    final double vpS = SC.sh(8);
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
                  title: l10n.zodiacTitle,
                  color: screenColor,
                  leftActionIcon: 'assets/icons/main-x.png',
                ),
                Expanded(
                  child: Column(
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
                              _ConstellationIntroCard(
                                name: _resolvePetName(),
                                avatarUrl: _resolveAvatarUrl(),
                                personaName: _resolvePersonaName(),
                              ),
                              SizedBox(height: SC.sh(16)),
                              _birthDateCard(),
                              // SizedBox(height: SC.sh(8)),
                              _zodiacCard(),
                              SizedBox(height: SC.sh(16)),
                              _topicsCard(),
                              SizedBox(height: SC.sh(16)),
                              const _ConstellationNotice(),
                              SizedBox(height: SC.sh(16)),
                              ActionButton(
                                text: _isSubmitting
                                    ? l10n.zodiacSending
                                    : l10n.zodiacSend,
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

  Widget _birthDateCard() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.zodiacDobLabel,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.neutralToolTitle,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        DateInputField(
          hintText: l10n.zodiacDobHint,
          initialDate: _birthDate,
          onChanged: (date) {
            setState(() {
              _birthDate = date;
              _updateZodiacInfo(date);
            });
          },
        ),
      ],
    );
  }

  Widget _zodiacCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AC.greyTab1),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.03),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Container(
            width: SC.smin(80),
            height: SC.smin(80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            clipBehavior: Clip.hardEdge,
            child: _zodiacIconUrl != null && _zodiacIconUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: _zodiacIconUrl!,
                    fadeInDuration: const Duration(milliseconds: 150),
                    fadeInCurve: Curves.easeInOut,
                    imageBuilder: (context, provider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AC.amberMomentAccent,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: provider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (_, __) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                  ),
          ),
          SizedBox(width: SC.sw(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _zodiacName,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(14),
                    color: AC.blackText6,
                  ),
                ),
                SizedBox(height: SC.sh(4)),
                Row(
                  children: [
                    Text(
                      _zodiacModality,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: SC.sf(12),
                        color: AC.greyText4,
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: SC.sh(12)),
                // Text(
                //   '“Tụi con sẽ gửi cho Sen bản mật ngữ cực kỳ thú vị về chòm sao này nè.”',
                //   style: TextStyle(
                //     fontFamily: 'Quicksand',
                //     fontWeight: FontWeight.w500,
                //     fontSize: SC.sf(12),
                //     color: AC.neutralPrimaryText,
                //     height: 1.5,
                //     letterSpacing: 0.2,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topicsCard() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.zodiacTopicTitle,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopicRow(
                label: l10n.zodiacTopicPersonality,
                value: _topicPersonality,
                onChanged: (value) {
                  setState(() => _topicPersonality = value ?? false);
                },
              ),
              SizedBox(height: SC.sh(8)),
              _TopicRow(
                label: l10n.zodiacTopicNextWeek,
                value: _topicNextWeek,
                onChanged: (value) {
                  setState(() => _topicNextWeek = value ?? false);
                },
              ),
              SizedBox(height: SC.sh(8)),
              _TopicRow(
                label: l10n.zodiacTopicNextMonth,
                value: _topicNextMonth,
                onChanged: (value) {
                  setState(() => _topicNextMonth = value ?? false);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _prefillFromLocal() async {
    final user = await UserDetailLocalStorage().read();
    if (!mounted) return;
    final dob = _parseDateOfBirth(user?.dateOfBirth);
    setState(() {
      _birthDate = dob;
      _updateZodiacInfo(dob);
    });
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

    final dob = _birthDate;
    final options = _collectSelectedTopics();

    if (dob == null) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.numerologyDobEmpty,
      );
      return;
    }
    if (options.isEmpty) {
      ToastOverlay.show(
        context,
        AppLocalizations.of(context)!.zodiacTopicTitle,
      );
      return;
    }

    final birthdate = DateFormat('yyyy-MM-dd').format(dob);

    _overlay.show(AppLocalizations.of(context)!.zodiacSending);
    setState(() => _isSubmitting = true);
    try {
      final res = await AbilitiesRemoteService.sendZodiac(
        conversationId: widget.conversationId,
        birthdate: birthdate,
        zodiacOptions: options,
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

  List<String> _collectSelectedTopics() {
    final topics = <String>[];
    if (_topicPersonality) {
      topics.add(AppLocalizations.of(context)!.zodiacTopicPersonality);
    }
    if (_topicNextWeek) {
      topics.add(AppLocalizations.of(context)!.zodiacTopicNextWeek);
    }
    if (_topicNextMonth) {
      topics.add(AppLocalizations.of(context)!.zodiacTopicNextMonth);
    }
    return topics;
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

  void _handlePopInvoked(bool didPop) {
    _overlay.hide();
  }

  void _updateZodiacInfo(DateTime? date) {
    final l10n = AppLocalizations.of(context);
    if (date == null) {
      _zodiacName = l10n?.zodiacCardPlaceholderName ?? '';
      _zodiacModality = '';
      _zodiacIconUrl = null;
      setState(() {});
      return;
    }
    final mmdd = date.month * 100 + date.day;
    _ZodiacInfo? matched;
    for (final z in _zodiacData) {
      final spansYear = z.from > z.to;
      final inRange = spansYear
          ? (mmdd >= z.from || mmdd <= z.to)
          : (mmdd >= z.from && mmdd <= z.to);
      if (inRange) {
        matched = z;
        break;
      }
    }
    if (matched != null) {
      _zodiacName =
          '${AppLocalizations.of(context)?.zodiacCardPlaceholderName ?? ''} ${matched.name}'
              .trim();
      _zodiacModality = matched.modality;
      _zodiacIconUrl = matched.icon;
    } else {
      _zodiacName = l10n?.zodiacCardPlaceholderName ?? '';
      _zodiacModality = '';
      _zodiacIconUrl = null;
    }
    setState(() {});
  }
}

class _ConstellationIntroCard extends StatelessWidget {
  const _ConstellationIntroCard({
    required this.name,
    required this.avatarUrl,
    required this.personaName,
  });

  final String name;
  final String? avatarUrl;
  final String? personaName;

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
            '“Sen có nhớ cung hoàng đạo của mình hok? Chỉ cần ngày sinh thôi, lại đây con chỉ cho”',
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

class _ConstellationNotice extends StatelessWidget {
  const _ConstellationNotice();

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
        '“Cái này vui vui thôi ak, không phải mê tín hay dự đoán vận mệnh đâu Sen ơi.”',
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

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AC.greenStrong2,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          side: BorderSide(color: AC.neutralPrimaryText, width: 2),
          checkColor: Colors.white,
        ),
        SizedBox(width: SC.sw(8)),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: SC.sf(14),
              color: AC.blackPure,
            ),
          ),
        ),
      ],
    );
  }
}

class _ZodiacInfo {
  final String name;
  final String modality;
  final String icon;
  final int from;
  final int to;
  const _ZodiacInfo({
    required this.name,
    required this.modality,
    required this.icon,
    required this.from,
    required this.to,
  });
}
