import 'package:flutter/material.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/ui/admin/components/item_product.dart';
import 'package:pemob_uas/ui/admin/form_product.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/no_data.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Topbar(
            title: 'Kelola Produk',
            leading: MyBackButton(),
          ),
          Expanded(child: Consumer<ProductProvider>(
            builder: (context, prov, child) {
              final result = prov.productsResult;

              if (result.status == ApiStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (result.status == ApiStatus.success &&
                  result.data!.isNotEmpty) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  padding: EdgeInsets.all(2.h),
                  itemCount: result.data!.length,
                  itemBuilder: (context, index) {
                    final pItem = result.data![index];
                    return ItemProductAdmin(
                      produk: pItem,
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormProduct(
                                data: pItem,
                              ),
                            ));
                      },
                    );
                  },
                );
              }

              return NoData(
                onClick: () {
                  prov.fetchProducts();
                },
              );
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormProduct(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
