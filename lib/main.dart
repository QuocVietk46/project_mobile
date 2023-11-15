import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:shop_shoe/ui/products/edit_product_screen.dart';
import 'ui/screens.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (context) => ProductsManager(),
          update: (context, authManager, productsManager) {
            productsManager!.authToken = authManager.authToken;
            return productsManager;
          },
        ),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ChangeNotifierProvider(create: (ctx) => OrdersManager()),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'quickSand',
          ),
          home: authManager.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  },
                ),
          routes: {
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == EditProductScreen.routeName) {
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (ctx) {
                  return EditProductScreen(
                    productId != null
                        ? ctx.read<ProductsManager>().findById(productId)
                        : null,
                  );
                },
              );
            }

            if (settings.name == ProductDetailScreen.routeName) {
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                settings: settings,
                builder: (ctx) {
                  return ProductDetailScreen(
                    ctx.read<ProductsManager>().findById(productId)!,
                  );
                },
              );
            }

            return null;
          },
        );
      }),
    );
  }
}
