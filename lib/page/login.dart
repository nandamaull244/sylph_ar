import 'package:flutter/material.dart';
import 'package:sylph_ar/splash_screen.dart';
import 'package:sylph_ar/theme.dart';
import 'package:sylph_ar/widget/form_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                height: 100,
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
                      height: 116,
                    ),
                    Center(
                        child: Text(
                      "Selamat Datang\n       di Hoozori",
                      style: titleStyle.copyWith(fontSize: 24),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      "Login sebelum masuk ke aplikasi Hoozori!",
                      style: mediumTextStyle,
                    )),
                    SizedBox(
                      height: 50,
                    ),
                    FormInput(
                      controller: usernameController,
                      hintText: "Username",
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
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor,
                      ),
                      child: FloatingActionButton(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () {
                          MaterialPageRoute(
                              builder: (context) => SplashScreen());
                        },
                        child: Text(
                          "Login",
                          style: bigButtonTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor,
                      ),
                      child: FloatingActionButton(
                          backgroundColor: addColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.fingerprint,
                                color: whiteColor,
                              ),
                              Text(
                                "Gunakan Sidik Jari",
                                style: smallButtonTextStyle,
                              ),
                              SizedBox(width: 27),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
