import 'package:flutter/material.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';

class PasswordRequirementsChecklist extends StatelessWidget {
  const PasswordRequirementsChecklist({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final rulesResult = PasswordRulesResult.from(password);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PasswordRequirementRow(
          text: l10n.passwordRuleLength,
          isMet: rulesResult.hasLength,
        ),
        PasswordRequirementRow(
          text: l10n.passwordRuleNumber,
          isMet: rulesResult.hasNumber,
        ),
        PasswordRequirementRow(
          text: l10n.passwordRuleUpper,
          isMet: rulesResult.hasUpperCase,
        ),
      ],
    );
  }
}

class PasswordRequirementRow extends StatelessWidget {
  const PasswordRequirementRow({
    super.key,
    required this.text,
    required this.isMet,
  });

  final String text;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isMet
        ? AC.greenStrong1
        : AC.slatePasswordHint;
    final Color textColor = isMet
        ? AC.neutralPasswordText
        : AC.slatePasswordHint;
    final IconData iconData = isMet ? Icons.check_circle : Icons.info_outline;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: SC.sh(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData, color: iconColor, size: SC.smin(20)),
          SizedBox(width: SC.sw(10)),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              text,

              style: TextStyle(
                fontFamily: 'Quicksand',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(12),
                height: 24 / 12,
                letterSpacing: 0,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordRulesResult {
  final bool hasLength;
  final bool hasNumber;
  final bool hasUpperCase;

  const PasswordRulesResult({
    required this.hasLength,
    required this.hasNumber,
    required this.hasUpperCase,
  });

  factory PasswordRulesResult.from(String value) {
    return PasswordRulesResult(
      hasLength: value.length >= 8 && value.length <= 20,
      hasNumber: RegExp(r'[0-9]').hasMatch(value),
      hasUpperCase: RegExp(r'[A-Z]').hasMatch(value),
    );
  }
}
