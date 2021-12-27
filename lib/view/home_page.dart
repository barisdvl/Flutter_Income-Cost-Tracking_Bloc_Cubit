import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/models/accounts.dart';
import 'package:flutter_bloc_cubit/service/crud_cubit.dart';
import 'package:flutter_bloc_cubit/service/crud_state.dart';
import 'package:flutter_bloc_cubit/service/main_cubit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: BlocBuilder<CRUDCubit, CRUDState>(
              builder: (context, crudState) {
                if (crudState is DatabaseLoaded) {
                  List<Map<String, dynamic>> sumTotalList =
                      crudState.sumTotalList;
                  double totalBalance = sumTotalList[0]["totalBalance"];
                  double totalIncome = sumTotalList[0]["totalIncome"];
                  double totalExpense = sumTotalList[0]["totalExpense"];

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.indigo.shade400.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(8),
                    height: height * 0.30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                MotionToast(
                                        icon: Icons.zoom_out,
                                        color: Colors.deepOrange,
                                        title: "Profile Icon Button",
                                        titleStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        description:
                                            "Clicked on profile icon button",
                                        position: MOTION_TOAST_POSITION.CENTER)
                                    .show(context);
                              },
                              icon: Icon(Icons.person, color: Colors.white),
                            ),
                            Text("Detail",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Colors.white),
                              color: Colors.indigoAccent.shade100,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              itemBuilder: (context) {
                                return List.generate(3, (index) {
                                  return PopupMenuItem(
                                    child: Text('Item $index',
                                        style: TextStyle(color: Colors.white)),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        Text(
                          "Total Balance",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "${totalBalance.toStringAsFixed(2)} TL",
                          style: TextStyle(
                            color:
                                (totalBalance > 0) ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50.0, top: 3.0, bottom: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: Colors.green,
                                size: 28,
                              ),
                              Text("Incomes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              Text("${totalIncome.toStringAsFixed(2)} TL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50.0, top: 3.0, bottom: 3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.money_off,
                                color: Colors.red,
                                size: 28,
                              ),
                              Text("Expenses",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                              Text("${totalExpense.toStringAsFixed(2)} TL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              height: height * 0.05,
              alignment: Alignment.centerLeft,
              child: Text("Accounts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
            ),
          ),
          BlocBuilder<AccountViewCubit, int>(
            builder: (context, accountViewIndex) {
              return SizedBox(
                height: height * 0.20, // card height
                child: PageView.builder(
                  itemCount: accounts.length,
                  onPageChanged: (int index) {
                    context.read<AccountViewCubit>().accountViewIndex(index);
                  },
                  controller: PageController(viewportFraction: 0.7),
                  itemBuilder: (_, index) {
                    return Transform.scale(
                      scale: index == accountViewIndex ? 1 : 0.7,
                      child: Card(
                        color: Colors.indigo.shade400.withOpacity(0.6),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(accounts[index]["account_icon"],
                                  color: Colors.white, size: 35),
                              Text(
                                accounts[index]["account_name"],
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              height: height * 0.05,
              alignment: Alignment.centerLeft,
              child: Text("Account Detail",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: BlocBuilder<AccountViewCubit, int>(
              builder: (context, pageViewIndex) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade400.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(8),
                  height: height * 0.24,
                  width: width,
                  child: BlocBuilder<CRUDCubit, CRUDState>(
                    builder: (context, crudState) {
                      if (crudState is DatabaseLoaded) {
                        List<Map<String, dynamic>> sumAccountList =
                            crudState.sumAccountList;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Account ${accounts[pageViewIndex]["account_name"]} Detail",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 26,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                  size: 28,
                                ),
                                Text(
                                  "Income :",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  sumAccountList[pageViewIndex][
                                          "sumIncome${accounts[pageViewIndex]["account_name"]}"]
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.money_off,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                Text(
                                  "Expense :",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  sumAccountList[pageViewIndex][
                                          "sumExpense${accounts[pageViewIndex]["account_name"]}"]
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
