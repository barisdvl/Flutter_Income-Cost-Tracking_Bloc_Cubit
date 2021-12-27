import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/service/api.dart';
import 'package:flutter_bloc_cubit/service/crud_cubit.dart';
import 'package:flutter_bloc_cubit/service/main_cubit.dart';
import 'package:flutter_bloc_cubit/widgets/account_list.dart';
import 'package:flutter_bloc_cubit/widgets/category_list.dart';

Future<void> showEditDialog(
  BuildContext context,
  transactionId,
  dateController,
  accountController,
  categoryController,
  amountController,
  detailController,
) {
  var tecDate = TextEditingController();
  var tecAccount = TextEditingController();
  var tecCategory = TextEditingController();
  var tecAmount = TextEditingController();
  var tecDetail = TextEditingController();

  DateTime selectedDate = dateController.toDate();
  tecDate.text =
      "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}";
  tecAccount.text = accountController;
  tecCategory.text = categoryController;
  tecAmount.text = amountController;
  tecDetail.text = detailController;

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

  return showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    transitionDuration: Duration(milliseconds: 400),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: BlocBuilder<AddColorCheckCubit, bool>(
                builder: (context, addColorCheck) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (addColorCheck) ? Colors.green : Colors.red,
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
                                      _showDatePicker(context);
                                      tecDate.text =
                                          "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}";
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

                                      Api("entries")
                                          .updateDocument(data, transactionId);
                                      context.read<CRUDCubit>().sumData();
                                      //cubit ile save yaptır.
                                      //Buraya dinleme cubit yap save tıklanınca cubit ile textfield sıfırla
                                      tecDate.clear();
                                      tecAccount.clear();
                                      tecCategory.clear();
                                      tecAmount.clear();
                                      tecDetail.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Edit")),
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
          ),
        ),
      );
    },
  );
}
