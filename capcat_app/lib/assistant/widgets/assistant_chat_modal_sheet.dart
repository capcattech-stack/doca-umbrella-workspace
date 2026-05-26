import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/message.dart';
import 'package:flutter_chat_mock_app/providers/nanny_chat_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/nanny_chat_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/nanny_pinned_messages_view.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/sheets/custom_action_sheet_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssistantChatModalSheet extends StatelessWidget {
  const AssistantChatModalSheet({super.key});

  static const double heightFactor = 0.94;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: CustomActionSheetContainer(
        showHandle: true,
        padding: EdgeInsets.zero,
        expandChild: true,
        clipBehavior: Clip.antiAlias,
        child: const _AssistantChatSheetBody(),
      ),
    );
  }
}

enum _AssistantSheetMode { chat, pinnedMessages }

class _AssistantChatSheetBody extends StatefulWidget {
  const _AssistantChatSheetBody();

  @override
  State<_AssistantChatSheetBody> createState() =>
      _AssistantChatSheetBodyState();
}

class _AssistantChatSheetBodyState extends State<_AssistantChatSheetBody> {
  _AssistantSheetMode _mode = _AssistantSheetMode.chat;

  void _togglePinnedMessagesMode() {
    setState(() {
      _mode = _mode == _AssistantSheetMode.chat
          ? _AssistantSheetMode.pinnedMessages
          : _AssistantSheetMode.chat;
    });
  }

  void _openPinnedMessage(Message message) {
    final messageId = message.id?.trim();
    setState(() => _mode = _AssistantSheetMode.chat);
    if (messageId == null || messageId.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ProviderScope.containerOf(
        context,
        listen: false,
      ).read(nannyFocusMessageRequestProvider.notifier).state = messageId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 24,
            child: Row(
              children: [
                _SheetIconButton(
                  assetPath: _mode == _AssistantSheetMode.chat
                      ? 'assets/icons/pin.svg'
                      : 'assets/icons/left-arrow-black.png',
                  onTap: _togglePinnedMessagesMode,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: IndexedStack(
            index: _mode == _AssistantSheetMode.chat ? 0 : 1,
            children: [
              const NannyChatScreen(),
              NannyPinnedMessagesView(onTapMessage: _openPinnedMessage),
            ],
          ),
        ),
      ],
    );
  }
}

class _SheetIconButton extends StatelessWidget {
  const _SheetIconButton({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: assetPath.toLowerCase().endsWith('.svg')
              ? SvgPicture.asset(
                  assetPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    AC.neutralPrimaryText,
                    BlendMode.srcIn,
                  ),
                )
              : Image.asset(assetPath, width: 24, height: 24),
        ),
      ),
    );
  }
}
