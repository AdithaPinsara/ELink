import 'package:elink/bloc_observer.dart';
import 'package:elink/cart/bloc/cart_bloc.dart';
import 'package:elink/cart/models/cart_item.dart';
import 'package:elink/products/bloc/product_bloc.dart';
import 'package:elink/products/models/product.dart';
import 'package:elink/user_data/bloc/user_data_bloc.dart';
import 'package:elink/user_data/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  //register the generated hive adapters
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemAdapter());

  final cartBox =
      await Hive.openBox<CartItem>('cartBox'); //create hive box for cart
  Bloc.observer = const SimpleBlocObserver();
  runApp(MainApp(cartBox: cartBox));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.cartBox});

  final Box<CartItem> cartBox;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //multiple bloc providers
        BlocProvider(
          create: (_) =>
              ProductBloc(httpClient: http.Client())..add(ProductFetched()),
        ),
        BlocProvider(
          create: (_) => CartBloc(cartBox: cartBox)..add(CartInitialized()),
        ),
        BlocProvider(
          create: (_) => UserDataBloc(httpClient: http.Client()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: LoginScreen(),
        ),
      ),
    );
  }
}
