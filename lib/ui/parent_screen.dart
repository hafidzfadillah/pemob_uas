import 'package:flutter/material.dart';
import 'package:pemob_uas/core/viewmodels/user/user_provider.dart';
import 'package:pemob_uas/ui/admin/home_admin.dart';
import 'package:pemob_uas/ui/auth/session_manager.dart';
import 'package:pemob_uas/ui/customer/landing_customer.dart';
import 'package:pemob_uas/ui/global/my_text.dart';
import 'package:provider/provider.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ParentScreen> {
  @override
  void initState() {
    super.initState();
    UserProvider.instance(context).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, prov, _) {
      if (prov.user == null) {
        return const LandingCustomer();
        // return Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const MyText('Session login berakhir'),
        //     const SizedBox(
        //       height: 16,
        //     ),
        //     OutlinedButton(
        //         onPressed: () {
        //           SessionManager.handleLogout(context);
        //         },
        //         child: const MyText('Logout'))
        //   ],
        // );
      }

      if (prov.user!.isAdmin == 1) {
        return const HomeAdmin();
      }

      return const LandingCustomer();
    });
  }
}
