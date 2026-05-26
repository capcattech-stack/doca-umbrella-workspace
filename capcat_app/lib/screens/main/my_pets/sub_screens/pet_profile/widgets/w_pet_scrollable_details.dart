import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/sub_screens/share_pet_profile/share_pet_profile_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/widgets/w_pet_social_network.dart';
import 'package:flutter_chat_mock_app/utils/date_format_config.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/input/expandable_text_container.dart';

class PetScrollableDetails extends StatelessWidget {
  const PetScrollableDetails({
    super.key,
    this.scrollController,
    required this.pet,
  });

  final ScrollController? scrollController;
  final PetDetail pet;

  void _onTapButtonSharePetProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SharePetProfileScreen(petName: pet.name, petQrUrl: pet.shareUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double mediumVp = SC.sh(16);
    final double largeVp = SC.sh(24);
    //--ListView is more suitable with father DraggableScrollableSheet
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      children: [
        _AboutSection(
          petgender: pet.gender,
          petSize: pet.size ?? '--',
          petWeight: pet.weight ?? 0.0,
          title: l10n.petProfileAboutTitle,
          genderLabel: l10n.petProfileGenderLabel,
          sizeLabel: l10n.petProfileSizeLabel,
          weightLabel: l10n.petProfileWeightLabel,
        ),
        SizedBox(height: mediumVp),
        PetSocialNetwork(
          petSocialView: pet.socialView ?? 0,
          petSocialComment: pet.socialComment ?? 0,
        ),
        SizedBox(height: mediumVp),
        _ShareProfileButton(
          onTap: () {
            _onTapButtonSharePetProfile(context);
          },
        ),
        SizedBox(height: mediumVp),
        _AppearanceDetailsSection(
          petAppearanceDetails: pet.appearanceDetail ?? '',
          title: l10n.petProfileAppearanceTitle,
        ),
        SizedBox(height: mediumVp),
        _ImportantDatesSection(
          petBirthDay: pet.birthDate,
          petAdoptedDay: pet.adoptedDate,
          petAge: pet.age ?? 0,
          l10n: l10n,
        ),
        SizedBox(height: MQ.bottomPadding(context)),
        // _RaisersSection(),
        // const SizedBox(height: 16),
        // SizedBox(height: 16 + SizeConfig.designBotNavBarHeight + 24),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.petgender,
    required this.petSize,
    required this.petWeight,
    required this.title,
    required this.genderLabel,
    required this.sizeLabel,
    required this.weightLabel,
  });

  final PetGender petgender;
  final String petSize;
  final double petWeight;
  final String title;
  final String genderLabel;
  final String sizeLabel;
  final String weightLabel;

  @override
  Widget build(BuildContext context) {
    final double mediumVp = SC.sh(16);
    return Column(
      children: [
        Container(
          width: double.infinity,
          // height: 146,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AboutHeader(
                iconAsset: 'assets/icons/paw_stroke.png',
                title: title,
              ),
            ],
          ),
        ),
        SizedBox(height: mediumVp),
        _CardsRow(
          petGender: petgender,
          petSize: petSize,
          petWeight: petWeight,
          genderLabel: genderLabel,
          sizeLabel: sizeLabel,
          weightLabel: weightLabel,
        ),
      ],
    );
  }
}

class _AboutHeader extends StatelessWidget {
  final String iconAsset;
  final String title;
  const _AboutHeader({required this.iconAsset, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Image.asset(iconAsset, fit: BoxFit.contain),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
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

class _CardsRow extends StatelessWidget {
  const _CardsRow({
    required this.petGender,
    required this.petSize,
    required this.petWeight,
    required this.genderLabel,
    required this.sizeLabel,
    required this.weightLabel,
  });

  final PetGender petGender;
  final String petSize;
  final double petWeight;
  final String genderLabel;
  final String sizeLabel;
  final String weightLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SC.sh(106),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CardItem(
              backgroundColor: AC.pinkSoftBg,
              borderColor: AC.pinkSoftBg,
              iconAsset: 'assets/icons/female-simple.png',
              titleText: genderLabel,
              bodyText: petGender.value,
              titleColor: AC.slateSecondaryText,
              bodyColor: AC.blackText5,
            ),
          ),
          SizedBox(width: SC.sw(8)),
          Expanded(
            child: CardItem(
              backgroundColor: AC.peachCardBg,
              borderColor: AC.peachCardBg,
              iconAsset: 'assets/icons/height.png',
              titleText: sizeLabel,
              bodyText: petSize,
              titleColor: AC.slateSecondaryText,
              bodyColor: AC.blackText5,
            ),
          ),
          SizedBox(width: SC.sw(8)),
          Expanded(
            child: CardItem(
              backgroundColor: AC.yellowToolPanel,
              borderColor: AC.yellowToolPanel,
              iconAsset: 'assets/icons/weight.png',
              titleText: weightLabel,
              bodyText: petWeight.toString(),
              titleColor: AC.slateSecondaryText,
              bodyColor: AC.blackText5,
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final String iconAsset;
  final String bodyText;
  final String titleText;
  final Color bodyColor;
  final Color titleColor;

  const CardItem({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconAsset,
    required this.bodyText,
    required this.titleText,
    required this.bodyColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(SC.sw(8), SC.sh(8), SC.sw(8), SC.sh(8)),
      height: SC.sh(106),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SC.sw(46),
            height: SC.sh(46),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
              color: Colors.transparent,
            ),
            child: Center(
              child: Image.asset(
                iconAsset,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Text(
            titleText,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              height: 20 / 12,
              color: titleColor,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            bodyText,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              height: 24 / 16,
              color: bodyColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Color backgroundColor;
  final String iconAsset;
  final String bodyText;
  final String titleText;
  final Color bodyColor;
  final Color titleColor;

  const ListItem({
    super.key,
    required this.backgroundColor,
    required this.iconAsset,
    required this.bodyText,
    required this.titleText,
    required this.bodyColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: Center(child: Image.asset(iconAsset, width: 20, height: 20)),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 271,
            height: 44,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 105,
                  height: 44,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          titleText,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 22 / 14,
                            color: titleColor,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          bodyText,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 20 / 14,
                            color: bodyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareProfileButton extends StatelessWidget {
  const _ShareProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TapEffect(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: SC.sh(46),
        decoration: BoxDecoration(
          color: AC.greenChipBorder.withAlpha(26),
          border: Border.all(color: AC.greenChipBorder, width: SC.sh(1)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/qr.png',
              width: SC.smin(20),
              height: SC.smin(20),
            ),
            SizedBox(width: SC.sw(6)),
            Text(
              l10n.petProfileShareProfile,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(14),
                height: 20 / 14,
                color: AC.blackText3,
              ),
            ),
          ],
        ),
      ),
    );

    // return ActionButton(
    //   height: SC.sh(46),
    //   color: AC.greenChipBorder.withAlpha(26),
    //   borderColor: AC.greenChipBorder,
    //   leadingIcon: Image.asset('assets/icons/qr.png'),
    //   text: 'Chia sẻ hồ sơ',
    //   textColor: AC.blackText3,
    //   onTap: onTap,
    // );
  }
}

class _AppearanceDetailsSection extends StatelessWidget {
  const _AppearanceDetailsSection({
    required this.petAppearanceDetails,
    required this.title,
  });
  final String petAppearanceDetails;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 116,
      padding: EdgeInsets.zero,
      child: ExpandableTextContainer(title: title, body: petAppearanceDetails),
    );
  }
}

class _ImportantDatesSection extends StatelessWidget {
  const _ImportantDatesSection({
    required this.petBirthDay,
    required this.petAdoptedDay,
    required this.petAge,
    required this.l10n,
  });

  final String? petBirthDay;
  final String? petAdoptedDay;
  final int petAge;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 164,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImportantDatesHeader(title: l10n.petProfileImportantDatesTitle),
          const SizedBox(height: 16),
          _ImportantDatesContainer(
            petBirthday: petBirthDay,
            petAdoptedDay: petAdoptedDay,
            petAge: petAge,
            l10n: l10n,
          ),
        ],
      ),
    );
  }
}

class ImportantDatesHeader extends StatelessWidget {
  const ImportantDatesHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 24 / 16,
                color: AC.blackText5,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          // Nếu có icon hoặc widget bổ sung thì đặt ở đây
        ],
      ),
    );
  }
}

class _ImportantDatesContainer extends StatelessWidget {
  const _ImportantDatesContainer({
    required this.petBirthday,
    required this.petAdoptedDay,
    required this.petAge,
    required this.l10n,
  });

  final String? petBirthday;
  final String? petAdoptedDay;
  final int petAge;
  final AppLocalizations l10n;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImportantDatesCard(
            icon: 'assets/icons/birthday.png',
            title: l10n.petProfileBirthday,
            body: petBirthday != null
                ? DateFormatConfig.isoToLongDisplay(petBirthday!)
                : '',
            tail: l10n.petProfileAge(petAge + 1),
          ),
          SizedBox(height: SC.sh(16)),
          Divider(
            height: SC.sh(1),
            thickness: SC.sh(1),
            color: AC.greyLine2,
          ),
          SizedBox(height: SC.sh(16)),
          ImportantDatesCard(
            icon: 'assets/icons/adopted.png',
            title: l10n.petProfileAdopted,
            body: petAdoptedDay != null
                ? DateFormatConfig.isoToLongDisplay(petAdoptedDay!)
                : '',
          ),
          SizedBox(height: SC.sh(16)),
        ],
      ),
    );
  }
}

class ImportantDatesCard extends StatelessWidget {
  final String icon;
  final String title;
  final String body;
  final String? tail;

  const ImportantDatesCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.tail,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Frame
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(168, 216, 185, 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: AC.blackText3,
                  //   width: 1.2,
                  // ),
                  image: DecorationImage(
                    image: AssetImage(icon),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text Container
          Expanded(
            child: SizedBox(
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Column chứa body và title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        // width: 98,
                        height: 20,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 20 / 14,
                              color: AC.greyText5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        // width: 136,
                        height: 20,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            body,
                            style: const TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              height: 20 / 14,
                              color: AC.blackText5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    tail ?? '',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 20 / 14,
                      color: AC.blackText5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Nếu cần phần title phụ margin auto phải thêm widget khác
                  // Hoặc nếu bạn muốn text phải căn phải, có thể thêm
                  // Flexible hoặc SizedBox ở đây tùy ý
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RaisersSection extends StatelessWidget {
  const _RaisersSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 188,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Header
          SizedBox(
            width: double.infinity,
            height: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Expanded(
                  child: Text(
                    'Người chăm sóc',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 24 / 16,
                      color: AC.blackText5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cards Container
          SizedBox(
            width: double.infinity,
            height: 148,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Card Horizontal 1
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AC.greyLine2,
                            width: 0.7,
                          ),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/tan-nguyen.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text + Tab
                      Expanded(
                        child: Container(
                          height: 42,
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 225,
                                height: 20,
                                child: Text(
                                  'Tan Nguyen',
                                  style: TextStyle(
                                    // fontFamily: 'Noto Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    height: 20 / 14,
                                    color: AC.blackText5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 225,
                                height: 20,
                                child: Text(
                                  'tannn94@gmail.com',
                                  style: TextStyle(
                                    // fontFamily: 'Noto Sans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 20 / 14,
                                    color: AC.slateSecondaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Icon (rotated box)
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Card Horizontal 2
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AC.greyLine2,
                            width: 0.7,
                          ),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/linh-nguyen.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text + Tab
                      Expanded(
                        child: Container(
                          height: 42,
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                width: 225,
                                height: 20,
                                child: Text(
                                  'Linh Nguyen',
                                  style: TextStyle(
                                    // fontFamily: 'Noto Sans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    height: 20 / 14,
                                    color: AC.blackText5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 225,
                                height: 20,
                                child: Text(
                                  'linlin@gmail.com',
                                  style: TextStyle(
                                    // fontFamily: 'Noto Sans',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 20 / 14,
                                    color: AC.slateSecondaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Icon (rotated box)
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ],
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
