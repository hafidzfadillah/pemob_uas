import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/viewmodels/user/history_provider.dart';
import 'package:pemob_uas/ui/customer/detail_screen.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/no_data.dart';
import 'package:pemob_uas/ui/global/styles.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ManageOrder extends StatelessWidget {
  const ManageOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Topbar(
            title: 'Kelola Pesanan',
            leading: MyBackButton(),
          ),
          Expanded(child: Consumer<HistoryProvider>(
            builder: (context, prov, child) {
              final result = prov.orderResult;

              if (result.status == ApiStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (result.status == ApiStatus.success) {
                return RefreshIndicator(
                  onRefresh: () async {
                    prov.fetchHistory();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(2.h),
                    itemCount: result.data!.length,
                    itemBuilder: (context, index) {
                      final oItem = result.data![index];

                      return Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.h)),
                        shadowColor: accentColor.withOpacity(0.15),
                        elevation: 2.h,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DetailScreen(
                                          data: oItem,
                                        )));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.shopping_bag,
                                  color: accentColor,
                                ),
                                title: MyText(
                                  DateFormat("dd MMM yyyy, HH:mm")
                                      .format(oItem.orderDate),
                                ),
                                subtitle: MyText(
                                  oItem.userName ?? '-',
                                  isItalic: true,
                                ),
                                trailing: statusLabel(oItem.orderStatus),
                              ),
                              const Divider(),
                              Padding(
                                padding: EdgeInsets.all(2.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      'Total: ${priceFormat(double.tryParse(oItem.totalAmount) ?? 0.0)}',
                                      weight: FontWeight.w600,
                                    ),
                                    const MyText(
                                      'Lihat Detail',
                                      color: Colors.lightBlue,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 1.h,
                    ),
                  ),
                );
              }

              return NoData(onClick: () {
                prov.fetchHistory();
              });
            },
          ))
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
}
