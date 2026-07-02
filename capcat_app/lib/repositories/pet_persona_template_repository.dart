import 'package:capcat_doca/models/pet_persona_template_master_data.dart';
import 'package:capcat_doca/services/pet_persona_template_remote_service.dart';
import 'package:capcat_doca/storage/pet_persona_template_local_storage.dart';

class PetPersonaTemplateRepository {
  final PetPersonaTemplateLocalStorage local;

  PetPersonaTemplateRepository({required this.local});

  /// Lấy danh sách từ local, nếu chưa có thì tải từ remote
  Future<List<PetPersonaTemplateMasterData>> getAll() async {
    final localData = await local.read();
    if (localData != null && localData.isNotEmpty) {
      return localData;
    }
    return await refreshRemote();
  }

  //--Request from server and save to local
  Future<List<PetPersonaTemplateMasterData>> refreshRemote() async {
    final list = await PetPersonaTemplateRemoteService.getAll();
    await local.save(list);
    return list;
  }

  //--Clear cache
  Future<void> clear() async {
    await local.clear();
  }
}
