import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stockmarketdata/bottomnavigation_screen.dart';
import 'package:stockmarketdata/splash/bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SplashBloc>(context).add(NavigateToHomeScreenEvent());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 64, 143, 150),
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoded) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return const BottomNavgationsScreen();
            }));
          }
        },
        builder: (context, state) {
          if (state is SplashLoading) {
           
            return Column(
           
                children: [
  
       const   SizedBox(height: 300,),
                  Center(
                    child: Lottie.asset(
                      height: 250,
                      width: 250,
                      'asset/stockmarket.json', fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 100,),
                 const  Text('Stokeyfiy',style: TextStyle(
                    fontSize: 38,fontStyle: FontStyle.italic,
                    fontWeight:FontWeight.w900
                  ),)
                ]);
          }
          
          return Center(
            child: Container(
              height: 200,
              width: 200,
            ),
          );
        },
      ),
    );
  }
}
