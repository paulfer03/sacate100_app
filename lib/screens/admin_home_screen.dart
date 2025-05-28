// lib/screens/admin_home_screen.dart

import 'package:flutter/material.dart';
import '../models/news_post/news_post_dto.dart';
import '../models/news_post/news_post_create_dto.dart';
import '../models/enums/category_type.dart';
import '../services/post_service.dart';
import 'user_profile_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final PostService _postService = PostService();
  late Future<List<NewsPostDto>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _futurePosts = _postService.getAllPosts();
    });
  }

  Future<void> _showPostForm({NewsPostDto? existing}) async {
    final titleCtrl = TextEditingController(text: existing?.title);
    final priceCtrl = TextEditingController(text: existing?.price.toString());
    final locationCtrl = TextEditingController(text: existing?.location);
    final descriptionCtrl = TextEditingController(text: existing?.description);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Nueva Publicación' : 'Editar Publicación'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Título')),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),
              TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'Ubicación')),
              TextField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final dto = NewsPostCreateDto(
                title: titleCtrl.text.trim(),
                price: double.tryParse(priceCtrl.text) ?? 0,
                location: locationCtrl.text.trim(),
                description: descriptionCtrl.text.trim(),
                phoneNumber: existing?.phoneNumber ?? '',
                email: existing?.email ?? '',
                whatsAppLink: existing?.whatsAppLink ?? '',
                imageUrl: existing?.imageUrl ?? '',
                category: existing?.category is CategoryType ? existing!.category as CategoryType : CategoryType.others,
              );
              try {
                if (existing == null) {
                  await _postService.createPost(dto);
                } else {
                  await _postService.updatePost(existing.id, dto);
                }
                if (!context.mounted) return;
                Navigator.pop(ctx, true);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (saved == true) _loadPosts();
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: const Text('¿Estás seguro de eliminar esta publicación?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await _postService.deletePost(id);
        if (success) _loadPosts();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildPostTile(NewsPostDto post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.location),
        onTap: () {
          // Navegar a detalle si lo deseas
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), tooltip: 'Editar', onPressed: () => _showPostForm(existing: post)),
            IconButton(icon: const Icon(Icons.delete), tooltip: 'Eliminar', onPressed: () => _confirmDelete(post.id)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserProfileScreen()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<NewsPostDto>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text('No hay publicaciones.'));
          }
          return ListView(children: posts.map(_buildPostTile).toList());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostForm(),
        tooltip: 'Nueva Publicación',
        child: const Icon(Icons.add),
      ),
    );
  }
}
