import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingOverlayProvider =
    StateNotifierProvider<LoadingOverlayController, LoadingOverlayState>(
      (ref) => LoadingOverlayController(),
    );

class LoadingOverlayState {
  final bool isVisible;
  final String message;

  const LoadingOverlayState({this.isVisible = false, this.message = ''});
}

class LoadingOverlayController extends StateNotifier<LoadingOverlayState> {
  LoadingOverlayController() : super(const LoadingOverlayState());

  void show(String message) {
    state = LoadingOverlayState(isVisible: true, message: message);
  }

  void updateMessage(String message) {
    if (state.isVisible) {
      state = LoadingOverlayState(isVisible: true, message: message);
    }
  }

  void hide() {
    state = const LoadingOverlayState();
  }
}
