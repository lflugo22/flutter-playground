import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'transaction_list.dart';
import 'new_transaction.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Dog Food',
      amount: 20.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Cat Food',
      amount: 16.99,
      date: DateTime.now(),
    ),
  ];

  void _addTransaction(String title, String amount) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: double.parse(amount),
      date: DateTime.now(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewTransaction(_addTransaction),
        TransactionList(_userTransactions),
      ],
    );
  }
}
