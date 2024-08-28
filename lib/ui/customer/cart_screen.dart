import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/viewmodels/cart/cart_provider.dart';
import 'package:pemob_uas/ui/customer/components/card_cart.dart';
import 'package:pemob_uas/ui/global/dialogs.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/no_data.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void submitOrder() async {
    final cProv = CartProvider.instance(context);

    if (cProv.totalPrice == 0) {
      EasyLoading.showInfo('Pick your items');
      return;
    }

    EasyLoading.show();

    var lat = 0.0;
    var lng = 0.0;
    var pos = await _getLocation();
    print("POSITION: $pos");

    if (pos != null) {
      lat = pos.latitude;
      lng = pos.longitude;
    }

    final result = await cProv.createOrder(lat, lng);

    if (result.status == ApiStatus.error) {
      EasyLoading.showError(result.data!);
      return;
    }

    EasyLoading.showSuccess(result.data!);
    cProv.clearSelected();
    Navigator.pop(context);
  }

  void removeFromCart(id) async {
    showConfirmationDialog(
            context, 'Hapus Keranjang', 'Hapus produk ini dari keranjang?')
        .then(
      (value) async {
        if (value) {
          EasyLoading.show();
          final prov = CartProvider.instance(context);
          await prov.removeCart(id);
          final result = prov.crudResult;

          if (result.status == ApiStatus.error) {
            EasyLoading.showError(result.data!);
            return;
          }

          EasyLoading.showSuccess(result.data!);
          prov.fetchCart();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CartProvider.instance(context).clearSelected();
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            Topbar(
              title: 'Keranjang',
              leading: MyBackButton(
                onBack: () {
                  CartProvider.instance(context).clearSelected();
                  Navigator.pop(context);
                },
              ),
            ),
            Expanded(child: listCart()),
            Container(
              padding: EdgeInsets.all(2.h),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyText('Total'),
                      Consumer<CartProvider>(builder: (context, prov, _) {
                        return MyText(
                          priceFormat(prov.totalPrice),
                          weight: FontWeight.w600,
                          size: 16,
                        );
                      })
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitOrder();
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: accentColor),
                    child: const MyText(
                      'Pesan',
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listCart() {
    return Consumer<CartProvider>(
      builder: (context, prov, child) {
        final result = prov.cartResult;

        if (result.status == ApiStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.status == ApiStatus.success && result.data!.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              prov.fetchCart();
            },
            child: ListView.separated(
              padding: EdgeInsets.all(2.h),
              itemCount: result.data!.length,
              itemBuilder: (context, index) {
                final cItem = result.data![index];

                return CardCart(
                  cartItem: cItem,
                  onDelete: () {
                    removeFromCart(cItem.productId);
                  },
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 1.h,
              ),
            ),
          );
        }

        return NoData(
          onClick: () {
            prov.fetchCart();
          },
        );
      },
    );
  }

  Future<Position?> _getLocation() async {
    var isAllowed = await _checkPermission();
    if (!isAllowed) {
      var result = await Permission.location.request();

      if (result != PermissionStatus.granted) {
        // EasyLoading.showInfo(
        //     'Fitur ini memerlukan akses lokasi perangkat Anda');
        return null;
      }
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.location.status;
    return status.isGranted;
  }
}
