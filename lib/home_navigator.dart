import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:personal_expenses_2/bars/bottom_bar.dart';
import 'package:personal_expenses_2/constants.dart';
import 'package:personal_expenses_2/screens/chart.dart';
import 'package:personal_expenses_2/screens/history.dart';
import 'package:personal_expenses_2/screens/profile.dart';
import 'package:personal_expenses_2/screens/home.dart';
import 'package:personal_expenses_2/widgets/centered_fab.dart';
import 'models/Income.dart';
import 'models/Transactions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeNavigator extends StatefulWidget {
  static const routeName = 'HomeNavigator';
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final firebase_url = "personalapp-fc405-default-rtdb.firebaseio.com";

  List<Transaction> _transactions = [];
  List<Income> _incomes = [];
  double _expensesValue = 0;
  double _incomeValue = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    var a = DateTime.now();

    fetchIncome();
    fetchTransactions();
  }

  void fetchIncome() async{
    var url =  Uri.https(firebase_url,"incomes.json");
    var result = await http.get(url);
    var income_list = convert.jsonDecode(result.body) as Map<String, dynamic>;

    List<Income> kIncome = [];
    income_list.forEach((key, value) {
      var t = Income(
          id: key,
          amount: value["amount"],
          date:  DateTime.parse(value["date"]),
      );
      kIncome.add(t);
    });

    setState(() {
      _incomes = kIncome;
    });

    setIncomeValue(kIncome);

  }

  void fetchTransactions() async{
    //fetch transaction in init state
    var url =  Uri.https(firebase_url,"transactions.json");
    var result = await http.get(url);
    var transaction_list = convert.jsonDecode(result.body) as Map<String, dynamic>;

    List<Transaction> kTransactions = [];
    transaction_list.forEach((key, value) {
      var t = Transaction(
          id: key,
          amount: value["amount"],
          date:  DateTime.parse(value["date"]),
          title: value["title"],
          category: value["category"]
      );
      kTransactions.add(t);
    });

    setState(() {
      _transactions = kTransactions;
    });

    setExpensesValue(kTransactions);

  }


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _addNewTransaction(
      {String title, double amount, DateTime dateTime, Map category}) async {

    //update database
    var url =  Uri.https(firebase_url,"transactions.json");
    var result = await http.post(url,body:jsonEncode({
      "amount": amount,
      "date":dateTime.toString(),
      "title":title,
      "category":category
    }));

    final newTx = Transaction(
        title: title,
        amount: amount,
        date: dateTime,
        category: category,
        id: DateTime.now().toString());
    setState(() {
      _transactions.insert(0, newTx);
      _expensesValue += newTx.amount;
    });
  }

  void _addNewIncome(double value, DateTime date, String id) async{
    print(date);
    //update database
    var url =  Uri.https(firebase_url,"incomes.json");
    var result = await http.post(url,body:jsonEncode({
      "amount":value,
      "date":date.toString()
    }));
    _incomes.add(Income(
      amount: value,
      date: date,
      id: id,
    ));
    setState(() {
      _incomeValue += value;
    });
  }

  void setIncomeValue(List<Income> incomes_list) {
    for (int i = 0; i < incomes_list.length; i++) {
      _incomeValue += incomes_list[i].amount;
    }
  }

  void setExpensesValue(List<Transaction> transactions_list) {
    for (int i = 0; i < transactions_list.length; i++) {
      _expensesValue += transactions_list[i].amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: TabBarView(
        children: [
          Home(
            expensesValue: _expensesValue,
            incomeValue: _incomeValue,
            transactions: _transactions,
            updateIncome: _addNewIncome,
          ),
          History(
            transactions: _transactions,
          ),
          Chart(
            transactions: _transactions,
            incomes: _incomes,
          ),
          Profile(_transactions.length, _incomes.length),
        ],
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
      ),
      bottomNavigationBar: BottomNavBarFinal(
        tabController: _tabController,
      ),
      floatingActionButton: FAB(
          _addNewTransaction, _tabController, _incomeValue - _expensesValue),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
