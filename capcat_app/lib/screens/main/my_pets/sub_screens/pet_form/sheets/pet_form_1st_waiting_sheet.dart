// file: pet_form_1st_waiting_sheet.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PetForm1stWaitingSheet extends StatelessWidget {
  const PetForm1stWaitingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AC.white,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: SC.sh(64)),
          SizedBox(
            height: SC.sh(239),
            child: Stack(
              children: [
                Positioned(
                  top: SC.sh(63),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: SC.smin(156),
                      height: SC.smin(156),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(46, 156, 93, 0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/pet-form-waiting-cat.gif',
                    height: SC.sh(239),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SC.sh(16)),
          Text(
            l10n.petFormWaitingTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontSize: SC.sf(20),
              height: 1.5,
              color: Colors.black,
            ),
          ),
          SizedBox(height: SC.sh(8)),
          const _PetAnalysisStepsWidget(),
        ],
      ),
    );
  }
}

class _PetAnalysisStepsWidget extends ConsumerStatefulWidget {
  const _PetAnalysisStepsWidget();

  @override
  ConsumerState<_PetAnalysisStepsWidget> createState() =>
      _PetAnalysisStepsWidgetState();
}

class _PetAnalysisStepsWidgetState
    extends ConsumerState<_PetAnalysisStepsWidget> {
  /// 4 bước hiển thị trên UI
  final List<_StepData> _steps = [
    _StepData('petFormWaitingStep1'),
    _StepData('petFormWaitingStep2'),
    _StepData('petFormWaitingStep3'),
    _StepData('petFormWaitingStep4'),
  ];

  /// Index bước đã hoàn tất gần nhất. -1 = chưa bước nào xong.
  int _currentDoneIndex = -1;

  /// Timer “giả” chỉ dùng cho bước 1 & 2
  Timer? _stepTimer;

  /// Lắng nghe provider hoàn tất preload master data & phân tích avatar
  late final ProviderSubscription<bool> _subMasterData;
  late final ProviderSubscription<bool> _subAnalysis;

  @override
  void initState() {
    super.initState();

    // 1) Bắt đầu fake cho bước 1 & 2 bằng long timer
    _startFakeStep01();

    // 2) Nghe "preload master data" thành công -> hoàn tất bước 3 (index 2)
    _subMasterData = ref.listenManual<bool>(petMasterDataReadyProvider, (
      prev,
      next,
    ) {
      if (next == true) {
        _tryAdvanceTo(2); // index 2 = bước 3
      }
    });

    // 3) Nghe "phân tích avatar" thành công -> hoàn tất bước 4 (index 3)
    _subAnalysis = ref.listenManual<bool>(petAnalysisDoneProvider, (
      prev,
      next,
    ) {
      if (next == true) {
        _tryAdvanceTo(3); // index 3 = bước 4
      }
    });
  }

  /// Chạy “giả” chỉ cho bước 1 và 2, mỗi tick hoàn tất 1 bước.
  void _startFakeStep01() {
    // Một nhịp dài ~1.4s: bạn có thể chỉnh theo ý muốn
    const interval = Duration(milliseconds: 1400);

    _stepTimer?.cancel();
    _stepTimer = Timer.periodic(interval, (timer) {
      // Chỉ auto cho đến khi xong bước 2 (index 1)
      if (_currentDoneIndex < 1) {
        _completeNextStep();
      } else {
        timer.cancel();
      }
    });
  }

  /// Hoàn tất step tiếp theo (current + 1)
  void _completeNextStep() {
    final nextIndex = _currentDoneIndex + 1;
    if (nextIndex >= 0 && nextIndex < _steps.length) {
      if (!mounted) return;
      setState(() {
        _currentDoneIndex = nextIndex;
        _steps[nextIndex].isDone = true;
      });
    }
  }

  /// Đảm bảo hoàn tất tất cả các bước từ 0..targetIndex (nếu cần)
  /// Không dùng short timer nữa — hoàn tất ngay lập tức theo thứ tự.
  void _tryAdvanceTo(int targetIndex) {
    if (targetIndex < 0) return;
    if (targetIndex >= _steps.length) return;

    if (!mounted) return;
    setState(() {
      // Nếu đang fake timer cho step 1&2 mà target >= 2,
      // dừng timer để tránh conflict.
      if (targetIndex >= 2) {
        _stepTimer?.cancel();
      }

      for (int i = _currentDoneIndex + 1; i <= targetIndex; i++) {
        _steps[i].isDone = true;
      }
      _currentDoneIndex = targetIndex;
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _subMasterData.close();
    _subAnalysis.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _steps
              .asMap()
              .entries
              .map(
                (entry) => _StepRow(
                  text: _stepText(AppLocalizations.of(context)!, entry.value.key),
                  isDone: entry.value.isDone,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String text;
  final bool isDone;

  const _StepRow({required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final Color doneColor = AC.greenStrong1;
    final Color waitingColor = AC.greyCheckbox;

    return Padding(
      padding: EdgeInsets.only(bottom: SC.sh(8)),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: isDone ? doneColor : waitingColor,
            size: SC.smin(19.2),
          ),
          SizedBox(width: SC.sw(8)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
                fontSize: SC.sf(14),
                height: 24 / 14,
                color: isDone ? AC.neutralPrimaryText : waitingColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  final String key;
  bool isDone;

  _StepData(this.key) : isDone = false;
}

String _stepText(AppLocalizations l10n, String key) {
  switch (key) {
    case 'petFormWaitingStep1':
      return l10n.petFormWaitingStep1;
    case 'petFormWaitingStep2':
      return l10n.petFormWaitingStep2;
    case 'petFormWaitingStep3':
      return l10n.petFormWaitingStep3;
    case 'petFormWaitingStep4':
      return l10n.petFormWaitingStep4;
    default:
      return '';
  }
}
