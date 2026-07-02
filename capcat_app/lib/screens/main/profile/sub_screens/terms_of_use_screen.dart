import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/media_query_utils.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:capcat_doca/utils/size_config.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  TextStyle get bold => TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    fontSize: SC.sf(14),
    height: 1.71,
    letterSpacing: 0.003,
    color: AC.blackText1,
  );

  TextStyle get normal => TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w500,
    fontSize: SC.sf(14),
    height: 1.71,
    letterSpacing: 0.003,
    color: AC.blackText1,
  );

  Widget numberedBlock(String title, String body) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "$title\n", style: bold),
          TextSpan(text: body, style: normal),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AssistantVisibilityScope.hide(
      child: CustomScaffold(
        backgroundColor: AC.white,
        body: SafeAreaTopOnly(
          child: Column(
            children: [
              CustomAppHeader(
                title: l10n.termsTitle,
                hasLeftAction: true,
                color: AC.white,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: MQ.bottomPadding(context),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SC.sw(24),
                      vertical: SC.sh(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/cap-cat-logo-terms.png',
                            width: SC.sw(240),
                          ),
                        ),
                        SizedBox(height: SC.sh(32)),
                        Center(
                          child: Text(
                            l10n.termsHeroTitle,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(20),
                              height: 1.2,
                              letterSpacing: 0.003,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: SC.sh(8)),
                        Text(
                          l10n.termsIntro,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500,
                            fontSize: SC.sf(14),
                            height: 1.71,
                            letterSpacing: 0.003,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection1Title,
                          l10n.termsSection1Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection2Title,
                          l10n.termsSection2Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection3Title,
                          l10n.termsSection3Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection4Title,
                          l10n.termsSection4Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection5Title,
                          l10n.termsSection5Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection6Title,
                          l10n.termsSection6Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        numberedBlock(
                          l10n.termsSection7Title,
                          l10n.termsSection7Body,
                        ),
                        SizedBox(height: SC.sh(8)),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w500,
                              fontSize: SC.sf(14),
                              height: 1.71,
                              letterSpacing: 0.003,
                              color: AC.blackText1,
                            ),
                            children: [
                              const TextSpan(text: ''),
                              TextSpan(
                                text:
                                    '${l10n.termsContact}\n📩 ${l10n.termsContactEmail}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ), // ✅ in đậm
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
