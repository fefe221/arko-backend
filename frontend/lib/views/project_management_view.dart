import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/project_service.dart';
import 'package:frontend/services/api_client.dart';

class ProjectsManagementView extends StatefulWidget {
  const ProjectsManagementView({super.key});

  @override
  State<ProjectsManagementView> createState() => _ProjectsManagementViewState();
}

class _ProjectsManagementViewState extends State<ProjectsManagementView> {
  final ProjectService _service = ProjectService();
  late Future<List<dynamic>> _projectsFuture;

  // Controladores para o formulário
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locController = TextEditingController();
  final _catController = TextEditingController();
  List<XFile> _selectedImages = [];
  static String _baseUrl() => ApiClient.resolveBaseUrl();
  bool _isUploading = false;
  static const List<String> _categories = [
    "Cozinha",
    "Dormitório",
    "Ambientes Integrados",
    "Office e Corporativo",
    "Living",
    "Closet",
    "Salas de Banho",
  ];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _projectsFuture = _service.getProjects();
    });
  }

  // Função para selecionar múltiplas imagens
  Future<void> _pickImages(StateSetter setModalState) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setModalState(() {
        _selectedImages = images;
      });
    }
  }

  void _showAddModal(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showDialog(
      context: rootContext,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => WillPopScope(
          onWillPop: () async => !_isUploading,
          child: AlertDialog(
            title: const Text("Novo Projeto"),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Título"),
                  ),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: "Descrição"),
                  ),
                  TextField(
                    controller: _locController,
                    decoration: const InputDecoration(labelText: "Localização (Cidade/UF)"),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: "Categoria"),
                    items: _categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setModalState(() {
                        _selectedCategory = value;
                        _catController.text = value ?? "";
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : () => _pickImages(setModalState),
                    icon: const Icon(Icons.image),
                    label: Text(_selectedImages.isEmpty
                        ? "Selecionar Imagens"
                        : "${_selectedImages.length} Selecionadas"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
                  ),
                  if (_isUploading) ...[
                    const SizedBox(height: 16),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isUploading
                  ? null
                  : () {
                _selectedImages = [];
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                if (_titleController.text.isEmpty || _selectedCategory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Preencha título e categoria")),
                  );
                  return;
                }
                setModalState(() => _isUploading = true);
                try {
                  await _service.createProject(
                    title: _titleController.text,
                    description: _descController.text,
                    location: _locController.text,
                    category: _selectedCategory ?? "",
                    images: _selectedImages,
                  );
                  
                  // Limpar campos e fechar
                  _titleController.clear();
                  _descController.clear();
                  _locController.clear();
                  _catController.clear();
                  _selectedCategory = null;
                  _selectedImages = [];
                  
                  if (context.mounted) Navigator.pop(context);
                  _refresh();
                } catch (e) {
                  print("Erro ao criar projeto: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Erro ao salvar projeto")),
                  );
                } finally {
                  if (context.mounted) {
                    setModalState(() => _isUploading = false);
                  }
                }
              },
              child: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("SALVAR", style: TextStyle(color: Colors.white)),
            ),
          ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteProject(dynamic projectId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Projeto"),
        content: Text("Deseja realmente remover $title?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _service.deleteProject(projectId);
                if (!mounted) return;
                Navigator.pop(context);
                _refresh();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao deletar projeto"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String? _resolveCoverUrl(dynamic project) {
    final images = project is Map ? project['images'] : null;
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      final url = first is Map ? first['url']?.toString() : null;
      if (url == null || url.isEmpty) return null;
      if (url.startsWith('http://') || url.startsWith('https://')) return url;
      return '${_baseUrl()}$url';
    }
    return null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locController.dispose();
    _catController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Meus Projetos",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _projectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: Text("Erro ao carregar projetos"));
                  }

                  final projects = snapshot.data!;
                  if (projects.isEmpty) {
                    return const Center(child: Text("Nenhum projeto cadastrado"));
                  }

                  return ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final p = projects[index];
                      final coverUrl = _resolveCoverUrl(p);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: coverUrl == null
                                ? Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child:
                                        const Icon(Icons.photo, color: Colors.grey),
                                  )
                                : Image.network(
                                    coverUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 56,
                                        height: 56,
                                        color: Colors.grey[200],
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.photo, color: Colors.grey),
                                      );
                                    },
                                  ),
                          ),
                          title: Text(
                            p['title'] ?? 'Sem título',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(p['description'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _confirmDeleteProject(
                              p['id'],
                              p['title'] ?? 'este projeto',
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: FloatingActionButton(
            onPressed: () => _showAddModal(context),
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
