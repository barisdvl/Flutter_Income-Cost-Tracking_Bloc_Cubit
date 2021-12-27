import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_cubit/service/api.dart';

class CubitMain extends Cubit<int> {
  CubitMain() : super(0);
  void bottomIndex(int index) {
    int pageIndex = index;
    emit(pageIndex);
  }
}

class AccountViewCubit extends Cubit<int> {
  AccountViewCubit() : super(0);
  void accountViewIndex(int index) {
    int accountViewIndex = index;
    emit(accountViewIndex);
  }
}

class AddColorCheckCubit extends Cubit<bool> {
  AddColorCheckCubit() : super(true);
  void addColorCheck(bool check) {
    bool addColorCheck = check;
    emit(addColorCheck);
  }

  void incomeColor() {
    bool incomeColor = true;
    emit(incomeColor);
  }

  void expenseColor() {
    bool expenseColor = false;
    emit(expenseColor);
  }
}
