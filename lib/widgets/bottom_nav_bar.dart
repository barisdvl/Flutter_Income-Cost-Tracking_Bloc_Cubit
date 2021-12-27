import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/service/main_cubit.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMain, int>(
      builder: (context, pageIndex) {
        return CurvedNavigationBar(
          height: 55.0,
          backgroundColor: Colors.blueGrey.shade900,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            //Icon(Icons.account_balance_wallet, size: 30),
            Icon(Icons.add, size: 30),
            Icon(Icons.list_alt_sharp, size: 30),
            //Icon(Icons.settings, size: 30),
          ],
          onTap: (index) {
            context.read<CubitMain>().bottomIndex(index);
            //Handle button tap
          },
        );
      },
    );
  }
}
