import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/models/order_model.dart';
import 'package:pemob_uas/core/viewmodels/user/history_provider.dart';
import 'package:pemob_uas/ui/admin/map_screen.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:pemob_uas/ui/global/dialogs.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.data});
  final OrderModel data;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void action() async {
    var confirm = await showConfirmationDialog(
        context, 'Update Status', 'Update status pesanan?');

    if (confirm != true) {
      return;
    }

    EasyLoading.show();

    final prov = HistoryProvider.instance(context);
    await prov.updateStatus(widget.data);
    final result = prov.crudResult;

    if (result.status == ApiStatus.error) {
      EasyLoading.showError(result.data!);
      return;
    }

    EasyLoading.showSuccess(result.data!);
    prov.fetchHistory();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Topbar(
            title: 'Detail Pesanan',
            leading: MyBackButton(),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(2.h),
            children: [
              Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.h)),
                  shadowColor: accentColor.withOpacity(0.15),
                  elevation: 2.h,
                  child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyText('Status Pesanan'),
                                statusLabel(widget.data.orderStatus)
                              ],
                            ),
                            const Divider(),
                            const MyText(
                              'Nama Pemesan',
                              weight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            MyText(widget.data.userName ?? '-'),
                            SizedBox(
                              height: 2.h,
                            ),
                            FutureBuilder(
                              future: addressWidget(),
                              builder: (context, snapshot) {
                                return snapshot.data ?? SizedBox();
                              },
                            ),
                            const MyText(
                              'Tanggal Transaksi',
                              weight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            MyText(DateFormat('dd MMM yyyy, HH:mm')
                                .format(widget.data.orderDate)),
                            SizedBox(
                              height: 2.h,
                            ),
                            const MyText(
                              'Total Bayar',
                              weight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                MyText(
                                  priceFormat(double.tryParse(
                                          widget.data.totalAmount) ??
                                      0.0),
                                  weight: FontWeight.w600,
                                ),
                                SizedBox(
                                  width: 1.h,
                                ),
                                const InkWell(
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ]))),
              SizedBox(
                height: 2.h,
              ),
              Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.h)),
                  shadowColor: accentColor.withOpacity(0.15),
                  elevation: 2.h,
                  child: Padding(
                      padding: EdgeInsets.all(2.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: MyText(
                                'Rincian Pesanan',
                                weight: FontWeight.w600,
                                size: 16,
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              width: double.infinity,
                              child: DataTable(
                                columnSpacing: 2.h,
                                columns: const [
                                  DataColumn(
                                      label: Expanded(
                                          child: MyText(
                                    'Produk',
                                    isItalic: true,
                                    weight: FontWeight.w600,
                                    size: 12,
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: MyText(
                                    'Qty',
                                    isItalic: true,
                                    weight: FontWeight.w600,
                                    size: 12,
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: MyText(
                                    'Harga',
                                    isItalic: true,
                                    weight: FontWeight.w600,
                                    size: 12,
                                  ))),
                                ],
                                rows: widget.data.items.map(
                                  (item) {
                                    return DataRow(cells: [
                                      DataCell(MyText(
                                        item.productName,
                                        size: 12,
                                      )),
                                      DataCell(MyText(
                                        "${item.quantity}",
                                        size: 12,
                                      )),
                                      DataCell(MyText(
                                        priceFormat(
                                            double.tryParse(item.price) ?? 0.0),
                                        size: 12,
                                      )),
                                    ]);
                                  },
                                ).toList(),
                              ),
                            )
                          ])))
            ],
          )),
          FutureBuilder(
            future: actionControl(),
            builder: (context, snapshot) {
              return snapshot.data ?? const SizedBox();
            },
          )
        ],
      ),
    );
  }

  Widget statusLabel(String status) {
    var textColor = Colors.white;
    var bgColor = Colors.green;

    if (status == 'Delivery') {
      bgColor = Colors.purple;
    } else if (status == 'Pending') {
      textColor = blackColor;
      bgColor = Colors.amber;
    }

    return Container(
      padding: EdgeInsets.all(0.5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h), color: bgColor),
      child: MyText(
        status,
        size: 12,
        weight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Future<Widget> addressWidget() async {
    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);
    bool isAdmin = user.isAdmin == 1;

    if (!isAdmin) return const SizedBox();

    if (widget.data.orderLat != '0' && widget.data.orderLon != '0') {
      var lat = double.parse(widget.data.orderLat);
      var lng = double.parse(widget.data.orderLon);

      return Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyText(
                  'Alamat Pengantaran',
                  weight: FontWeight.w600,
                  color: Colors.grey,
                ),
                MyText('$lat, $lng')
              ],
            )),
            SizedBox(
              width: 2.h,
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MapScreen(latitude: lat, longitude: lng)));
                },
                icon: const Icon(
                  Icons.directions,
                  color: accentColor,
                ))
          ],
        ),
      );
    }

    return const SizedBox();
  }

  Future<Widget> actionControl() async {
    final pref = await SharedPreferences.getInstance();
    var user =
        SessionManager.decodeUser(pref.getString(SessionManager.USER_DATA)!);
    bool isAdmin = user.isAdmin == 1;

    if (isAdmin) {
      if (widget.data.orderStatus == 'Pending') {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: ElevatedButton(
                onPressed: () {
                  action();
                },
                child: const MyText(
                  'Kirim Pesanan',
                  color: Colors.white,
                )),
          ),
        );
      } else if (widget.data.orderStatus == 'Delivery') {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: ElevatedButton(
                onPressed: () {
                  action();
                },
                child: const MyText(
                  'Selesaikan Pesanan',
                  color: Colors.white,
                )),
          ),
        );
      }
    }

    return const SizedBox();
  }
}
