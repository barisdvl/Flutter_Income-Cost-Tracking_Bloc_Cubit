import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/models/dateConvert.dart';
import 'package:flutter_bloc_cubit/service/api.dart';
import 'package:flutter_bloc_cubit/service/crud_cubit.dart';
import 'package:flutter_bloc_cubit/service/main_cubit.dart';
import 'package:flutter_bloc_cubit/widgets/account_list.dart';
import 'package:flutter_bloc_cubit/widgets/category_list.dart';
import 'package:flutter_bloc_cubit/widgets/edit_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final Stream<QuerySnapshot> _entries = Api("entries").streamDataCollection();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
            borderRadius: BorderRadius.circular(25)),
        height: height * 0.87,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: _entries,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot?> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                  ;
                }
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    var date = dateConverter(data["transaction_date"].toDate());
                    double amount = double.parse(data["transaction_amount"]);
                    var documentId = document.id;
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      actions: <Widget>[
                        Card(
                          child: IconSlideAction(
                            caption: 'Edit',
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () {
                              (data["transaction_type"] == "Income")
                                  ? context
                                      .read<AddColorCheckCubit>()
                                      .incomeColor()
                                  : context
                                      .read<AddColorCheckCubit>()
                                      .expenseColor();
                              showEditDialog(
                                  context,
                                  documentId,
                                  data["transaction_date"],
                                  data["transaction_account"],
                                  data["transaction_category"],
                                  data["transaction_amount"],
                                  data["transaction_detail"]);
                            },
                          ),
                        ),
                      ],
                      secondaryActions: <Widget>[
                        Card(
                          child: IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () {
                                Api("entries").removeDocument(document.id);
                                context.read<CRUDCubit>().sumData();
                              }),
                        ),
                      ],
                      child: Card(
                        color: (data["transaction_type"] == "Income")
                            ? Colors.green.shade300.withOpacity(0.6)
                            : Colors.red.shade300.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0),
                        ),
                        child: ListTile(
                          leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (data["transaction_type"] == "Income")
                                  ? const Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.money_off,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                              Text(data["transaction_account"],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          title: Center(
                            child: Text(data["transaction_detail"],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 21)),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(data["transaction_category"],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13)),
                              Text(date,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13)),
                            ],
                          ),
                          trailing: Text(
                            amount.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onTap: () {},
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }
}

void _editDialog(BuildContext context) {
  var tecDate = TextEditingController();
  var tecAccount = TextEditingController();
  var tecCategory = TextEditingController();
  var tecAmount = TextEditingController();
  var tecDetail = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (receivedDate) {
                          selectedDate = receivedDate;
                          tecDate.text =
                              "${receivedDate.day}.${receivedDate.month}.${receivedDate.year}";
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(ctx).pop(),
                  )
                ],
              ),
            ));
  }

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit"),
          actions: [
            Container(
              child: BlocBuilder<AddColorCheckCubit, bool>(
                builder: (context, addColorCheck) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (addColorCheck)
                              ? Colors.green.withOpacity(0.9)
                              : Colors.red.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green.withOpacity(0.6))),
                                    onPressed: () {
                                      context
                                          .read<AddColorCheckCubit>()
                                          .incomeColor();
                                      tecDate.clear();
                                      tecAccount.clear();
                                      tecCategory.clear();
                                      tecAmount.clear();
                                      tecDetail.clear();
                                    },
                                    child: Text("Income"),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red.withOpacity(0.6))),
                                    onPressed: () {
                                      context
                                          .read<AddColorCheckCubit>()
                                          .expenseColor();
                                      tecDate.clear();
                                      tecAccount.clear();
                                      tecCategory.clear();
                                      tecAmount.clear();
                                      tecDetail.clear();
                                    },
                                    child: Text("Expense"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextField(
                                  controller: tecDate,
                                  keyboardType: TextInputType.none,
                                  decoration: const InputDecoration(
                                    labelText: "Date",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    if (tecDate.text.isNotEmpty) {
                                      _showDatePicker(context);
                                    } else {
                                      tecDate.text =
                                          "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}";
                                      _showDatePicker(context);
                                    }
                                  },
                                ),
                                Spacer(),
                                TextField(
                                  controller: tecAccount,
                                  keyboardType: TextInputType.none,
                                  decoration: const InputDecoration(
                                    labelText: "Account",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    showAccountDialog(context, tecAccount);
                                  },
                                ),
                                Spacer(),
                                TextField(
                                  controller: tecCategory,
                                  keyboardType: TextInputType.none,
                                  decoration: const InputDecoration(
                                    labelText: "Category",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    showCategoryDialog(context, tecCategory);
                                  },
                                ),
                                Spacer(),
                                TextField(
                                  controller: tecAmount,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: "Amount",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Spacer(),
                                TextFormField(
                                  controller: tecDetail,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    labelText: "Detail",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Spacer(),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          (addColorCheck)
                                              ? Colors.green.withOpacity(0.6)
                                              : Colors.red.withOpacity(0.6),
                                        )),
                                    onPressed: () {
                                      String transactionType = (addColorCheck)
                                          ? "Income"
                                          : "Expense";

                                      Map<String, dynamic> data = {
                                        "transaction_type": transactionType,
                                        "transaction_date":
                                            Timestamp.fromDate(selectedDate),
                                        "transaction_account": tecAccount.text,
                                        "transaction_category":
                                            tecCategory.text,
                                        //amount kayıt edilirken sayıyı nokta yada virgülle kayıt yaptır
                                        "transaction_amount": tecAmount.text,
                                        "transaction_detail": tecDetail.text,
                                      };

                                      Api("entries").addDocument(data, context);
                                      context.read<CRUDCubit>().sumData();
                                      //cubit ile save yaptır.
                                      //Buraya dinleme cubit yap save tıklanınca cubit ile textfield sıfırla
                                      tecDate.clear();
                                      tecAccount.clear();
                                      tecCategory.clear();
                                      tecAmount.clear();
                                      tecDetail.clear();
                                    },
                                    child: Text("Save")),
                                Spacer(),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      });
}
