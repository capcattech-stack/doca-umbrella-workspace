import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/services/model/service_response.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/auth_util.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/input/input_field.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/text/section_header_text.dart';
import 'package:flutter_chat_mock_app/widgets/password/password_requirements_checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSaveTap() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isSaving) return;

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validate nhẹ nhàng phía client
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      if (!mounted) return;
      TO.show(context, l10n.changePasswordFillAll);
      return;
    }
    final rulesResult = PasswordRulesResult.from(newPassword);
    if (!rulesResult.hasLength ||
        !rulesResult.hasNumber ||
        !rulesResult.hasUpperCase) {
      TO.show(context, l10n.changePasswordRulesNotMet);
      return;
    }
    if (newPassword.length < 6) {
      if (!mounted) return;
      TO.show(context, l10n.changePasswordMinLength);
      return;
    }
    if (newPassword == currentPassword) {
      if (!mounted) return;
      TO.show(context, l10n.changePasswordDifferent);
      return;
    }
    if (newPassword != confirmPassword) {
      if (!mounted) return;
      TO.show(context, l10n.changePasswordMismatch);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final ServiceResponse serviceResponse = await AuthService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (!mounted) return;
      if (serviceResponse.isSuccess) {
        TO.show(context, l10n.changePasswordSuccess);
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        await AuthUtil.performLogout(context: context, ref: ref);
      } else {
        TO.show(context, l10n.changePasswordFailed);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double hp = SC.sw(24);
    final double vpS = SC.sh(8);
    final double vpM = SC.sh(16);
    final double vpL = SC.sh(24);
    final screenColor = AC.white;

    return AssistantVisibilityScope.hide(
      child: CustomScaffold(
        backgroundColor: screenColor,

        resizeToAvoidBottomInset: false,
        body: SafeAreaTopOnly(
          child: Column(
            children: [
              CustomAppHeader(
                title: l10n.changePasswordTitle,
                color: screenColor,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    hp,
                    vpM,
                    hp,
                    MQ.bottomPadding(context),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                l10n.changePasswordInfo,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: SC.sf(14),
                                  height: 24 / 14,
                                  letterSpacing: 0.2,
                                  color: AC.slatePasswordHint,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: vpM),
                              SectionHeaderText(l10n.changePasswordCurrent),
                              SizedBox(height: vpS),
                              InputField(
                                hintText: l10n.changePasswordHintCurrent,
                                controller: _currentPasswordController,
                                isPasswordField: true,

                                // obscureText: true,
                              ),
                              SizedBox(height: vpL),
                              SectionHeaderText(l10n.changePasswordNew),
                              SizedBox(height: vpS),
                              InputField(
                                hintText: l10n.changePasswordHintNew,
                                controller: _newPasswordController,
                                isPasswordField: true,
                                // obscureText: true,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: vpL),
                              SectionHeaderText(l10n.changePasswordConfirm),
                              SizedBox(height: vpS),
                              InputField(
                                hintText: l10n.changePasswordHintConfirm,
                                controller: _confirmPasswordController,
                                isPasswordField: true,
                                // obscureText: true,
                              ),
                              SizedBox(height: vpM),
                              PasswordRequirementsChecklist(
                                password: _newPasswordController.text,
                              ),
                              SizedBox(height: vpM),
                            ],
                          ),
                        ),
                      ),
                      ActionButton(
                        text: _isSaving
                            ? l10n.changePasswordSaving
                            : l10n.changePasswordSave,
                        color: AppColors.greenStrong1,
                        onTap: () {
                          _isSaving ? null : _onSaveTap();
                        },
                      ),
                      SizedBox(height: vpM),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
