import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:pemob_uas/ui/auth/sign_in.dart';
import 'package:pemob_uas/ui/customer/history_screen.dart';
import 'package:pemob_uas/ui/customer/home_page.dart';
import 'package:pemob_uas/ui/customer/news_screen.dart';
import 'package:pemob_uas/ui/customer/profile_page.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingCustomer extends StatefulWidget {
  const LandingCustomer({super.key});

  @override
  State<LandingCustomer> createState() => _LandingCustomerState();
}

class _LandingCustomerState extends State<LandingCustomer> {
  int _currentPage = 0;

  var pages = [
    const HomePage(),
    const NewsScreen(),
    const HistoryScreen(),
    const ProfilePage()
  ];

  Future<Widget> loginPrompt() async {
    final pref = await SharedPreferences.getInstance();
    bool isLogin = pref.getBool(SessionManager.IS_LOGIN) ?? false;

    if (!isLogin) {
      return Positioned(
          bottom: 1.h,
          left: 1.h,
          right: 1.h,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SignIn()));
            },
            child: Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                  color: blackColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(2.h)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    'Sudah punya akun?',
                    color: Colors.white,
                  ),
                  MyText(
                    'Masuk',
                    color: Colors.amber,
                    weight: FontWeight.w600,
                  )
                ],
              ),
            ),
          ));
    }

    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    ProductProvider.instance(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(child: pages.elementAt(_currentPage)),
          FutureBuilder<Widget>(
            future: loginPrompt(),
            builder: (context, snapshot) {
              return snapshot.data ?? const SizedBox();
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
              height: 9.h,
              padding: EdgeInsets.only(left: 3.h, top: 2.h, right: 3.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ProductProvider.instance(context).fetchProducts();
                        setState(() {
                          _currentPage = 0;
                        });
                      },
                      child: SizedBox(
                          child: Column(
                        children: [
                          SvgPicture.asset('assets/images/home.svg',
                              width: 3.h,
                              height: 3.h,
                              color: _currentPage == 0
                                  ? primaryColor
                                  : Colors.grey.shade400),
                          const MyText(
                            "Beranda",
                          )
                        ],
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentPage = 1;
                        });
                      },
                      child: SizedBox(
                          child: Column(
                        children: [
                          SvgPicture.asset('assets/images/news.svg',
                              width: 3.h,
                              height: 3.h,
                              color: _currentPage == 1
                                  ? primaryColor
                                  : Colors.grey.shade400),
                          const MyText(
                            "Berita",
                          )
                        ],
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentPage = 2;
                        });
                      },
                      child: SizedBox(
                          child: Column(
                        children: [
                          SvgPicture.asset('assets/images/history.svg',
                              width: 3.h,
                              height: 3.h,
                              color: _currentPage == 2
                                  ? primaryColor
                                  : Colors.grey.shade400),
                          const MyText(
                            "Pesanan",
                          )
                        ],
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentPage = 3;
                        });
                      },
                      child: SizedBox(
                          child: Column(
                        children: [
                          SvgPicture.asset('assets/images/profil.svg',
                              width: 3.h,
                              height: 3.h,
                              color: _currentPage == 3
                                  ? primaryColor
                                  : Colors.grey.shade400),
                          const MyText(
                            "Profil",
                          )
                        ],
                      )),
                    ),
                  ]))),
    );
  }
}
