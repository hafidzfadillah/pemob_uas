import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/core/viewmodels/user/user_provider.dart';
import 'package:pemob_uas/ui/auth/sign_up.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:pemob_uas/ui/parent_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final email = TextEditingController();
  final password = TextEditingController();

  var showPassword = false;

  Future<void> _handleLogin() async {
    try {
      if (email.text.isEmpty) {
        EasyLoading.showInfo('Email tidak boleh kosong');
        return;
      }
      if (password.text.isEmpty) {
        EasyLoading.showInfo('Password tidak boleh kosong');
        return;
      }

      var e = email.text;
      var p = password.text;

      EasyLoading.show();

      await UserProvider.instance(context).login(e, p);
      EasyLoading.dismiss();
      ProductProvider.instance(context).fetchProducts();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const ParentScreen()));
    } catch (e, s) {
      Logger().e(e);
      Logger().e(s);
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Topbar(
            title: 'Masuk',
            leading: MyBackButton(),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 5.h),
              children: [
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: SvgPicture.asset(
                    'assets/images/login.svg',
                    height: 30.h,
                    fit: BoxFit.contain,
                  ),
                ),
                const MyText(
                  'Email',
                  weight: FontWeight.w600,
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 2.h,
                ),
                const MyText(
                  'Password',
                  weight: FontWeight.w600,
                ),
                TextField(
                  controller: password,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder()),
                ),
                SizedBox(
                  height: 4.h,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      _handleLogin();
                    },
                    child: const MyText(
                      'Sign In',
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 2.h,
                ),
                Center(
                  child: RichText(
                      text: TextSpan(
                          text: 'Belum punya akun? ',
                          style: GoogleFonts.poppins(color: blackColor),
                          children: [
                        TextSpan(
                            text: 'Daftar',
                            style: GoogleFonts.poppins(
                                color: accentColor,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SignUp()));
                              })
                      ])),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
