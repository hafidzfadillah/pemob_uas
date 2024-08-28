import 'package:flutter/material.dart';
import 'package:pemob_uas/core/models/product_model.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemProductAdmin extends StatelessWidget {
  final ProductModel produk;
  final bool? isSelected;
  final Function() onClick;

  const ItemProductAdmin(
      {super.key,
      required this.produk,
      required this.onClick,
      this.isSelected});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: Card(
            elevation: 0.5.h,
            shadowColor: primaryColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.h)),
            child: InkWell(
              onTap: onClick,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(1.h),
                                child: Image.network(
                                  // produk.layananImage,
                                  urlPlaceholder,
                                  height: 15.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      imgPlaceholder,
                                      height: 15.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )),
                            publishStatus()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h),
                        child: MyText(
                          produk.productName,
                          size: 12,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(1.h, 0, 1.h, 2.h),
                        child: MyText(
                          priceFormat(
                              double.tryParse(produk.productPrice) ?? 0.0),
                          maxLines: 1,
                          size: 12,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: produk.productStock == '0',
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(1.h)),
                      child: const Center(
                          child: MyText(
                        'Stok habis',
                        color: Colors.white,
                      )),
                    ),
                  ),
                  Visibility(
                    visible: isSelected != null && isSelected == true,
                    child: Container(
                      decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(1.h)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget publishStatus() {
    var text = 'Tidak tayang';
    var textColor = Colors.white;
    var bgColor = Colors.red;

    if (produk.isPublish == '1') {
      text = 'Tayang';
      bgColor = Colors.green;
    }

    return Container(
      padding: EdgeInsets.all(0.5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h), color: bgColor),
      child: MyText(
        text,
        size: 12,
        weight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
