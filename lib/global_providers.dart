import 'package:pemob_uas/core/viewmodels/cart/cart_provider.dart';
import 'package:pemob_uas/core/viewmodels/news/news_provider.dart';
import 'package:pemob_uas/core/viewmodels/products/product_provider.dart';
import 'package:pemob_uas/core/viewmodels/user/history_provider.dart';
import 'package:provider/provider.dart';

import 'core/viewmodels/user/user_provider.dart';

class GlobalProviders {
  static Future register() async => [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => NewsProvider()),
      ];
}
