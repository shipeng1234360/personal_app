import 'package:flutter/material.dart';
import 'package:personal_expenses_2/screens/add_income.dart';
import 'package:personal_expenses_2/models/Transactions.dart';
import 'package:personal_expenses_2/Widgets/top_card.dart';
import 'package:personal_expenses_2/widgets/see_all_section.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../Widgets/transaction_card.dart';

class Home extends StatelessWidget {
  static const String routeName = 'Home';
  final double incomeValue;
  final double expensesValue;
  final List<Transaction> transactions;
  final Function updateIncome;

  const Home({
    Key key,
    this.incomeValue,
    this.expensesValue,
    this.updateIncome,
    this.transactions,
  }) : super(key: key);

  // This is the function that will build the app bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Welcome Back, Daniel",
              style: TextStyle(
                  fontSize: ResponsiveFlutter.of(context).fontSize(2.5)),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: IconButton(
            color: Colors.amberAccent,
            icon: Icon(Icons.monetization_on),
            onPressed: () {
              _showModal(context: context);
            },
          ),
        )
      ],
    );
  }

  // This is to show the modal bottom sheet when the user clicks on the button
  void _showModal({BuildContext context}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddIncome(
          income: incomeValue,
          updateIncome: updateIncome,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // We get the real height after subtracting the app bar height and the status bar height
    final realHeight = MediaQuery.of(context).size.height -
        buildAppBar(context).preferredSize.height -
        MediaQuery.of(context).padding.top;

    final realWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context), //buildAppBar function is used here
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We get only 40% of the screen height for the top half
          Container(
            height: realHeight * 0.4,
            width: realWidth,
            child: TopHalf(
              income: incomeValue,
              expenses: expensesValue,
            ),
          ),
          SizedBox(
            height: realHeight * 0.025,
          ),
          SeeAllSection(
            transactions: transactions,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: realHeight * 0.01),
              height: realHeight * 0.45,
              padding: EdgeInsets.only(bottom: realHeight * 0.125),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: transactions.length <= 2
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.spaceEvenly,
                  children: transactions
                      .getRange(
                          0, transactions.length < 3 ? transactions.length : 3)
                      .map((tx) {
                    // This will map the TransactionCard widget to the list of transactions
                    return TransactionCard(
                      amount: tx.amount,
                      date: tx.date,
                      id: tx.id,
                      title: tx.title,
                      category: tx.category,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: realHeight * 0.009,
          ),
        ],
      ),
    );
  }
}
