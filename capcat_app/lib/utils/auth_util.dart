import 'package:flutter/material.dart';
import 'package:capcat_doca/assistant/assistant_ui_controller.dart';
import 'package:capcat_doca/providers/chat_pet_provider.dart';
import 'package:capcat_doca/providers/conversation_messages_provider.dart';
import 'package:capcat_doca/providers/firebase_auth_provider.dart';
import 'package:capcat_doca/providers/forgot_password_data_provider.dart';
import 'package:capcat_doca/providers/list_pet_detail_provider.dart';
import 'package:capcat_doca/providers/login_method_provider.dart';
import 'package:capcat_doca/providers/loading_overlay_provider.dart';
import 'package:capcat_doca/providers/main_navigation_provider.dart';
import 'package:capcat_doca/providers/moments_provider.dart';
import 'package:capcat_doca/providers/nanny_chat_provider.dart';
import 'package:capcat_doca/providers/pet_breed_repository_provider.dart';
import 'package:capcat_doca/providers/pet_breeds_data_provider.dart';
import 'package:capcat_doca/providers/pet_form_providers.dart';
import 'package:capcat_doca/providers/pet_hobbies_data_provider.dart';
import 'package:capcat_doca/providers/pet_hobby_repository_provider.dart';
import 'package:capcat_doca/providers/pet_persona_template_provider.dart';
import 'package:capcat_doca/providers/pet_personalities_data_provider.dart';
import 'package:capcat_doca/providers/pet_species_repository_provider.dart';
import 'package:capcat_doca/providers/phone_login_data_provider.dart';
import 'package:capcat_doca/providers/phone_register_data_provider.dart';
import 'package:capcat_doca/providers/socket_provider.dart';
import 'package:capcat_doca/providers/social_register_data_provider.dart';
import 'package:capcat_doca/providers/user_detail_provider.dart';
import 'package:capcat_doca/providers/list_conversation_provider.dart';
import 'package:capcat_doca/screens/entry/app_entry_point.dart';
import 'package:capcat_doca/services/auth_service.dart';
import 'package:capcat_doca/services/model/service_response.dart';
import 'package:capcat_doca/storage/conversation_list_local_storage.dart';
import 'package:capcat_doca/storage/pet_breed_local_storage.dart';
import 'package:capcat_doca/storage/pet_hobby_local_storage.dart';
import 'package:capcat_doca/storage/pet_list_local_storage.dart';
import 'package:capcat_doca/storage/pet_persona_template_local_storage.dart';
import 'package:capcat_doca/storage/pet_species_local_storage.dart';
import 'package:capcat_doca/storage/user_detail_local_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthUtil {
  static bool _isLoggingOut = false;

  static Future<void> performLogout({
    required BuildContext context,
    WidgetRef? ref,
  }) async {
    if (_isLoggingOut) {
      debugPrint(
        '⏭️ AuthUtil.performLogout skipped because logout is already in progress',
      );
      return;
    }

    _isLoggingOut = true;
    debugPrint('➡️ AuthUtil.performLogout called');

    try {
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
    } finally {
      _isLoggingOut = false;
    }
  }

  static bool get isLogoutInProgress => _isLoggingOut;

  static bool isSessionInvalidMessage(String? message) {
    final normalized = message?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return false;

    return normalized.contains('phiên đăng nhập đã hết hạn') ||
        normalized.contains('phiên đăng nhập mất hiệu lực') ||
        normalized.contains('bạn chưa đăng nhập') ||
        normalized.contains('unauthorized') ||
        normalized.contains('token expired') ||
        normalized.contains('session expired');
  }

  static bool isSessionInvalidResponse(ServiceResponse<dynamic>? response) {
    if (response == null) return false;
    return isSessionInvalidMessage(response.message);
  }

  static Future<bool> handleSessionInvalidIfNeeded({
    required BuildContext context,
    required WidgetRef ref,
    ServiceResponse<dynamic>? response,
    String? message,
  }) async {
    final shouldLogout =
        isSessionInvalidResponse(response) || isSessionInvalidMessage(message);
    if (!shouldLogout) return false;

    await performLogout(context: context, ref: ref);
    return true;
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
