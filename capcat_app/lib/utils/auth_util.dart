import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_ui_controller.dart';
import 'package:flutter_chat_mock_app/providers/chat_pet_provider.dart';
import 'package:flutter_chat_mock_app/providers/conversation_messages_provider.dart';
import 'package:flutter_chat_mock_app/providers/firebase_auth_provider.dart';
import 'package:flutter_chat_mock_app/providers/forgot_password_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/list_pet_detail_provider.dart';
import 'package:flutter_chat_mock_app/providers/login_method_provider.dart';
import 'package:flutter_chat_mock_app/providers/loading_overlay_provider.dart';
import 'package:flutter_chat_mock_app/providers/main_navigation_provider.dart';
import 'package:flutter_chat_mock_app/providers/moments_provider.dart';
import 'package:flutter_chat_mock_app/providers/nanny_chat_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_breed_repository_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_breeds_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_form_providers.dart';
import 'package:flutter_chat_mock_app/providers/pet_hobbies_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_hobby_repository_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_persona_template_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_personalities_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/pet_species_repository_provider.dart';
import 'package:flutter_chat_mock_app/providers/phone_login_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/phone_register_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/socket_provider.dart';
import 'package:flutter_chat_mock_app/providers/social_register_data_provider.dart';
import 'package:flutter_chat_mock_app/providers/user_detail_provider.dart';
import 'package:flutter_chat_mock_app/providers/list_conversation_provider.dart';
import 'package:flutter_chat_mock_app/screens/entry/app_entry_point.dart';
import 'package:flutter_chat_mock_app/services/auth_service.dart';
import 'package:flutter_chat_mock_app/storage/conversation_list_local_storage.dart';
import 'package:flutter_chat_mock_app/storage/pet_breed_local_storage.dart';
import 'package:flutter_chat_mock_app/storage/pet_hobby_local_storage.dart';
import 'package:flutter_chat_mock_app/storage/pet_list_local_storage.dart';
import 'package:flutter_chat_mock_app/storage/pet_persona_template_local_storage.dart';
import 'package:flutter_chat_mock_app/storage/pet_species_local_storage.dart';
import 'package:flutter_chat_mock_app/storage/user_detail_local_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUtil {
  static Future<void> performLogout({
    required BuildContext context,
    WidgetRef? ref,
  }) async {
    debugPrint('➡️ AuthUtil.performLogout called');

    await AuthService.logoutAll();
    await _clearPersistentCaches();

    if (ref != null) {
      final cleanupTasks = <Future<void>>[];

      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(userDetailProvider.notifier).clear(),
        'userDetailProvider',
      );
      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(listPetDetailProvider.notifier).clear(),
        'listPetDetailProvider',
      );
      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(listConversationProvider.notifier).clear(),
        'listConversationProvider',
      );
      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(petSpeciesProvider.notifier).clear(),
        'petSpeciesProvider',
      );
      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(petBreedProvider.notifier).clear(),
        'petBreedProvider',
      );
      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(petHobbyProvider.notifier).clear(),
        'petHobbyProvider',
      );
      _enqueueCleanup(
        cleanupTasks,
        () => ref.read(petPersonaTemplateProvider.notifier).clear(),
        'petPersonaTemplateProvider',
      );

      try {
        ref.read(socketProvider.notifier).disconnect();
      } catch (e) {
        debugPrint('⚠️ Failed to disconnect socketProvider: $e');
      }

      if (cleanupTasks.isNotEmpty) {
        await Future.wait(cleanupTasks);
      }

      ref.invalidate(userDetailProvider);
      ref.invalidate(listPetDetailProvider);
      ref.invalidate(listConversationProvider);
      ref.invalidate(selectedPetIdProvider);
      ref.invalidate(petFormDataProvider);
      ref.invalidate(petAnalysisDoneProvider);
      ref.invalidate(petMasterDataReadyProvider);
      ref.invalidate(petSpeciesProvider);
      ref.invalidate(petBreedProvider);
      ref.invalidate(petHobbyProvider);
      ref.invalidate(petPersonaTemplateProvider);
      ref.invalidate(petBreedsProvider);
      ref.invalidate(petHobbiesProvider);
      ref.invalidate(petPersonalitiesProvider);
      ref.invalidate(momentsProvider);
      ref.invalidate(chatPetListProvider);
      ref.invalidate(nannyMessagesProvider);
      ref.invalidate(nannyPinnedMessagesProvider);
      ref.invalidate(nannyProfileProvider);
      ref.invalidate(nannyTypingProvider);
      ref.invalidate(nannyHasUserMessagedRecentlyProvider);
      ref.invalidate(nannyFocusMessageRequestProvider);
      ref.invalidate(nannySocketBridgeProvider);
      ref.invalidate(socketProvider);
      ref.invalidate(conversationMessagesProvider);
      ref.invalidate(assistantUiControllerProvider);
      ref.invalidate(phoneLoginDataProvider);
      ref.invalidate(phoneRegisterDataProvider);
      ref.invalidate(socialRegisterDataProvider);
      ref.invalidate(forgotPasswordDataProvider);
      ref.invalidate(loadingOverlayProvider);
      ref.invalidate(authProvider);
      ref.invalidate(loginMethodProvider);
    }
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AppEntryPoint()),
        (route) => false,
      );
      if (ref != null) {
        Future.microtask(() {
          try {
            ref.invalidate(mainNavigationIndexProvider);
          } catch (e) {
            debugPrint('⚠️ Failed to reset mainNavigationIndexProvider: $e');
          }
        });
      }
    }
  }

  static void _enqueueCleanup(
    List<Future<void>> tasks,
    Future<void> Function() action,
    String label,
  ) {
    try {
      tasks.add(action());
    } catch (e) {
      debugPrint('⚠️ Failed to clear $label: $e');
    }
  }

  static Future<void> _clearPersistentCaches() async {
    final tasks = <Future<void>>[
      _safeClear(
        () => UserDetailLocalStorage().clear(),
        'UserDetailLocalStorage',
      ),
      _safeClear(() => PetListLocalStorage().clear(), 'PetListLocalStorage'),
      _safeClear(
        () => ConversationListLocalStorage().clear(),
        'ConversationListLocalStorage',
      ),
      _safeClear(() => PetBreedLocalStorage().clear(), 'PetBreedLocalStorage'),
      _safeClear(() => PetHobbyLocalStorage().clear(), 'PetHobbyLocalStorage'),
      _safeClear(
        () => PetSpeciesLocalStorage().clear(),
        'PetSpeciesLocalStorage',
      ),
      _safeClear(
        () => PetPersonaTemplateLocalStorage().clear(),
        'PetPersonaTemplateLocalStorage',
      ),
      _safeClear(_clearImageCaches, 'ImageCaches'),
    ];

    await Future.wait(tasks);
  }

  static Future<void> _safeClear(
    Future<void> Function() clearFn,
    String label,
  ) async {
    try {
      await clearFn();
    } catch (e) {
      debugPrint('⚠️ Failed to clear $label: $e');
    }
  }

  static Future<void> _clearImageCaches() async {
    // Clear disk cache managed by cached_network_image/flutter_cache_manager.
    await DefaultCacheManager().emptyCache();

    // Clear in-memory decoded image cache.
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
