import 'package:flutter/widgets.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_ui_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssistantVisibilityScope extends ConsumerStatefulWidget {
  const AssistantVisibilityScope({
    super.key,
    required this.visible,
    required this.child,
  });

  const AssistantVisibilityScope.show({super.key, required this.child})
    : visible = true;

  const AssistantVisibilityScope.hide({super.key, required this.child})
    : visible = false;

  final bool visible;
  final Widget child;

  @override
  ConsumerState<AssistantVisibilityScope> createState() =>
      _AssistantVisibilityScopeState();
}

class _AssistantVisibilityScopeState
    extends ConsumerState<AssistantVisibilityScope> {
  late final AssistantUiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(assistantUiControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyVisibility(widget.visible);
    });
  }

  void _applyVisibility(bool visible) {
    if (visible) {
      _controller.show();
    } else {
      _controller.hide();
    }
  }

  @override
  void didUpdateWidget(covariant AssistantVisibilityScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible) {
      _applyVisibility(widget.visible);
    }
  }

  @override
  void dispose() {
    if (!widget.visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.show();
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
