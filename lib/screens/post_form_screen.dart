// lib/screens/post_form_screen.dart

import 'package:flutter/material.dart';
import '../models/news_post/news_post_detail_dto.dart';

class PostFormScreen extends StatelessWidget {
  final NewsPostDetailDto editPost;

  const PostFormScreen({super.key, required this.editPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar publicación')),
      body: Center(child: Text('Aquí va el formulario para editar')),
    );
  }
}