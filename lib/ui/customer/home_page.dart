import 'package:flutter/material.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/viewmodels/cart/cart_provider.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/core/viewmodels/user/user_provider.dart';
import 'package:pemob_uas/ui/customer/cart_screen.dart';
import 'package:pemob_uas/ui/customer/components/dialog_produk.dart';
import 'package:pemob_uas/ui/customer/components/item_product.dart';
import 'package:pemob_uas/ui/global/dialogs.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/no_data.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                            CartProvider.instance(context).fetchCart();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CartScreen()));
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
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
                    child: Consumer<ProductProvider>(
                      builder: (context, prov, child) {
                        final result = prov.productsResult;

                        if (result.status == ApiStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (result.status == ApiStatus.success &&
                            result.data!.isNotEmpty) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              prov.fetchProducts();
                            },
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 0.8),
                              padding: EdgeInsets.all(2.h),
                              itemCount: result.data!.length,
                              itemBuilder: (context, index) {
                                final pItem = result.data![index];
                                return ItemProduct(
                                  produk: pItem,
                                  onClick: () {
                                    showModalSheet(context, 35.h,
                                        DialogProduk(modelProduk: pItem));
                                  },
                                );
                              },
                            ),
                          );
                        }

                        return NoData(
                          onClick: () {
                            prov.fetchProducts();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   SessionManager.handleLogout(context);
      // }),
    );
  }
}
