import 'package:flutter/material.dart';
import 'package:capcat_doca/providers/loading_overlay_provider.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:capcat_doca/gen/assets.gen.dart';

class LoadingOverlayWidget extends ConsumerWidget {
  const LoadingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(loadingOverlayProvider);

    if (!loading.isVisible) return const SizedBox.shrink();

    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withAlpha(128), dismissible: false),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.sw(24),
              vertical: SizeConfig.sh(20),
            ),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(178),
              borderRadius: BorderRadius.circular(SizeConfig.sw(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: SizeConfig.smin(64),
                  height: SizeConfig.smin(64),
                  child: Lottie.asset(
                    'assets/lottie/paw-loading.json',
                    fit: BoxFit.contain,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(['**'], value: AC.greenStrong1),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.sh(16)),
                Text(
                  loading.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AC.white,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.sf(12),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
