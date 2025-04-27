import 'package:flutter/material.dart';
import 'package:sylph_ar/page/home_screen.dart';
import 'package:sylph_ar/services/service_supabase.dart';
import 'package:sylph_ar/theme.dart';
import 'package:sylph_ar/widget/form_input.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Image.asset(
              'assets/logo_login.png',
              width: 450,
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: defaultMargin, left: defaultMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    "Selamat Datang di Sylph.art",
                    style: titleStyle,
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text(
                    "Login sebelum masuk ke aplikasi Sylph.art!",
                    style: mediumTextStyle,
                  )),
                  SizedBox(
                    height: 50,
                  ),
                  FormInput(
                    controller: emailController,
                    hintText: "email",
                    textInputType: TextInputType.text,
                    isPassword: false,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  FormInput(
                    controller: passController,
                    hintText: "Password",
                    textInputType: TextInputType.text,
                    isPassword: true,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: FloatingActionButton(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          splashColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passController.text.trim();

                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });

                            if (email.isEmpty || password.isEmpty) {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Email dan password tidak boleh kosong.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            try {
                              final supabaseService = SupabaseService();
                              final response =
                                  await supabaseService.login(email, password);

                              if (response.user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Login Gagal'),
                                    content: Text(
                                        'Periksa kembali email dan password.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Terjadi Kesalahan'),
                                  content: Text(
                                      'Terjadi kesalahan: ${e.toString()}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Login",
                            style: bigButtonTextStyle,
                          ),
                        ),
                      ),
                      if (isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
