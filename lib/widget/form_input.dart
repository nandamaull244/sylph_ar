import 'package:flutter/material.dart';
import 'package:sylph_ar/theme.dart';

class FormInput extends StatefulWidget {
  const FormInput(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.textInputType,
      required this.isPassword});
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final bool isPassword;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  bool _isObsecure = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white, // Pastikan warna sesuai
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1, color: textColor),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: widget.isPassword
              ? TextFormField(
                  controller: widget.controller,
                  obscureText: _isObsecure,
                  keyboardType: widget.textInputType,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: regularTextStyle.copyWith(fontSize: 18),
                    contentPadding: EdgeInsets.only(top: 12),
                    border: InputBorder.none,
                    prefixIcon:
                        Icon(Icons.lock_outline_rounded, color: textColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObsecure ? Icons.visibility_off : Icons.visibility,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObsecure = !_isObsecure;
                        });
                      },
                    ),
                  ),
                )
              : TextFormField(
                  controller: widget.controller,
                  obscureText: false,
                  keyboardType: widget.textInputType,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: regularTextStyle.copyWith(fontSize: 18),
                    contentPadding: EdgeInsets.only(top: 12),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person_outline, color: textColor),
                  ),
                )),
    );
  }
}
