import 'package:capcat_doca/models/nanny_profile.dart';
import 'package:capcat_doca/services/nanny_profile_remote_service.dart';

class NannyProfileRepository {
  Future<NannyProfile> fetchNannyProfile() async {
    final response = await NannyProfileRemoteService.startNanny();
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    throw Exception(response.message ?? 'Không tải được thông tin bảo mẫu');
  }
}
