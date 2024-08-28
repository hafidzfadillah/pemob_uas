import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pemob_uas/core/models/cart_model.dart';
import 'package:pemob_uas/core/viewmodels/cart/cart_provider.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CardCart extends StatefulWidget {
  const CardCart(
      {super.key,
      this.onDelete,
      this.disableCheckbox = false,
      this.hideDelete = false,
      this.hideCheck = false,
      required this.cartItem,
      this.onTap});

  final CartModel cartItem;
  final Function()? onDelete;
  final bool? disableCheckbox;
  final bool? hideDelete;
  final bool? hideCheck;
  final Function()? onTap;

  @override
  State<CardCart> createState() => _CardCartState();
}

class _CardCartState extends State<CardCart> {
  bool isChecked = false;
  var qty = 0;

  void cekStatus() async {
    final prov = CartProvider.instance(context);

    if (prov.listSelected.contains(widget.cartItem)) {
      setState(() {
        isChecked = true;
      });
    } else {
      isChecked = false;
    }

    qty = widget.cartItem.quantity;
  }

  // void updateQty() async {
  //   EasyLoading.show(status: 'Memproses permintaan Anda');

  //   final email = await SessionManager().getUserInfo(SessionManager.EMAIL);

  //   Map<String, dynamic> param = {
  //     "Cart_ID": widget.cartItem.idData,
  //     "ID_Merchant": widget.cartItem.idMerchant,
  //     "ID_Jasa": widget.cartItem.idJasa,
  //     "ID_Layanan": widget.cartItem.idLayanan,
  //     "Qty": qty,
  //     "Qty_Room": qty,
  //     "Qty_Adult": 1,
  //     "Qty_Child": 0,
  //     "Qty_Infant": 0,
  //     "RpRate": widget.cartItem.rpRate,
  //     "RpPotongan": widget.cartItem.dtJson.rpPotongan,
  //     "Produk": widget.cartItem.layananNama,
  //     "Produk_Detail": widget.cartItem.layananNama,
  //     "Pelanggan_ID": email,
  //     "RpTagihan": widget.cartItem.dtJson.rpRate,
  //     "RpDiskon": widget.cartItem.dtJson.rpPotongan,
  //   };

  //   // print(param);

  //   final cartProv = CartProvider.instance(context);
  //   final rsp = await cartProv.udtCart(param);

  //   if (rsp['RC'] == '00') {
  //     EasyLoading.showSuccess(rsp['Message']);
  //   } else {
  //     EasyLoading.showInfo(rsp['Message']);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    cekStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.h)),
      shadowColor: accentColor.withOpacity(0.15),
      elevation: 2.h,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          children: [
            Row(children: [
              Visibility(
                visible: !widget.hideCheck!,
                child: Consumer<CartProvider>(builder: (context, prov, _) {
                  return Checkbox(
                    value: prov.listSelected.contains(widget.cartItem),
                    onChanged: (value) async {
                      // setState(() {
                      //   isChecked = value ?? false;
                      // });

                      if (value!) {
                        final result = CartProvider.instance(context)
                            .selectItem(widget.cartItem);
                        if (!result) {
                          setState(() {
                            isChecked = false;
                          });
                        }
                      } else {
                        CartProvider.instance(context)
                            .deselectItem(widget.cartItem.productId);
                      }
                    },
                  );
                }),
              ),
              Container(
                width: 8.h,
                height: 8.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: const NetworkImage(urlPlaceholder),
                      onError: (exception, stackTrace) => Image.asset(
                        imgPlaceholder,
                        height: 8.h,
                        width: 8.h,
                      ),
                    )),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      widget.cartItem.productName,
                      size: 12,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyText(
                            "${widget.cartItem.quantity}x ${priceFormat(double.tryParse(widget.cartItem.price) ?? 0.0)}",
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 1.h,
                    // ),
                  ],
                ),
              )),
              IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            ]),
            // Divider(
            //   height: 1.h,
            // ),
            Visibility(
              // visible: !widget.hideDelete!,
              visible: false,
              child: Center(
                  child: TextButton.icon(
                      onPressed: widget.onDelete,
                      icon: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red,
                      ),
                      label: const MyText('Hapus'))),
            )
          ],
        ),
      ),
    );
  }
}
