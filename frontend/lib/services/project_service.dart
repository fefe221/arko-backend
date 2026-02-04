import 'package:dio/dio.dart';
import 'package:frontend/services/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class ProjectService {
  final ApiClient _api = ApiClient();


  Future<List<dynamic>> getProjects() async {
    try {
      final response = await _api.dio.get('/admin/projects');
      return response.data;
    } catch (e) { return []; }
  }



  Future<void> createProject({
    required String title,
    required String description,
    required String location,
    required String category,
    required List<XFile> images, // Alterado para List
  }) async {
    List<MultipartFile> imageFiles = [];
    for (var img in images) {
      final bytes = await img.readAsBytes();
      imageFiles.add(MultipartFile.fromBytes(
        bytes,
        filename: img.name,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    FormData formData = FormData.fromMap({
      "title": title,
      "description": description,
      "location": location,
      "category": category,
      "images": imageFiles, // Plural para o Go reconhecer
    });

    await _api.dio.post('/admin/projects', data: formData);
  }
  
  // Mude de 'int id' para 'dynamic id'
  Future<void> deleteProject(dynamic id) async {
    try {
      // Forçamos a conversão para String para garantir que a URL seja montada corretamente
      final String idStr = id.toString();
      await _api.dio.delete('/admin/projects/$idStr');
    } catch (e) {
      print("Erro ao excluir: $e");
      rethrow;
    }
  }

}
