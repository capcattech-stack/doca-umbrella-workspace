class AssistantUiState {
  const AssistantUiState({required this.isVisible, required this.isChatOpen});

  final bool isVisible;
  final bool isChatOpen;

  AssistantUiState copyWith({bool? isVisible, bool? isChatOpen}) {
    return AssistantUiState(
      isVisible: isVisible ?? this.isVisible,
      isChatOpen: isChatOpen ?? this.isChatOpen,
    );
  }

  static const AssistantUiState initial = AssistantUiState(
    isVisible: true,
    isChatOpen: false,
  );
}
