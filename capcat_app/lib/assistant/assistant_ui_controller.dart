import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_ui_state.dart';

final assistantUiControllerProvider =
    StateNotifierProvider<AssistantUiController, AssistantUiState>(
      (ref) => AssistantUiController(),
    );

class AssistantUiController extends StateNotifier<AssistantUiState> {
  AssistantUiController() : super(AssistantUiState.initial);

  int _chatOpenCount = 0;

  void setVisible(bool visible) {
    if (state.isVisible == visible) return;
    state = state.copyWith(isVisible: visible);
  }

  void show() {
    setVisible(true);
  }

  void hide() {
    setVisible(false);
  }

  void setChatOpen(bool isOpen) {
    if (state.isChatOpen == isOpen) return;
    state = state.copyWith(isChatOpen: isOpen);
  }

  void openChat() {
    _chatOpenCount += 1;
    setChatOpen(true);
  }

  void closeChat() {
    if (_chatOpenCount > 0) {
      _chatOpenCount -= 1;
    }
    if (_chatOpenCount == 0) {
      setChatOpen(false);
    }
  }

  void reset() {
    _chatOpenCount = 0;
    state = AssistantUiState.initial;
  }
}
