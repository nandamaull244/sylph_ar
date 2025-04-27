import 'dart:io';

import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylph_ar/models/image_target_model.dart';
import 'package:sylph_ar/services/service_supabase.dart';

class ArtworkUploadPage extends StatefulWidget {
  final ImageTargetModel imageTarget;

  const ArtworkUploadPage({required this.imageTarget, Key? key})
      : super(key: key);

  @override
  _ArtworkUploadPageState createState() => _ArtworkUploadPageState();
}

class _ArtworkUploadPageState extends State<ArtworkUploadPage> {
  File? _selectedVideo;
  String? _exportedVideoPath;
  bool _isProcessing = false;
  double _scale = 1.0;
  String _title = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit dan Upload Video'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _exportAndUpload,
          ),
        ],
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_selectedVideo == null)
                    ElevatedButton.icon(
                      onPressed: _pickVideo,
                      icon: const Icon(Icons.video_library),
                      label: const Text('Pilih Video'),
                    ),
                  if (_selectedVideo != null) ...[
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Judul Artwork",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _title = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text("Scale Video"),
                    Slider(
                      value: _scale,
                      min: 0.5,
                      max: 2.0,
                      onChanged: (value) {
                        setState(() {
                          _scale = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _processVideo,
                      icon: const Icon(Icons.playlist_add),
                      label: const Text('Proses Video'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
      });
    }
  }

  Future<void> _processVideo() async {
    if (_selectedVideo == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final appDir = await getTemporaryDirectory();
      final outputPath =
          '${appDir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // FFmpeg command
      final command = '''
      -i "${_selectedVideo!.path}" -i "${widget.imageTarget.imageUrl}" 
      -filter_complex "[1:v]scale=iw*$_scale:ih*$_scale[overlay];[0:v][overlay]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2"
      -preset ultrafast
      "$outputPath"
      ''';

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode) ?? false) {
        setState(() {
          _exportedVideoPath = outputPath;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video berhasil diproses!')),
        );
      } else {
        print("Gagal proses video: ${await session.getAllLogsAsString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memproses video.')),
        );
      }
    } catch (e) {
      print('Error saat proses video: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _exportAndUpload() async {
    if (_exportedVideoPath == null || _title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proses dulu videonya dan isi judul.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
      final success = await SupabaseService().uploadAndSaveVideo(
        userId: userId,
        imageId: widget.imageTarget.id,
        filePath: _exportedVideoPath!,
        fileName: 'video_${DateTime.now().millisecondsSinceEpoch}.mp4',
        title: _title,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload berhasil!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload gagal!')),
        );
      }
    } catch (e) {
      print('Error saat upload: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
