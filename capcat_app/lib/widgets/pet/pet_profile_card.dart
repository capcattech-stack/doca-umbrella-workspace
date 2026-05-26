import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/models/pet_detail.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/chat_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_form/edit_pet_persona_screen.dart';
import 'package:flutter_chat_mock_app/screens/main/my_pets/sub_screens/pet_profile/pet_profile_screen.dart';
import 'package:flutter_chat_mock_app/services/chat_conversation_remote_service.dart';
import 'package:flutter_chat_mock_app/utils/navigation_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';

class PetProfileCard extends StatelessWidget {
  const PetProfileCard({
    super.key,
    required this.pet,
    this.onPetUpdated,
    this.showChatButton = true,
  });

  final PetDetail pet;
  final ValueChanged<PetDetail>? onPetUpdated;
  final bool showChatButton;

  static final double _cardHeight = SC.sh(216);
  static final double _radius = SC.smin(24);
  static final double _imageHeight = SC.sh(160);
  static final double _imageRadius = SC.smin(16);

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PetProfileScreen(petId: pet.id)),
        );
        if (result is PetDetail && onPetUpdated != null) {
          onPetUpdated!(result);
        }
      },
      child: Container(
        width: double.infinity,
        height: _cardHeight,
        padding: EdgeInsets.fromLTRB(SC.sw(8), SC.sh(8), SC.sw(8), SC.sh(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: const [
            BoxShadow(
              color: AC.beigeCardShadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                RectangleCachedNetworkImage(
                  imageUrl: pet.avatarUrl,
                  width: double.infinity,
                  height: _imageHeight,
                  radius: _imageRadius,
                  subject: ImageSubject.pet,
                ),
                Positioned(
                  top: SC.sh(12),
                  right: SC.sw(12),
                  child: Container(
                    width: SC.smin(32),
                    height: SC.smin(32),
                    decoration: BoxDecoration(
                      color: _genderBadgeBackgroundColor(),
                      border: Border.all(color: _genderBadgeBorderColor()),
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(12, 26, 75, 0.04),
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(50, 50, 71, 0.02),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      _genderIconAsset(),
                      width: SC.smin(16),
                      height: SC.smin(16),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SC.sh(4)),
            SizedBox(
              width: double.infinity,
              height: SC.sh(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: SC.sw(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.breed.trim().isEmpty ? '--' : pet.breed.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: SC.sf(10),
                              height: 14 / 10,
                              color: AC.neutralPetCardText,
                            ),
                          ),
                          SizedBox(height: SC.sh(4)),
                          Text(
                            pet.name.trim().isEmpty ? '--' : pet.name.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: SC.sf(16),
                              height: 14 / 16,
                              color: AC.neutralPetCardText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (showChatButton)
                    TapEffect(
                      onTap: () => _handleChatTap(context),
                      child: SvgPicture.asset(
                        'assets/icons/pet-card-chat.svg',
                        width: SC.smin(32),
                        height: SC.smin(32),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _genderIconAsset() {
    return switch (pet.gender) {
      PetGender.male => 'assets/icons/male-simple.png',
      PetGender.female => 'assets/icons/female-simple.png',
      PetGender.other => 'assets/icons/female-simple.png',
    };
  }

  Color _genderBadgeBackgroundColor() {
    return switch (pet.gender) {
      PetGender.male => AC.blueGenderBg,
      PetGender.female => AC.pinkSelectedBg,
      PetGender.other => AC.pinkSelectedBg,
    };
  }

  Color _genderBadgeBorderColor() {
    return switch (pet.gender) {
      PetGender.male => AC.blueGenderBorder,
      PetGender.female => AC.pinkGenderAccent,
      PetGender.other => AC.pinkGenderAccent,
    };
  }

  Future<void> _handleChatTap(BuildContext context) async {
    final response = await ChatConversationRemoteService.startConversation(
      petId: pet.id,
    );
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (!response.isSuccess || response.data == null) {
      if (response.errorCode == 'AI_AGENT_INFO_NOT_FOUND') {
        customCrossFadePush(context, EditPetPersonaScreen(petId: pet.id));
        return;
      }
      final message = response.message ?? l10n.myPetsStartChatError;
      TO.show(context, message);
      return;
    }

    customCrossFadePush(context, ChatScreen(conversation: response.data!));
  }
}
