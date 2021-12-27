import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/service/api.dart';
import 'package:flutter_bloc_cubit/service/crud_cubit.dart';
import 'package:flutter_bloc_cubit/service/main_cubit.dart';
import 'package:flutter_bloc_cubit/widgets/account_list.dart';
import 'package:flutter_bloc_cubit/widgets/category_list.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
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
                          setState(() {
                            selectedDate = receivedDate;
                            tecDate.text =
                                "${receivedDate.day}.${receivedDate.month}.${receivedDate.year}";
                          });
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
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
              height: height * 0.87,
              width: width,
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
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.withOpacity(0.6))),
                            onPressed: () {
                              context.read<AddColorCheckCubit>().incomeColor();
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
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.red.withOpacity(0.6))),
                            onPressed: () {
                              context.read<AddColorCheckCubit>().expenseColor();
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
                                fixedSize: MaterialStateProperty.all<Size>(
                                    Size(width * 0.4, height * 0.07)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                  (addColorCheck)
                                      ? Colors.green.withOpacity(0.6)
                                      : Colors.red.withOpacity(0.6),
                                )),
                            onPressed: () {
                              String transactionType =
                                  (addColorCheck) ? "Income" : "Expense";

                              Map<String, dynamic> data = {
                                "transaction_type": transactionType,
                                "transaction_date":
                                    Timestamp.fromDate(selectedDate),
                                "transaction_account": tecAccount.text,
                                "transaction_category": tecCategory.text,
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
    );
  }
}
