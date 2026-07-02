import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_visibility_scope.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/screens/main/chat/chat_screen.dart';
import 'package:capcat_doca/screens/main/my_pets/sub_screens/pet_form/sheets/pet_form_3rd_sheet_auto.dart';
import 'package:capcat_doca/services/chat_conversation_remote_service.dart';
import 'package:capcat_doca/services/pet_service.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/navigation_utils.dart';
import 'package:capcat_doca/utils/toast_overlay.dart';
import 'package:capcat_doca/widgets/button/action_button.dart';
import 'package:capcat_doca/widgets/header/custom_app_header.dart';
import 'package:capcat_doca/widgets/layout/custom_scaffold.dart';
import 'package:capcat_doca/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPetPersonaScreen extends ConsumerStatefulWidget {
  const EditPetPersonaScreen({super.key, required this.petId});

  final String petId;

  @override
  ConsumerState<EditPetPersonaScreen> createState() =>
      _EditPetPersonaScreenState();
}

class _EditPetPersonaScreenState extends ConsumerState<EditPetPersonaScreen> {
  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.read(petFormDataProvider);

    final selfTerm = formState.petTerm?.trim() ?? '';
    if (selfTerm.isEmpty) {
      TO.show(context, l10n.petFormCallPetRequired);
      return;
    }

    final ownerTerm = formState.ownerTerm?.trim() ?? '';
    if (ownerTerm.isEmpty) {
      TO.show(context, l10n.petFormCallOwnerRequired);
      return;
    }

    final hobbies = List<String>.from(formState.hobby ?? const <String>[]);
    if (hobbies.isEmpty) {
      TO.show(context, l10n.petFormHobbyRequired);
      return;
    }

    final personaId = formState.personaTemplateId;
    if (personaId == null) {
      TO.show(context, l10n.petFormPersonaRequired2);
      return;
    }

    final form = PetFormData(
      id: widget.petId,
      petTerm: selfTerm,
      ownerTerm: ownerTerm,
      hobby: hobbies,
      personaTemplateId: personaId,
    );

    final serviceResponse = await PetService.createPetAiAgent(form);
    if (!mounted) return;

    if (serviceResponse.isSuccess) {
      debugPrint('CreatePetAiAgent: ${serviceResponse.data}');
      TO.show(context, l10n.petFormCreatePersonaSuccess);

      await ref
          .read(listPetDetailProvider.notifier)
          .updatePetFields(
            petId: widget.petId,
            personaTemplateId: personaId,
            selfTerm: selfTerm,
            ownerTerm: ownerTerm,
            hobby: hobbies,
          );

      final chatResponse =
          await ChatConversationRemoteService.startConversation(
            petId: widget.petId,
          );
      if (!mounted) return;

      if (chatResponse.isSuccess && chatResponse.data != null) {
        customCrossFadePush(
          context,
          ChatScreen(conversation: chatResponse.data!),
        );
      } else {
        final message = chatResponse.message ?? l10n.petProfileStartChatError;
        TO.show(context, message);
      }
    } else {
      debugPrint('Create pet AI agent failed: ${serviceResponse.message}');
      TO.show(
        context,
        (serviceResponse.message?.trim().isNotEmpty == true)
            ? serviceResponse.message!
            : l10n.petFormGenericError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AssistantVisibilityScope.hide(
      child: CustomScaffold(
        body: SafeAreaTopOnly(
          child: Column(
            children: [
              CustomAppHeader(
                title: AppLocalizations.of(context)!.petFormPersonaTitle,
                hasLeftAction: true,
                color: AC.white,
              ),
              Expanded(
                child: PetForm3rdSheetAuto(
                  actionButton: ActionButton(
                    text: AppLocalizations.of(context)!.petFormSave,
                    trailingIcon: Image.asset('assets/icons/ab-check.png'),
                    onTap: _handleSave,
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
