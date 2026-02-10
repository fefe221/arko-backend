import 'package:frontend/services/api_client.dart';

class LeadService {
  final ApiClient _api = ApiClient();

  Future<void> submitLead({
    required String name,
    required String email,
    required String phone,
    required String source,
    String message = "",
  }) async {
    await _api.dio.post(
      '/leads',
      data: {
        "name": name,
        "email": email,
        "phone": phone,
        "source": source,
        "message": message,
      },
    );
  }

  Future<List<dynamic>> getLeads() async {
    final response = await _api.dio.get('/admin/leads');
    return response.data;
  }

  Future<void> updateLeadStatus(int id, String status) async {
    await _api.dio.patch('/admin/leads/$id/status', data: {"status": status});
  }
}
