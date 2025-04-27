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
  // Future<bool> uploadAndSaveVideo({
  //   required String userId,
  //   required String imageId,
  //   required String filePath,
  //   required String fileName,
  //   required String title,
  //   void Function(double progress)? onProgress,
  // }) async {
  //   final file = File(filePath);
  //   final fileBytes = await file.readAsBytes();

  //   final storagePath = 'video/$userId/$fileName';

  //   try {
  //     // Upload ke Supabase Storage (bucket: media)
  //     final upload = client.storage.from('media').uploadBinary(
  //           storagePath,
  //           fileBytes,
  //           fileOptions: const FileOptions(upsert: true),
  //         );

  //     final response = await upload;

  //     if (response == null) {
  //       print('Upload gagal');
  //       return false;
  //     }

  //     // Ambil public URL
  //     final publicUrl = client.storage.from('media').getPublicUrl(storagePath);

  //     // Insert ke tabel video
  //     final videoInsert = await client
  //         .from('video')
  //         .insert({
  //           'user_id': userId,
  //           'image_target_id': imageId,
  //           'video_url': publicUrl,
  //         })
  //         .select('id')
  //         .single(); // Supaya dapet id video yg baru dibuat

  //     final videoId = videoInsert['id'];

  //     if (videoId == null) {
  //       print('Gagal insert video');
  //       return false;
  //     }

  //     // Insert ke tabel artwork
  //     final artworkInsert = await client.from('artwork').insert({
  //       'user_id': userId,
  //       'image_target_id': imageId,
  //       'video_id': videoId,
  //       'title': title,
  //       'created_at': DateTime.now().toUtc().toIso8601String(),
  //     });

  //     final artworkId = artworkInsert['id'];
  //     if (artworkId == null) {
  //       print('Gagal insert artwork');
  //       return false;
  //     }

  //     print('Video dan Artwork berhasil disimpan');
  //     return true;
  //   } on StorageException catch (e) {
  //     print('Gagal upload video: ${e.message}');
  //     return false;
  //   } catch (e) {
  //     print('Error lain: $e');
  //     return false;
  //   }
  // }

  Future<bool> uploadAndSaveVideo({
    required String userId,
    required String imageId,
    required String filePath,
    required String fileName,
    void Function(double progress)? onProgress,
    required String title,
  }) async {
    final file = File(filePath);
    final fileBytes = await file.readAsBytes();
    final storagePath = 'video/$userId/$fileName';

    try {
      final upload = client.storage.from('media').uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final response = await upload;
      final publicUrl = client.storage.from('media').getPublicUrl(storagePath);

      // Simpan ke tabel video
      final videoInsert = await client
          .from('video')
          .insert({
            'user_id': userId,
            'image_target_id': imageId,
            'video_url': publicUrl,
          })
          .select()
          .single();

      final videoId = videoInsert['id'];
      if (videoId == null) {
        print('Gagal insert video');
        return false;
      }
      // Simpan ke tabel artwork
      final artworkInsert = await client.from('artwork').insert({
        'user_id': userId,
        'image_target_id': imageId,
        'title': title,
      });
      print('Artwork berhasil disimpan: $response');
      final artworkId = artworkInsert['id'];
      if (artworkId == null) {
        print('Gagal insert artwork');
        return false;
      }

      print('Video & Artwork berhasil disimpan.');
      return true;
    } on StorageException catch (e) {
      print('Gagal upload video: ${e.message}');
      return false;
    } catch (e) {
      print('Error lain: $e');
      return false;
    }
  }

  Future<void> createArtwork(
    String userId,
    String imageTargetId,
    String videoUrl,
  ) async {
    final response = await client.from('artworks').insert({
      'user_id': userId,
      'image_target_id': imageTargetId,
      'video_url': videoUrl,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (response != null && response.error != null) {
      throw Exception('Gagal membuat artwork: ${response.error!.message}');
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

  Future<void> updateArtwork(String artworkId, String videoUrl) async {
    await client.from('artworks').update({
      'video_url': videoUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', artworkId);
  }

  Future<String?> uploadVideoFile(File file) async {
    final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final res = await client.storage.from('videos').upload(fileName, file);
    if (res != null) {
      final publicUrl = client.storage.from('videos').getPublicUrl(fileName);
      return publicUrl;
    }
    return null;
  }
}
