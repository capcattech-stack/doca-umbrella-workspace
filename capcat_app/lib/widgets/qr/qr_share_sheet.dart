import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showQrShareSheet(
  BuildContext context, {
  required String data,
  String title = 'QR chia sẻ',
}) {
  if (data.isEmpty) return Future.value();

  return showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(
      minWidth: MediaQuery.of(context).size.width,
      maxWidth: MediaQuery.of(context).size.width,
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SC.sw(16),
            SC.sh(16),
            SC.sw(16),
            MQ.bottomPadding(ctx) + SC.sh(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(16),
                  color: AC.blackText6,
                ),
              ),
              SizedBox(height: SC.sh(12)),
              QrImageView(
                data: data,
                version: QrVersions.auto,
                size: SC.smin(200),
              ),
              SizedBox(height: SC.sh(12)),
              // Tạm ẩn hiển thị raw URL.
              // SelectableText(
              //   data,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontFamily: 'Quicksand',
              //     fontWeight: FontWeight.w500,
              //     fontSize: SC.sf(12),
              //     color: AC.greyText4,
              //   ),
              // ),
              TapEffect(
                onTap: () async {
                  final uri = Uri.tryParse(data);
                  if (uri == null || !uri.hasScheme) {
                    if (ctx.mounted) {
                      ToastOverlay.show(ctx, 'Link không hợp lệ');
                    }
                    return;
                  }
                  final opened = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!opened && ctx.mounted) {
                    ToastOverlay.show(ctx, 'Không mở được đường dẫn');
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SC.sw(12),
                    vertical: SC.sh(8),
                  ),
                  decoration: BoxDecoration(
                    color: AC.greenStrong1.withAlpha((0.08 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: AC.greenStrong1,
                      ),
                      SizedBox(width: SC.sw(6)),
                      Text(
                        'Mở đường dẫn',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                          fontSize: SC.sf(12),
                          color: AC.greenStrong1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SC.sh(12)),
              TapEffect(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: data));
                  if (ctx.mounted) {
                    ToastOverlay.show(ctx, 'Đã sao chép link');
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SC.sw(12),
                    vertical: SC.sh(8),
                  ),
                  decoration: BoxDecoration(
                    color: AC.greyTab1,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.copy,
                        size: 16,
                        color: AC.neutralPrimaryText,
                      ),
                      SizedBox(width: SC.sw(6)),
                      Text(
                        'Sao chép link',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w600,
                          fontSize: SC.sf(12),
                          color: AC.blackText6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
