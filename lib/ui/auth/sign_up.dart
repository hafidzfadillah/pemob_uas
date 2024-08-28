import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/core/viewmodels/user/user_provider.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  var showPassword = false;

  Future<void> _handleDaftar() async {
    try {
      if (name.text.isEmpty) {
        EasyLoading.showInfo('Nama tidak boleh kosong');
        return;
      }
      if (email.text.isEmpty) {
        EasyLoading.showInfo('Email tidak boleh kosong');
        return;
      }
      if (password.text.isEmpty) {
        EasyLoading.showInfo('Password tidak boleh kosong');
        return;
      }

      var n = name.text;
      var e = email.text;
      var p = password.text;

      EasyLoading.show();

      final result = await UserProvider.instance(context).register(n, e, p);
      EasyLoading.showInfo(result);
      ProductProvider.instance(context).fetchProducts();
      Navigator.pop(
        context,
      );
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
            title: 'Daftar',
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
                  'Nama',
                  weight: FontWeight.w600,
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Nama',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 2.h,
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
                      _handleDaftar();
                    },
                    child: const MyText(
                      'Buat Akun',
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
