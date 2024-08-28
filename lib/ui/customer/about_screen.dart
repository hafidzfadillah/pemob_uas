import 'package:flutter/material.dart';
import 'package:pemob_uas/myremote_config_service.dart';
import 'package:pemob_uas/ui/global/my_backbutton.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:pemob_uas/ui/global/topbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          const Topbar(
            title: 'Tentang Aplikasi',
            leading: MyBackButton(),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(2.h),
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage('assets/images/profile.png'),
                minRadius: width * 0.2,
              ),
              SizedBox(
                height: 4.h,
              ),
              MyText(
                RemoteConfigService().getString('about_dev'),
                maxLines: 50,
              ),
              SizedBox(
                height: 4.h,
              ),
              MyText(
                RemoteConfigService().getString('about_app'),
                maxLines: 50,
              )
            ],
          ))
        ],
      ),
    );
  }
}
