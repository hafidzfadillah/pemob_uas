import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/models/product_model.dart';
import 'package:pemob_uas/core/viewmodels/cart/cart_provider.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogProduk extends StatefulWidget {
  const DialogProduk({super.key, required this.modelProduk});
  final ProductModel modelProduk;

  @override
  State<DialogProduk> createState() => _DialogProdukState();
}

class _DialogProdukState extends State<DialogProduk> {
  final qtyController = TextEditingController();
  final focusNode = FocusNode();
  int qty = 1;
  bool isLoading = false;

  void addCart() async {
    if (qty <= 0) {
      return;
    }

    final pref = await SharedPreferences.getInstance();
    bool isLogin = pref.getBool(SessionManager.IS_LOGIN) ?? false;

    if (!isLogin) {
      EasyLoading.showInfo("Silakan login terlebih dahulu");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prov = CartProvider.instance(context);
    await prov.addToCart(widget.modelProduk, qty);
    final result = prov.crudResult;

    if (result.status == ApiStatus.error) {
      EasyLoading.showError(result.data!);
      return;
    }

    EasyLoading.showSuccess(result.data!);
    prov.fetchCart();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    qtyController.text = '$qty';
  }

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Image.network(
                urlPlaceholder,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(imgPlaceholder);
                },
              ),
            ),
            SizedBox(
              width: 2.h,
            ),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      widget.modelProduk.productName,
                      maxLines: 2,
                      weight: FontWeight.w500,
                    ),
                    MyText(
                      widget.modelProduk.productDesc,
                      size: 12,
                      maxLines: 2,
                    ),
                    MyText(
                      priceFormat(
                          double.tryParse(widget.modelProduk.productPrice) ??
                              0.0),
                      weight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (qty > 0) {
                              qty--;
                              qtyController.text = '$qty';
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(1.h)),
                          padding: EdgeInsets.all(0.5.h),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: 80,
                          padding: EdgeInsets.symmetric(horizontal: 2.h),
                          child: TextField(
                            controller: qtyController,
                            focusNode: focusNode,
                            textAlign: TextAlign.center,
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                isDense: true,
                                filled: false,
                                counterText: '',
                                contentPadding: EdgeInsets.all(1.h),
                                border: const OutlineInputBorder()),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                var intVal = int.parse(value);
                                if (intVal >
                                    int.parse(
                                        widget.modelProduk.productStock)) {
                                  EasyLoading.showInfo(
                                      'Stok tersedia: ${widget.modelProduk.productStock}');
                                  setState(() {
                                    qty = int.parse(
                                        widget.modelProduk.productStock);
                                    qtyController.text = "$qty";
                                  });
                                } else {
                                  setState(() {
                                    qty = intVal;
                                  });
                                }
                              } else {
                                setState(() {
                                  qty = 0;
                                });
                              }
                              focusNode.requestFocus();
                            },
                          ),
                          // child: MyText(
                          //   '$qty',
                          //   weight: FontWeight.w600,
                          // ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (qty + 1 >
                              int.parse(widget.modelProduk.productStock)) {
                            EasyLoading.showInfo(
                                'Stok tersedia: ${widget.modelProduk.productStock}');
                            return;
                          }
                          setState(() {
                            qty++;
                            qtyController.text = '$qty';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(1.h)),
                          padding: EdgeInsets.all(0.5.h),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ))
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: qty >= 1 ? accentColor : Colors.grey),
                  onPressed: () {
                    addCart();
                  },
                  child: MyText(
                    'Tambah Keranjang - ${priceFormat(qty.toDouble() * (double.tryParse(widget.modelProduk.productPrice) ?? 0.0))}',
                    color: Colors.white,
                  ),
                ))
      ],
    );
  }
}
