import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pemob_uas/core/models/user_model.dart';
import 'package:pemob_uas/myremote_config_service.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:pemob_uas/ui/customer/about_screen.dart';
import 'package:pemob_uas/ui/global/dialogs.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.showBack});
  final bool? showBack;

  Future<UserModel> getProfile() async {
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString(SessionManager.USER_DATA);
    final decodedUser = SessionManager.decodeUser(user!);

    return decodedUser;
  }

  void handleLogout(context) async {
    showConfirmationDialog(context, 'Keluar Akun', 'Yakin untuk keluar?').then(
      (value) async {
        if (value == true) {
          EasyLoading.show();
          await Future.delayed(const Duration(seconds: 1));
          EasyLoading.dismiss();
          SessionManager.handleLogout(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      children: [
        Topbar(
          title: 'Profil',
          leading: showBack == true ? const MyBackButton() : null,
        ),
        Expanded(
          child: FutureBuilder(
              future: getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyText('Session login berakhir'),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            handleLogout(context);
                          },
                          child: const MyText('Logout'))
                    ],
                  );
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText('Nama'),
                      MyText(
                        snapshot.data!.username,
                        weight: FontWeight.w600,
                        size: 18,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      const MyText('Email'),
                      MyText(
                        snapshot.data!.email,
                        weight: FontWeight.w600,
                        size: 18,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: TextButton(
                            onPressed: () async {
                              final demoLink =
                                  RemoteConfigService().getString('link_demo');

                              if (demoLink.isNotEmpty &&
                                  demoLink.startsWith('https')) {
                                await launchUrl(Uri.parse(demoLink));
                              } else {
                                EasyLoading.showInfo(
                                    "Video demo belum tersedia");
                              }
                            },
                            child: const MyText('Demo Aplikasi')),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AboutScreen()));
                            },
                            child: const MyText('Tentang Aplikasi')),
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              handleLogout(context);
                            },
                            child: const MyText(
                              'Keluar Akun',
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    ));
  }
}
