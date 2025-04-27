import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'page/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zqwvmdjwuaeolmdswpvp.supabase.co', // ganti dengan milikmu
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpxd3ZtZGp3dWFlb2xtZHN3cHZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM4NTQ1NTQsImV4cCI6MjA1OTQzMDU1NH0.XRzY61iEm5giR4Cn4ziEinn5OSeL31VUPYgYostPuv4', // dari Supabase > Project Settings > API
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Color.fromARGB(0, 255, 255, 255), // Make status bar transparent
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false, // Remove debug banner
        home: const SplashScreen(),
      );
    });
  }
}
