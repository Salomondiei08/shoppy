import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppy/providers/cart.dart';
import 'package:shoppy/providers/products_provider.dart';
import 'package:shoppy/screens/auth_screen.dart';
import 'package:shoppy/screens/product_overview_screen.dart';
import 'helpers/routes.dart';
import 'providers/auth.dart';
import 'providers/orders.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (context, auth, previous) => ProductsProvider(auth.token,
              previous != null ? previous.allProducts : [], auth.userId),
          create: (context) => ProductsProvider(null, [], null),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(
              auth.token, previous != null ? previous.orders : [], auth.userId),
          create: (context) => Orders(null, [], null),
        ),
      ],
      child: const ShoppyApp(),
    ),
  );
}

class ShoppyApp extends StatelessWidget {
  const ShoppyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authProvider, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                .copyWith(secondary: Colors.purple),
            fontFamily: 'Lato'),
        title: 'Shoppy',
        home: authProvider.isAuth
            ? const ProductOverviewScreen()
            : FutureBuilder(
                future: context.read<Auth>().tryAutoLogIn(),
                builder: (ctx, authResult) =>
                    authResult.connectionState == ConnectionState.waiting
                        ?const  Scaffold(
                          body: const Center(
                              child: Text('Fetchin data'),
                            ),
                        )
                        : const AuthScreen()),
        routes: Routes.routesList,
        // onGenerateRoute: Routes.onGenerateGoute,
      ),
    );
  }
}
