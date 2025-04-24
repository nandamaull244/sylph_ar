import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylph_ar/models/video_model.dart';
import 'package:sylph_ar/models/artworks_model.dart';
import 'package:sylph_ar/models/image_target_model.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  // Authentication
  Future<AuthResponse> login(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  static bool isLoggedIn() {
    return Supabase.instance.client.auth.currentSession != null;
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  Session? get currentSession => client.auth.currentSession;

  // Get user's image_targets
  Future<List<Map<String, dynamic>>> getImageTargets(String userId) async {
    final response = await client
        .from('image_targets')
        .select()
        .eq('user_id', userId)
        .order('created_at');

    return response;
  }

  // Get user's artworks (videos) with image targets
  Future<List<VideoModel>> getVideos(String userId) async {
    try {
      final response = await client
          .from('videos')
          .select('id, user_id, video_url')
          .eq('user_id', userId);

      final data = List<Map<String, dynamic>>.from(response);

      return data.map((item) => VideoModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal memuat artworks: $e');
    }
  }

  Future<List<ArtworkModel>> getArtworks(String userId) async {
    try {
      final response = await client
          .from('artworks')
          .select(
              'id, user_id, image_target_id, video_id, title, created_at, image_targets(id, image_url)')
          .eq('user_id', userId);

      final data = List<Map<String, dynamic>>.from(response);

      return data.map((item) => ArtworkModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Gagal memuat artworks: $e');
    }
  }

  // Upload video dan simpan ke tabel
  Future<bool> uploadAndSaveVideo({
    required String userId,
    required String imageId,
    required String filePath,
    required String fileName,
  }) async {
    final file = File(filePath);
    final storagePath = 'video/$userId/$fileName';

    try {
      // Upload ke Supabase Storage (bucket: media)
      await client.storage.from('media').upload(
            storagePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      // Ambil URL publik dari video
      final publicUrl = client.storage.from('media').getPublicUrl(storagePath);

      // Simpan ke tabel video
      final insertResponse = await client.from('video').insert({
        'user_id': userId,
        'image_target_id': imageId,
        'video_url': publicUrl,
      });

      print('Video berhasil disimpan: $insertResponse');
      return true;
    } on StorageException catch (e) {
      print('Gagal upload video: ${e.message}');
      return false;
    } catch (e) {
      print('Error lain: $e');
      return false;
    }
  }

  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  Future<List<ImageTargetModel>> getUserImageTargets(String userId) async {
    final List data =
        await client.from('image_targets').select().eq('user_id', userId);

    return data.map((e) => ImageTargetModel.fromJson(e)).toList();
  }
}
