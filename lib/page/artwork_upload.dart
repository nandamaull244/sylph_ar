import 'package:flutter/material.dart';
import 'package:sylph_ar/models/artworks_model.dart';
import 'package:sylph_ar/models/image_target_model.dart';

class ArtworkUploadPage extends StatefulWidget {
  const ArtworkUploadPage(
      {super.key,
      required ImageTargetModel imageTarget,
      ArtworkModel? artwork});

  @override
  State<ArtworkUploadPage> createState() => _ArtworkUploadPageState();
}

class _ArtworkUploadPageState extends State<ArtworkUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
