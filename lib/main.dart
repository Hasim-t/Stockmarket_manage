import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:stockmarketdata/bottom_navigation/bloc/bottom_bloc.dart';
import 'package:stockmarketdata/db/model/stock_data_model.dart';
import 'package:stockmarketdata/splash/bloc/splash_bloc.dart';
import 'package:stockmarketdata/splash/splash.dart';

Future<void> main() async {
  Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StockMarketModelAdapter().typeId)) {
    Hive.registerAdapter(StockMarketModelAdapter());
  }
  runApp(MultiBlocProvider(providers: [
    BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(),
    ),
    BlocProvider<BottomBloc>(create: (context) => BottomBloc()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
