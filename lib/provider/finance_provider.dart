import '../model/transaction_model.dart';
import 'package:flutter/material.dart';
import '../model/fin_model.dart';
import '../repository/repository.dart';
import '../database/database_conn.dart';

class FinanceProvider extends ChangeNotifier {
  Repository repository = Repository();
  DatabaseConnection databaseConnection = DatabaseConnection();

  List<FinanceModel> _finace = []; //make a local list
  List<TransactionModel> _transaction = [];

  List<FinanceModel> get finance => _finace; //read from ,local list
  List<TransactionModel> get transaction => _transaction;

  Future<void> addCustomer(FinanceModel fin) async {
    //addcustomer ie, insertion logic
    final fi = fin.toJson(); //assign to fi

    await repository.insertItems(
      'tab_fin',
      fi,
    ); //call repository to insert items with table name and model

    _finace.add(fin); //added to local list

    notifyListeners(); //change to ui
  }

  Future<void> loadLoans() async {
    // // isLoading = true;
    // notifyListeners();
    final data = await repository.readItems('tab_fin'); //read from database
    _finace = data
        .map<FinanceModel>((e) => FinanceModel.fromJson(e))
        .toList(); //
    // isLoading = false;
    notifyListeners();
  }

  Future<void> addAmount(String id, double amount) async {
    final index = _finace.indexWhere((e) => e.id == id);

    _finace[index].amountPaid = (_finace[index].amountPaid ?? 0) + amount;

    await repository.updateItems('tab_fin', _finace[index].toJson());

    notifyListeners();
  }

  Future<void> addFine(String id, double amount) async {
    final index = _finace.indexWhere((e) => e.id == id);

    _finace[index].fineAmount = (_finace[index].fineAmount ?? 0) + amount;

    await repository.updateItems('tab_fin', _finace[index].toJson());

    notifyListeners();
  }

  double get totalGiven {
    //this amount taken sum in this list totalAmount sum we calculate it
    return _finace.fold(0, (sum, item) => sum + (item.amountTaken ?? 0));
  }

  double get totalRecieved {
    //this amount taken sum in this list totalPaid sum we calculate it
    return _finace.fold(0, (sum, item) => sum + (item.amountPaid ?? 0));
  }

  double get totalPending {
    //this amount taken sum in this list totalBalance sum we calculate it
    return _finace.fold(0, (sum, item) => sum + (item.balance));
  }

  int get openLoans {
    return _finace.where((e) => e.status == "OPEN").length;
  }

  int get closedLoans {
    return _finace.where((e) => e.status == "CLOSED").length;
  }

  //TRANSACTION

  Future<void> loadTransaction(String id) async {
    // // isLoading = true;
    // notifyListeners();
    final db = await databaseConnection.database;

    final data = await db.query('tab_transaction'); //read from database
    _transaction = data
        .map<TransactionModel>((e) => TransactionModel.fromJson(e))
        .where((t) => t.loanId == id)
        .toList();
    notifyListeners();
  }

  //INSERT TRANSACTION
  Future<void> insertTransaction(TransactionModel tran) async {
    //addcustomer ie, insertion logic
    final tr = tran.toJson(); //assign to fi

    await repository.insertItems(
      'tab_transaction',
      tr,
    ); //call repository to insert items with table name and model

    _transaction.add(tran); //added to local list

    notifyListeners(); //change to ui
  }

  Future<void> searchFinance(String name) async {
    final items = await repository.searchName(name);

    _finace = items; // update state
    notifyListeners(); // update UI
  }

  Future<void> applySearchFilter(String filter) async {
    final items = await repository.filterLoans(filter);

    _finace = items;
    notifyListeners();
  }
}
