import 'package:flutter/material.dart';
import 'package:frontend/services/project_service.dart';

class AmbienteProjectsView extends StatelessWidget {
  const AmbienteProjectsView({
    super.key,
    required this.category,
  });

  final String category;
  static const String _baseUrl = 'http://localhost:8080';

  @override
  Widget build(BuildContext context) {
    final service = ProjectService();
    final displayTitle = _displayCategory(category);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: FutureBuilder<List<dynamic>>(
            future: service.getPublicProjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final projects = (snapshot.data ?? [])
                  .where((p) =>
                      (p['category'] ?? '')
                          .toString()
                          .toLowerCase()
                          .trim() ==
                      category.toLowerCase().trim())
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "/ $displayTitle",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: projects.isEmpty
                        ? const Center(
                            child: Text("Nenhum projeto nesta categoria."),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              final crossAxisCount = width < 620
                                  ? 2
                                  : width < 980
                                      ? 3
                                      : 4;
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: projects.length,
                                itemBuilder: (context, index) {
                                  final p = projects[index];
                                  final coverUrl = _resolveCoverUrl(p);
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProjectGalleryView(project: p),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCD7CC),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: coverUrl == null
                                                ? const Center(
                                                    child: Icon(Icons.photo),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(16),
                                                    child: Image.network(
                                                      coverUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (context, error, stackTrace) {
                                                        return const Center(
                                                          child: Icon(Icons.photo),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          p['title'] ?? 'Projeto',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _displayCategory(String category) {
    switch (category.toLowerCase().trim()) {
      case 'cozinha':
        return 'Cozinhas';
      case 'dormitório':
        return 'Dormitórios';
      case 'closet':
        return 'Closets';
      default:
        return category;
    }
  }

  String? _resolveCoverUrl(dynamic project) {
    final images = project is Map ? project['images'] : null;
    if (images is List && images.isNotEmpty) {
      final first = images.first;
      final url = first is Map ? first['url']?.toString() : null;
      if (url == null || url.isEmpty) return null;
      if (url.startsWith('http://') || url.startsWith('https://')) return url;
      return '$_baseUrl$url';
    }
    return null;
  }
}

class ProjectGalleryView extends StatefulWidget {
  const ProjectGalleryView({super.key, required this.project});

  final dynamic project;

  @override
  State<ProjectGalleryView> createState() => _ProjectGalleryViewState();
}

class _ProjectGalleryViewState extends State<ProjectGalleryView> {
  static const String _baseUrl = 'http://localhost:8080';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = (widget.project is Map ? widget.project['images'] : null) as List? ?? [];
    final selectedUrl = _resolveUrl(images.isNotEmpty ? images[_selectedIndex] : null);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.project['title'] ?? 'Projeto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCD7CC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: selectedUrl == null
                    ? const Center(child: Icon(Icons.photo))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          selectedUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.photo));
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width < 520
                        ? 3
                        : width < 900
                            ? 4
                            : 5;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final thumbUrl = _resolveUrl(images[index]);
                        return GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: index == _selectedIndex
                                    ? const Color(0xFF686868)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: thumbUrl == null
                                ? const Center(child: Icon(Icons.photo))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      thumbUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(child: Icon(Icons.photo));
                                      },
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
        ),
      ),
    );
  }

  String? _resolveUrl(dynamic image) {
    if (image is Map) {
      final url = image['url']?.toString();
      if (url == null || url.isEmpty) return null;
      if (url.startsWith('http://') || url.startsWith('https://')) return url;
      return '$_baseUrl$url';
    }
    return null;
  }
}
