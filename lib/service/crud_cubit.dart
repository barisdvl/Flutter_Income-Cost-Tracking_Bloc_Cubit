import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_cubit/service/crud_state.dart';

class CRUDCubit extends Cubit<CRUDState> {
  CRUDCubit() : super(BeginnerState());

  Future<void> sumData() async {
    try {
      double sumIncomeCash = 0;
      double sumExpenseCash = 0;
      double sumIncomeBank = 0;
      double sumExpenseBank = 0;
      double sumIncomeCreditCard = 0;
      double sumExpenseCreditCard = 0;
      double totalIncome = 0;
      double totalExpense = 0;
      double totalBalance = 0;

      List<Map<String, dynamic>> sumAccountList = [];
      List<Map<String, dynamic>> sumTotalList = [];

      await FirebaseFirestore.instance.collection('entries').get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach(
            (data) {
              if (data["transaction_type"] == "Income") {
                if (data["transaction_account"] == "Cash") {
                  sumIncomeCash =
                      sumIncomeCash + double.parse(data["transaction_amount"]);
                }
                if (data["transaction_account"] == "Bank") {
                  sumIncomeBank =
                      sumIncomeBank + double.parse(data["transaction_amount"]);
                }
                if (data["transaction_account"] == "Credit Card") {
                  sumIncomeCreditCard = sumIncomeCreditCard +
                      double.parse(data["transaction_amount"]);
                }
              }
              if (data["transaction_type"] == "Expense") {
                if (data["transaction_account"] == "Cash") {
                  sumExpenseCash =
                      sumExpenseCash + double.parse(data["transaction_amount"]);
                }
                if (data["transaction_account"] == "Bank") {
                  sumExpenseBank =
                      sumExpenseBank + double.parse(data["transaction_amount"]);
                }
                if (data["transaction_account"] == "Credit Card") {
                  sumExpenseCreditCard = sumExpenseCreditCard +
                      double.parse(data["transaction_amount"]);
                }
              }
            },
          );
        },
      );

      totalIncome = sumIncomeCash + sumIncomeBank + sumIncomeCreditCard;
      totalExpense = sumExpenseCash + sumExpenseBank + sumExpenseCreditCard;
      totalBalance = totalIncome - totalExpense;

      sumAccountList.add({
        "sumIncomeCash": sumIncomeCash,
        "sumExpenseCash": sumExpenseCash,
      });

      sumAccountList.add({
        "sumIncomeBank": sumIncomeBank,
        "sumExpenseBank": sumExpenseBank,
      });

      sumAccountList.add({
        "sumIncomeCredit Card": sumIncomeCreditCard,
        "sumExpenseCredit Card": sumExpenseCreditCard,
      });

      sumTotalList.add({
        "totalIncome": totalIncome,
        "totalExpense": totalExpense,
        "totalBalance": totalBalance,
      });

      emit(DatabaseLoaded(sumAccountList, sumTotalList));
    } catch (e) {
      emit(DatabaseError("Sum Total List Error"));
    }
  }
}
