import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';

class PetSocialNetwork extends StatelessWidget {
  const PetSocialNetwork({
    super.key,
    required this.petSocialView,
    required this.petSocialComment,
  });

  final int petSocialView;
  final int petSocialComment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: SC.sh(172),
      padding: EdgeInsets.symmetric(vertical: SC.sh(12)),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(16),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationSectionHeader(
            iconAsset: 'assets/icons/globe.png',
            title: l10n.petProfileSocialTitle,
          ),
          SizedBox(height: SC.sh(16)),
          SocialCardsContainer(
            petSocialView: petSocialView,
            petSocialComment: petSocialComment,
          ),
        ],
      ),
    );
  }
}

class NavigationSectionHeader extends StatelessWidget {
  final String iconAsset;
  final String title;

  const NavigationSectionHeader({
    super.key,
    required this.iconAsset,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SC.sh(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            iconAsset,
            width: SC.sh(24),
            height: SC.sh(24),
            fit: BoxFit.contain,
          ),
          SizedBox(width: SC.sw(6)),
          SizedBox(
            // width: 297,
            height: SC.sh(24),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(16),
                  // height: 1.5,
                  color: AC.blackText6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialCardsContainer extends StatelessWidget {
  const SocialCardsContainer({
    super.key,
    required this.petSocialView,
    required this.petSocialComment,
  });

  final int petSocialView;
  final int petSocialComment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      height: SC.sh(108),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardItem(
            bodyText: petSocialView.toString(),
            titleText: l10n.petProfileSocialViews,
            bodyColor: AC.greyText5,
            titleColor: AC.blackText5,
            iconAsset: 'assets/icons/heart.png',
          ),
          SizedBox(height: SC.sh(16)),
          CardItem(
            bodyText: petSocialComment.toString(),
            titleText: l10n.petProfileSocialComments,
            bodyColor: AC.greyText5,
            titleColor: AC.blackText5,
            iconAsset: 'assets/icons/chat.png',
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String bodyText;
  final String titleText;
  final Color bodyColor;
  final Color titleColor;
  final String iconAsset;

  const CardItem({
    super.key,
    required this.bodyText,
    required this.titleText,
    required this.bodyColor,
    required this.titleColor,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SC.sh(46),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: SC.sh(44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    titleText,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(14),
                      // height: 20 / 14,
                      color: bodyColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    bodyText,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: SC.sf(14),
                      // height: 22 / 14,
                      color: titleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: SC.sw(10)),
          Container(
            width: SC.sh(46),
            height: SC.sh(46),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(168, 216, 185, 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: AC.blackText1,
                      //   width: 1.5,
                      // ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    iconAsset,
                    width: SC.sh(20),
                    height: SC.sh(20),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
