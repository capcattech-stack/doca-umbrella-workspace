import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/utils/transition_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capcat_doca/services/connectivity_service.dart';

class NoInternetModalWidget extends ConsumerWidget {
  const NoInternetModalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityStatusProvider);

    if (status == ConnectivityStatus.connected) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: (status == ConnectivityStatus.disconnected) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: TransitionConfig.durationShort),
      curve: Curves.easeInOut,
      child: Stack(
        children: [
          // Nền tối đen bán trong suốt
          ModalBarrier(color: Colors.black.withAlpha(128), dismissible: false),

          // Nội dung modal
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(SizeConfig.sw(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    color: AppColors.blackText1,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Không có kết nối Internet',
                    style: TextStyle(
                      color: AppColors.blackText1,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.greenStrong1, // Màu nền cam tươi
                      foregroundColor: AppColors.blackText1, // Chữ màu trắng
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.blackText1.withOpacity(0.4),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Quicksand',
                        color: AppColors.blackText1,
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(connectivityStatusProvider.notifier)
                          .retryCheckConnection();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
