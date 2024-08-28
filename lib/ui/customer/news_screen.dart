import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/viewmodels/news/news_provider.dart';
import 'package:pemob_uas/ui/customer/components/card_news.dart';
import 'package:pemob_uas/ui/customer/components/currency_chart.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/no_data.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();

    NewsProvider.instance(context).fetchTimeSeries();
    NewsProvider.instance(context).fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Topbar(title: 'Berita Terkini'),
          Expanded(
              child: RefreshIndicator(
            onRefresh: () async {
              NewsProvider.instance(context).fetchTimeSeries();
              NewsProvider.instance(context).fetchNews();
            },
            child: ListView(
              padding: EdgeInsets.all(2.h),
              children: [
                const MyText(
                  'Update Kurs USD - IDR',
                  weight: FontWeight.bold,
                ),
                Consumer<NewsProvider>(builder: (context, prov, _) {
                  final result = prov.timeSeries;

                  if (result.status == ApiStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (result.status == ApiStatus.success) {
                    return SizedBox(
                        height: 25.h,
                        child: CurrencyChart(rates: result.data!.rates));
                  }

                  return NoData(onClick: () {
                    prov.fetchTimeSeries();
                  });
                }),
                SizedBox(
                  height: 2.h,
                ),
                const MyText(
                  'Berita Ekonomi Terkini',
                  weight: FontWeight.bold,
                ),
                Consumer<NewsProvider>(builder: (context, prov, _) {
                  final result = prov.news;

                  if (result.status == ApiStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (result.status == ApiStatus.success &&
                      result.data != null) {
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: result.data!.length,
                      itemBuilder: (context, index) => CardNews(
                          data: result.data![index],
                          onClick: () async {
                            final url = result.data![index].url;
                            await launchUrl(Uri.parse(url));
                          }),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 2.h,
                      ),
                    );
                  }

                  return NoData(onClick: () {
                    prov.fetchNews();
                  });
                }),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
