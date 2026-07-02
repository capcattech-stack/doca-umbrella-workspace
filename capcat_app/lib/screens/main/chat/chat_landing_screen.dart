import 'package:flutter/material.dart';
import 'package:capcat_doca/models/chat_pet.dart';
import 'package:capcat_doca/models/conversation.dart';
import 'package:capcat_doca/providers/chat_pet_provider.dart';
import 'package:capcat_doca/providers/list_conversation_provider.dart';
import 'package:capcat_doca/screens/main/chat/chat_screen.dart';
import 'package:capcat_doca/screens/main/chat/shared/chat_screen_entry_source.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/edit_pet_persona_screen.dart';
import 'package:capcat_doca/services/chat_conversation_remote_service.dart';
import 'package:capcat_doca/providers/socket_provider.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/date_format_config.dart';
import 'package:capcat_doca/utils/image_utils.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/utils/navigation_utils.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class ChatLandingScreen extends ConsumerStatefulWidget {
  const ChatLandingScreen({super.key, this.openAsAssistantMode = false});

  final bool openAsAssistantMode;

  static final _horizontalPadding = SC.sw(24);
  static final _verticalPadding = SC.sh(16);

  @override
  ConsumerState<ChatLandingScreen> createState() => _ChatLandingScreenState();
}

class _ChatLandingScreenState extends ConsumerState<ChatLandingScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> _conversationFilterIds = [
    'all',
    'personal',
    'system',
  ];

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _shouldAnimate = false;
  io.Socket? _socket;
  ProviderSubscription<AsyncValue<io.Socket?>>? _socketSubscription;
  String _selectedConversationFilter = _conversationFilterIds.first;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..value = 1;

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _socketSubscription = ref.listenManual<AsyncValue<io.Socket?>>(
      socketProvider,
      (previous, next) {
        next.whenData((socket) {
          if (socket == null) {
            _detachSocket();
          } else {
            _attachSocket(socket);
          }
        });
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _socketSubscription?.close();
    _detachSocket();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() => _shouldAnimate = true);
    await Future.wait([
      ref
          .read(listConversationProvider.notifier)
          .refresh(agentType: _currentAgentType),
      ref.read(chatPetListProvider.notifier).refresh(),
    ]);
  }

  void _attachSocket(io.Socket socket) {
    if (_socket == socket) return;
    _detachSocket();
    _socket = socket;
    _registerSocketHandlers(socket);
  }

  void _detachSocket() {
    _socket?.off('server-messaging', _handleServerMessaging);
    _socket?.off('server-messages', _handleServerMessages);
    _socket?.off('exception', _handleSocketException);
    _socket = null;
  }

  void _registerSocketHandlers(io.Socket socket) {
    socket
      ..off('server-messaging', _handleServerMessaging)
      ..off('server-messages', _handleServerMessages)
      ..off('exception', _handleSocketException);
    socket.on('server-messaging', _handleServerMessaging);
    socket.on('server-messages', _handleServerMessages);
    socket.on('exception', _handleSocketException);
  }

  void _handleServerMessaging(dynamic _) {
    _refreshConversations();
  }

  void _handleServerMessages(dynamic _) {
    _refreshConversations();
  }

  void _handleSocketException(dynamic data) {
    debugPrint('⚠️ Socket exception on landing screen: $data');
  }

  void _refreshConversations() {
    if (!mounted) return;
    ref
        .read(listConversationProvider.notifier)
        .refreshSilently(agentType: _currentAgentType);
  }

  void _onFilterSelected(String filter) async {
    if (_selectedConversationFilter == filter || !mounted) return;
    setState(() => _selectedConversationFilter = filter);
    final success = await ref
        .read(listConversationProvider.notifier)
        .refreshSilently(agentType: _currentAgentType);
    if (!mounted || success) return;
    _showFilterRefreshError();
  }

  void _showFilterRefreshError() {
    final l10n = AppLocalizations.of(context)!;
    ToastOverlay.show(context, l10n.chatLandingConversationError);
  }

  Future<void> _handleStartChatFromPet(ChatPet pet) async {
    final existingConversationId = pet.conversationId;
    if (existingConversationId != null && existingConversationId.isNotEmpty) {
      _openConversationById(existingConversationId);
      return;
    }

    final response = await ChatConversationRemoteService.startConversation(
      petId: pet.id,
    );

    if (!mounted) return;

    if (!response.isSuccess || response.data == null) {
      if (response.errorCode == 'AI_AGENT_INFO_NOT_FOUND') {
        customCrossFadePush(context, EditPetPersonaScreen(petId: pet.id));
        return;
      }
      final l10n = AppLocalizations.of(context)!;
      final message =
          response.message ?? l10n.chatLandingCannotStartConversation;
      TO.show(context, message);
      return;
    }

    final conversation = response.data!;
    ref
        .read(listConversationProvider.notifier)
        .refreshSilently(
          agentType: _currentAgentType,
        ); // refresh list for new conversation
    customCrossFadePush(
      context,
      ChatScreen(
        conversation: conversation,
        entrySource: widget.openAsAssistantMode
            ? ChatScreenEntrySource.assistantFab
            : ChatScreenEntrySource.standard,
      ),
    );
  }

  void _openConversationById(String conversationId) {
    final conversations = ref.read(listConversationProvider).value;
    final existing = conversations?.firstWhere((c) => c.id == conversationId);
    if (existing == null) return;
    _openConversation(existing);
  }

  void _openConversation(Conversation conversation) {
    customCrossFadePush(
      context,
      ChatScreen(
        conversation: conversation,
        entrySource: widget.openAsAssistantMode
            ? ChatScreenEntrySource.assistantFab
            : ChatScreenEntrySource.standard,
      ),
    );
  }

  String? get _currentAgentType {
    switch (_selectedConversationFilter) {
      case 'personal':
        return 'pet_personal';
      case 'system':
        return 'pet_system';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final conversationsAsync = ref.watch(listConversationProvider);
    final chatPetsAsync = ref.watch(chatPetListProvider);

    return Column(
      children: [
        CustomAppHeader(
          title: l10n.chatLandingHeader,
          hasLeftAction: false,
          color: AC.white,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              // top: SC.sh(16),
              bottom: MQ.bottomPadding(context),
            ),
            child: conversationsAsync.when(
              loading: () => const _LoadingState(),
              error: (_, __) => _ErrorState(
                message: l10n.chatLandingConversationError,
                onRetry: () => ref
                    .read(listConversationProvider.notifier)
                    .refresh(agentType: _currentAgentType),
              ),
              data: (conversations) {
                if (conversations.isEmpty) {
                  _shouldAnimate = false;
                  _animController.value = 1;
                } else if (_shouldAnimate) {
                  _animController.forward(from: 0);
                  _shouldAnimate = false;
                }

                return FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _buildConversationSection(
                      chatPetsAsync,
                      conversations,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConversationSection(
    AsyncValue<List<ChatPet>> chatPetsAsync,
    List<Conversation> conversations,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final hasConversations = conversations.isNotEmpty;
    final conversationItemCount = hasConversations ? conversations.length : 1;
    final totalItems =
        1 /* pet suggestion */ +
        1 /* conversation header + filters */ +
        conversationItemCount +
        1 /* bottom spacer */;

    return RefreshIndicator(
      color: AC.greenStrong1,
      backgroundColor: AC.white,
      onRefresh: _onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          ChatLandingScreen._horizontalPadding,
          ChatLandingScreen._verticalPadding,
          ChatLandingScreen._horizontalPadding,
          ChatLandingScreen._verticalPadding,
        ),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _ChatPetSuggestion(
              petsAsync: chatPetsAsync,
              onRetry: () => ref.read(chatPetListProvider.notifier).refresh(),
              onTapPet: _handleStartChatFromPet,
              l10n: l10n,
            );
          }

          if (index == 1) {
            return _ConversationListHeader(
              filterIds: _conversationFilterIds,
              selectedFilter: _selectedConversationFilter,
              onFilterSelected: _onFilterSelected,
              l10n: l10n,
            );
          }

          if (!hasConversations) {
            if (index == totalItems - 1) {
              return SizedBox(
                height: SC.sh(SC.desBotBarHeight + SC.desBotBarVp),
              );
            }
            return const _EmptyState();
          }

          if (index == totalItems - 1) {
            return SizedBox(height: SC.sh(SC.desBotBarHeight + SC.desBotBarVp));
          }

          final conversation = conversations[index - 2];
          return _ConversationCard(
            conversation: conversation,
            onTap: () => _openConversation(conversation),
          );
        },
        separatorBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(height: SC.sh(16));
          }
          if (index == 1) {
            return SizedBox(height: SC.sh(8));
          }
          if (index >= totalItems - 2) {
            return const SizedBox.shrink();
          }
          if (!hasConversations) {
            return SizedBox(height: SC.sh(16));
          }
          return const Divider(height: 1, color: AC.greyLine2);
        },
      ),
    );
  }
}

class _ConversationListHeader extends StatelessWidget {
  const _ConversationListHeader({
    required this.filterIds,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.l10n,
  });

  final List<String> filterIds;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          l10n.chatLandingConversationTitle,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: SC.sf(14),
            color: AC.blackText1,
          ),
        ),
        SizedBox(height: SC.sh(8)),
        _ConversationFilterRow(
          filterIds: filterIds,
          selectedFilter: selectedFilter,
          onFilterSelected: onFilterSelected,
          l10n: l10n,
        ),
      ],
    );
  }
}

class _ConversationFilterRow extends StatelessWidget {
  const _ConversationFilterRow({
    required this.filterIds,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.l10n,
  });

  final List<String> filterIds;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: SC.sh(4)),
      child: Row(
        children: [
          for (var i = 0; i < filterIds.length; i++) ...[
            _ConversationFilterChip(
              label: _labelForFilter(filterIds[i]),
              isSelected: filterIds[i] == selectedFilter,
              onTap: () => onFilterSelected(filterIds[i]),
            ),
            if (i != filterIds.length - 1) SizedBox(width: SC.sw(10)),
          ],
        ],
      ),
    );
  }

  String _labelForFilter(String id) {
    switch (id) {
      case 'personal':
        return l10n.chatLandingFilterYours;
      case 'system':
        return l10n.chatLandingFilterCapcat;
      default:
        return l10n.chatLandingFilterAll;
    }
  }
}

class _ConversationFilterChip extends StatelessWidget {
  const _ConversationFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? AC.greyCheckbox : AC.greyTab1;
    final textColor = isSelected ? AC.blackText6 : AC.greyText4;

    return TapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SC.sh(4),
          horizontal: SC.sw(12),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            // fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: SC.sf(12),
            height: 16 / 12,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _ChatPetSuggestion extends StatelessWidget {
  const _ChatPetSuggestion({
    required this.petsAsync,
    required this.onRetry,
    required this.onTapPet,
    required this.l10n,
  });

  final AsyncValue<List<ChatPet>> petsAsync;
  final VoidCallback onRetry;
  final ValueChanged<ChatPet> onTapPet;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return petsAsync.when(
      data: (pets) {
        if (pets.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chatLandingSuggestionTitle,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: SC.sf(14),
                color: AC.blackText1,
              ),
            ),
            SizedBox(height: SC.sh(8)),
            SizedBox(
              height: SC.smin(66),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: pets.length,
                itemBuilder: (_, index) => _ChatPetSuggestionItem(
                  pet: pets[index],
                  onTap: () => onTapPet(pets[index]),
                ),
                separatorBuilder: (_, __) => SizedBox(width: SC.sw(12)),
              ),
            ),
            Container(
              width: double.infinity,
              height: SC.sh(1),
              color: AC.greyLine2,
            ),
          ],
        );
      },
      loading: () => SizedBox(
        height: SC.smin(96),
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(right: index == 2 ? 0 : SC.sw(12)),
              child: const _ChatPetAvatarPlaceholder(),
            ),
          ),
        ),
      ),
      error: (err, __) => _ChatPetErrorState(onRetry: onRetry, l10n: l10n),
    );
  }
}

class _ChatPetSuggestionItem extends StatelessWidget {
  const _ChatPetSuggestionItem({required this.pet, required this.onTap});

  final ChatPet pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatarSize = SC.smin(40);
    // final borderColor = pet.isSystem
    //     ? AppColors.greenStrong1
    //     : AC.slateSoftBg;

    return TapEffect(
      onTap: onTap,
      child: SizedBox(
        width: avatarSize + SC.sw(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              padding: EdgeInsets.all(SC.smin(2)),
              child: ClipOval(child: _ChatPetAvatarImage(pet.avatarUrl)),
            ),
            SizedBox(height: SC.sh(6)),
            Text(
              pet.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
                fontSize: SC.sf(12),
                color: AC.charcoalHeaderText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatPetAvatarImage extends StatelessWidget {
  const _ChatPetAvatarImage(this.imageUrl);

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleCachedNetworkImage(
        imageUrl: imageUrl!,
        size: SC.smin(64),
        subject: ImageSubject.pet,
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    return Image.asset(ImageUtils.petPlaceholderImage, fit: BoxFit.cover);
  }
}

class _ChatPetAvatarPlaceholder extends StatelessWidget {
  const _ChatPetAvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final size = SC.smin(64);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AC.slateLandingBg,
          ),
        ),
        SizedBox(height: SC.sh(6)),
        Container(
          width: size * 0.7,
          height: SC.sh(10),
          decoration: BoxDecoration(
            color: AC.slateLandingBg,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}

class _ChatPetErrorState extends StatelessWidget {
  const _ChatPetErrorState({required this.onRetry, required this.l10n});

  final VoidCallback onRetry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: SC.sh(8)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.chatLandingPetError,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(13),
                color: AC.slateChatHint,
              ),
            ),
          ),
          TapEffect(
            onTap: onRetry,
            child: Text(
              l10n.commonRetry,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
                fontSize: SC.sf(13),
                color: AppColors.greenStrong1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({required this.conversation, required this.onTap});
  final Conversation conversation;
  final VoidCallback onTap;

  static final double _avatarSize = SC.smin(56);

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SC.sh(8)),
        color: AppColors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleCachedNetworkImage(
              imageUrl: conversation.avatarUrl,
              size: _avatarSize,
              subject: ImageSubject.pet,
            ),

            SizedBox(width: SC.sw(8)),
            Expanded(child: _ConversationTexts(conversation)),
            // SizedBox(width: SC.sw(8)),
            // Image.asset(
            //   'assets/icons/arrow-right.png',
            //   width: SC.smin(16),
            //   height: SC.smin(16),
            //   color: AC.blackPanelText,
            // ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTexts extends StatelessWidget {
  const _ConversationTexts(this.conversation);
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rawPreview =
        conversation.lastMessagePreview ?? l10n.chatLandingStartConversation;
    final preview = conversation.isLastMessageFromSelf && rawPreview.isNotEmpty
        ? l10n.chatLandingPreviewYou(rawPreview)
        : rawPreview;
    final timestamp = conversation.lastMessageAt != null
        ? DateFormatConfig.formatConversationTimestamp(
            conversation.lastMessageAt!,
          )
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          conversation.title,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w600,
            fontSize: SC.sf(16),
            height: 22 / 16,
            letterSpacing: -0.4,
            color: Colors.black,
          ),
        ),
        SizedBox(height: SC.sh(2)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                preview,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(14),
                  height: 20 / 14,
                  letterSpacing: -0.15,
                  color: AC.blackBackdrop50,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (timestamp.isNotEmpty) ...[
              SizedBox(width: SC.sw(8)),
              Text(
                '· $timestamp',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: SC.sf(12),
                  color: AC.slateInputHint,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(24),
          vertical: SC.sh(24),
        ),
        child: Text(
          AppLocalizations.of(context)!.chatLandingEmpty,
          style: TextStyle(fontSize: SC.sf(16), color: AC.greyText5),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.chatLandingLoading,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w500,
          fontSize: SC.sf(14),
          color: AC.blackText1,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SC.sw(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: SC.sf(16),
                color: AC.greyText5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SC.sh(12)),
            TapEffect(
              onTap: onRetry,
              child: Text(
                l10n.commonRetry,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(14),
                  color: AppColors.greenStrong1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
