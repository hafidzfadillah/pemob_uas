import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/models/product_model.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/ui/global/dialogs.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FormProduct extends StatefulWidget {
  const FormProduct({super.key, this.data});
  final ProductModel? data;

  @override
  State<FormProduct> createState() => _FormProductState();
}

class _FormProductState extends State<FormProduct> {
  final cName = TextEditingController();
  final cDesc = TextEditingController();
  final cPrice = TextEditingController();
  final cStock = TextEditingController();
  var publish = false;

  void submit() async {
    if (cName.text.isEmpty) {
      EasyLoading.showInfo('Nama tidak boleh kosong');
      return;
    }
    if (cDesc.text.isEmpty) {
      EasyLoading.showInfo('Nama tidak boleh kosong');
      return;
    }
    if (cPrice.text.isEmpty) {
      EasyLoading.showInfo('Nama tidak boleh kosong');
      return;
    }
    if (cStock.text.isEmpty) {
      EasyLoading.showInfo('Nama tidak boleh kosong');
      return;
    }

    EasyLoading.show();

    var data = ProductModel(
        productId: widget.data != null ? widget.data!.productId : '',
        productName: cName.text,
        productDesc: cDesc.text,
        productPrice: cPrice.text,
        productStock: cStock.text,
        isPublish: publish ? '1' : '0');

    final prov = ProductProvider.instance(context);

    if (widget.data != null) {
      await prov.updateProduct(data);
    } else {
      await prov.createProduct(data);
    }

    final result = prov.crudResult;

    if (result.status == ApiStatus.error) {
      EasyLoading.showError(result.data!);
      return;
    }

    EasyLoading.showSuccess(result.data!);
    prov.fetchProducts();
    Navigator.pop(context);
  }

  void handleDelete() async {
    final confirm = await showConfirmationDialog(context, 'Hapus produk',
        'Yakin untuk menghapus produk \"${widget.data!.productName}\"');

    if (confirm != true) {
      return;
    }

    final prov = ProductProvider.instance(context);
    await prov.deleteProduct(widget.data!.productId);
    final result = prov.crudResult;

    if (result.status == ApiStatus.error) {
      EasyLoading.showError(result.data!);
      return;
    }

    EasyLoading.showSuccess(result.data!);
    prov.fetchProducts();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      cName.text = widget.data!.productName;
      cDesc.text = widget.data!.productDesc;
      cPrice.text = widget.data!.productPrice;
      cStock.text = widget.data!.productStock;
      publish = widget.data!.isPublish == '1';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Topbar(
            title: 'Kelola Produk',
            leading: MyBackButton(),
            action: widget.data == null
                ? null
                : TextButton.icon(
                    onPressed: () {
                      handleDelete();
                    },
                    label: MyText(
                      'Hapus',
                      color: Colors.white,
                    ),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(2.h),
            children: [
              Row(
                children: [
                  const Expanded(child: MyText('Tayangkan Produk?')),
                  Switch(
                    value: publish,
                    onChanged: (value) {
                      setState(() {
                        publish = value;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              const MyText('Nama Produk'),
              TextField(
                controller: cName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Nama Produk'),
              ),
              SizedBox(
                height: 2.h,
              ),
              const MyText('Deskripsi'),
              TextField(
                controller: cDesc,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Deskripsi'),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText('Harga Jual'),
                        TextField(
                          controller: cPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Harga Jual'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 2.h,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText('Stok'),
                        TextField(
                          controller: cStock,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Stok'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )),
          Padding(
            padding: EdgeInsets.all(2.h),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    submit();
                  },
                  child: MyText(
                    widget.data != null ? 'Simpan Perubahan' : 'Tambah Produk',
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
