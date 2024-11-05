import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmarketdata/bottom_navigation/bloc/bottom_bloc.dart';
import 'package:stockmarketdata/home.dart';
import 'package:stockmarketdata/watchlist.dart';

class BottomNavgationsScreen extends StatefulWidget {
  const BottomNavgationsScreen({super.key});

  @override
  State<BottomNavgationsScreen> createState() => _BottomNavgationsScreenState();
}

class _BottomNavgationsScreenState extends State<BottomNavgationsScreen> {
  List<Widget> bottomscreenss = [const Home(), const Watchlist()];
  int current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      BlocProvider.of<BottomBloc>(context).add(ChangeingEvent(value: 0));
  }
  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: BlocBuilder<BottomBloc, BottomState>(
        builder: (context, state) {
          if (state is Bottomchnagestate) {
            return BottomNavigationBar(
                currentIndex:  state.current,
              onTap: (value) {
                 state.ontap(value);
                 BlocProvider.of<BottomBloc>(context).add(ChangeingEvent(value: value));
               
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Home ',
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: 'WatchList',
                  icon: Icon(Icons.list),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
      body: BlocBuilder<BottomBloc, BottomState>(
        builder: (context, state) {
          if (state is Bottomchnagestate) {
            return bottomscreenss[state.current];
          }
          return bottomscreenss[0];
        },
      ),
    );
  }
}
