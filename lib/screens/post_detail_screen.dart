// lib/screens/post_detail_screen.dart

import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../models/news_post/news_post_detail_dto.dart';
import 'post_form_screen.dart';

class PostDetailScreen extends StatefulWidget {
  /// Recibe el ID de la publicación a mostrar
  final int postId;
  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<NewsPostDetailDto> _futurePost;

  @override
  void initState() {
    super.initState();
    // Carga los datos de la publicación
    _futurePost = PostService().getPostById(widget.postId);
  }

  void _goToEdit(NewsPostDetailDto post) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostFormScreen(editPost: post),
      ),
    );
    if (result is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      setState(() {
        _futurePost = PostService().getPostById(widget.postId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Publicación'),
        actions: [
          FutureBuilder<NewsPostDetailDto>(
            future: _futurePost,
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done || snap.hasError) {
                return const SizedBox.shrink();
              }
              final post = snap.data!;
              return IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Editar',
                onPressed: () => _goToEdit(post),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<NewsPostDetailDto>(
        future: _futurePost,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final post = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen principal
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 64),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.place, size: 16),
                    const SizedBox(width: 4),
                    Text(post.location),
                    const Spacer(),
                    Text(
                      '\$${post.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  post.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.category, size: 16),
                    const SizedBox(width: 4),
                    Text(post.category.name.toUpperCase()),
                    const SizedBox(width: 24),
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${post.publishDate.day}/${post.publishDate.month}/${post.publishDate.year}',
                    ),
                  ],
                ),
                const Divider(height: 32),

                // Datos de contacto
                Text('Contacto:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16),
                    const SizedBox(width: 8),
                    Text(post.phoneNumber),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16),
                    const SizedBox(width: 8),
                    Text(post.email),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.whatsapp),
                  label: const Text('Chatear por WhatsApp'),
                  onPressed: () {
                    // Lógica para abrir post.whatsAppLink
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
