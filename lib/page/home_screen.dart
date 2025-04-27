import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sylph_ar/auth/login.dart';
import 'package:sylph_ar/models/video_model.dart';
import 'package:sylph_ar/models/artworks_model.dart';
import 'package:sylph_ar/models/image_target_model.dart';
import 'package:sylph_ar/page/artwork_upload.dart';
import 'package:sylph_ar/page/scan_page.dart';

import 'package:sylph_ar/services/service_supabase.dart';
import 'package:sylph_ar/services/session_service.dart';
import 'package:sylph_ar/widget/build_menu_card.dart';
import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ArtworkModel> artworks = [];
  List<ImageTargetModel> imageTargets = [];
  List<VideoModel> videos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> logout(BuildContext context) async {
    try {
      // 1. Sign out dari Supabase
      await Supabase.instance.client.auth.signOut();

      // 2. Hapus session lokal
      await SessionService.clearSession();

      // 3. Navigasi kembali ke LoginScreen,
      //    menggantikan seluruh history (so user gak bisa back)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Kalau ada error, tampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal logout: $e')),
      );
    }
  }

  Future<void> _fetchData() async {
    final userId = SupabaseService().client.auth.currentUser!.id;
    print("current user data: $userId");

    final imgTargetData = await SupabaseService().getImageTargets(userId);
    final artworkData = await SupabaseService().getArtworks(userId);
    final videoData = await SupabaseService().getVideos(userId);

    print("image target data: $imgTargetData");

    setState(() {
      imageTargets =
          imgTargetData.map((data) => ImageTargetModel.fromJson(data)).toList();
      artworks = artworkData;
      videos = videoData;
    });
  }

  Future<void> _showImageTargetDialog() async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          if (imageTargets.isEmpty) {
            return Center(
              child: Text(
                "Belum ada image target yang tersedia.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Pilih image target',
                style: titleStyle,
              ),
              SizedBox(height: 16),
              Container(
                height: 300,
                padding: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: imageTargets.length,
                  itemBuilder: (context, index) {
                    final target = imageTargets[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          target.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image),
                        ),
                      ),
                      title: Text(target.name),
                      subtitle: Text(
                        '${target.createdAt != null ? DateTime.parse(target.createdAt!).day : 'N/A'}-${target.createdAt != null ? DateTime.parse(target.createdAt!).month : 'N/A'}-${target.createdAt != null ? DateTime.parse(target.createdAt!).year : 'N/A'}',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtworkUploadPage(
                              imageTarget: target,
                            ),
                          ),
                        ).then((_) => _fetchData());
                      },
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: defaultMargin),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                  children: [
                    Image.asset('assets/logo_home.png'),
                    SizedBox(height: 60),
                    // Scan Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScanPage()),
                        );
                      },
                      child: MenuCard(
                        title: 'Scan artwork',
                        subtitle:
                            'Scan your AR result and \npoint it at the photo frame',
                        imagePath: 'assets/scan-picture.png',
                        backgroundColor: addColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Create Artwork Button
                    GestureDetector(
                      onTap: _showImageTargetDialog,
                      child: MenuCard(
                        title: 'Create new artwork',
                        subtitle:
                            'Create a new AR masterpiece \nby adding your video',
                        imagePath: 'assets/add-picture.png',
                        backgroundColor: secondaryColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Your artwork', style: semiBoldTextStyle),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        if (artworks.isEmpty)
                          Center(
                            child: Text(
                              'Kamu belum memiliki artwork',
                              style: boldTextStylePink,
                            ),
                          )
                        else
                          ...artworks.map((artwork) {
                            final imageTarget = imageTargets.firstWhere(
                                (img) => img.id == artwork.imageTargetId,
                                orElse: () => ImageTargetModel(
                                    id: '',
                                    userId: '',
                                    name: 'Unknown',
                                    imageUrl: ''));
                            return _buildArtworkCard(artwork, imageTarget);
                          }).toList()
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtworkCard(ArtworkModel artwork, ImageTargetModel imageTarget) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: secondaryColor,
      ),
      child: Row(
        children: [
          Image.network(imageTarget.imageUrl, width: 150, fit: BoxFit.cover),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Artwork from: ${imageTarget.name}',
                      style: semiBoldTextStyle18),
                  Text(
                    'Video URL:\n${videos.firstWhere((v) => v.id == artwork.videoId, orElse: () => VideoModel(id: '', userId: '', videoUrl: '', imageTargetId: '')).videoUrl}',
                    style: regularTextStylePink,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtworkUploadPage(
                            imageTarget: imageTarget,
                          ),
                        ),
                      ).then((_) => _fetchData());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Edit', style: semiBoldTextStyle16white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
