import 'package:flutter/material.dart';

@immutable
class ChatComposerViewData {
  const ChatComposerViewData({
    required this.isSendDisabled,
    required this.isToolPanelEnabled,
    required this.isToolPanelVisible,
    required this.hasPendingAttachments,
    required this.hintText,
  });

  final bool isSendDisabled;
  final bool isToolPanelEnabled;
  final bool isToolPanelVisible;
  final bool hasPendingAttachments;
  final String hintText;
}

@immutable
class ChatComposerActions {
  const ChatComposerActions({
    required this.onToggleTools,
    required this.onSendText,
  });

  final VoidCallback onToggleTools;
  final ValueChanged<String> onSendText;
}

@immutable
class ChatToolPanelActions {
  const ChatToolPanelActions({
    required this.onSendImage,
    required this.onTapNumerology,
    required this.onTapConstellation,
    required this.onTapCreateContent,
  });

  final VoidCallback onSendImage;
  final VoidCallback onTapNumerology;
  final VoidCallback onTapConstellation;
  final VoidCallback onTapCreateContent;
}
