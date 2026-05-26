import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/widgets/assistant_chat_modal_sheet.dart';
import 'package:flutter_chat_mock_app/utils/global_keys.dart';

Future<void> openAssistantChat(BuildContext context) async {
  final rootContext = rootNavigatorKey.currentContext;
  if (rootContext == null) {
    return;
  }

  await showModalBottomSheet<void>(
    context: rootContext,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black45,
    routeSettings: const RouteSettings(name: 'assistant-chat-entry'),
    builder: (_) => const AssistantChatModalSheet(),
  );
}
