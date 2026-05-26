import 'package:flutter/widgets.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_ui_controller.dart';
import 'package:flutter_chat_mock_app/assistant/navigation/open_assistant_chat.dart';
import 'package:flutter_chat_mock_app/providers/nanny_chat_provider.dart';
import 'package:flutter_chat_mock_app/assistant/widgets/assistant_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssistantHost extends ConsumerWidget {
  const AssistantHost({super.key, required this.child, this.onOpenChat});

  final Widget child;
  final Future<void> Function(BuildContext context)? onOpenChat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(nannySocketBridgeProvider);
    final uiState = ref.watch(assistantUiControllerProvider);
    final shouldShowFab = uiState.isVisible && !uiState.isChatOpen;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (shouldShowFab)
          AssistantFab(onTap: () => _handleOpenChat(context, ref)),
      ],
    );
  }

  Future<void> _handleOpenChat(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(assistantUiControllerProvider.notifier);
    final state = ref.read(assistantUiControllerProvider);
    if (state.isChatOpen) return;

    controller.openChat();
    try {
      if (onOpenChat != null) {
        await onOpenChat!(context);
      } else {
        await openAssistantChat(context);
      }
    } finally {
      controller.closeChat();
    }
  }
}
