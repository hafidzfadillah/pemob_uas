import 'package:flutter/material.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/core/viewmodels/user/history_provider.dart';
import 'package:pemob_uas/core/viewmodels/user/user_provider.dart';
import 'package:pemob_uas/ui/admin/manage_order.dart';
import 'package:pemob_uas/ui/admin/manage_product.dart';
import 'package:pemob_uas/ui/customer/profile_page.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                Color(0xFF0C57AF),
                Color(0xFF24A4DD),
                Color(0xFF92DEFF),
              ])),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(2.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<UserProvider>(
                        builder: (context, prov, child) {
                          if (!prov.isAuthenticated || prov.user == null) {
                            return const MyText(
                              'Hello, guest!',
                              color: Colors.white,
                              weight: FontWeight.w600,
                              size: 18,
                            );
                          }

                          return MyText(
                            'Hi, ${prov.user!.username}',
                            weight: FontWeight.w600,
                            size: 18,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ProfilePage(
                                        showBack: true,
                                      )));
                        },
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2.h),
                        topRight: Radius.circular(2.h))),
                child: ListView(
                  padding: EdgeInsets.all(2.h),
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            ProductProvider.instance(context).fetchProducts();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ManageProduct()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.h),
                            decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(1.h)),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/belanja.png',
                                  width: 8.h,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                const MyText(
                                  'Kelola Produk',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 2.h,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            HistoryProvider.instance(context).fetchHistory();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ManageOrder()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(2.h),
                            decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(1.h)),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/toko.png',
                                  width: 8.h,
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                const MyText(
                                  'Kelola Pesanan',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        )
      ],
    ));
  }
}
