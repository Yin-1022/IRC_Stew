import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:irc_stew/data/expense_database.dart';
import 'package:irc_stew/model/expense.dart';
import 'package:irc_stew/view/expense_tracker/expense_tile.dart';
import 'package:provider/provider.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker>
{
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  void addNewExpense()
  {
    showDialog
    (
        context: context,
        builder: (context) => AlertDialog
        (
            title: const Text('增加新開銷'),
            content: Column
            (
              mainAxisSize: MainAxisSize.min,
              children:
              [
                TextField
                (
                  controller: newExpenseNameController,
                ),
                TextField
                (
                  controller: newExpenseAmountController,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          actions:
          [
            Row
            (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton
                (
                  onPressed: cancel,
                  child: const Text("取消",style: TextStyle(fontSize: 20),),
                ),
                MaterialButton
                (
                  onPressed: save,
                  child: const Text("儲存",style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
          ],
        ),
    );
  }

  void save()
  {
    Expense newExpense = Expense
    (
        name: newExpenseNameController.text,
        amount: newExpenseAmountController.text,
        dataTime: DateTime.now()
    );
    Provider.of<ExpenseDatabase>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
    clear();
  }

  void cancel()
  {
    Navigator.pop(context);
    clear();
  }

  void clear()
  {
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context)
  {
    return Consumer<ExpenseDatabase>
    (
      builder: (context, value, child) => Scaffold
      (
        resizeToAvoidBottomInset : false,
        appBar: AppBar(title: const Text("開銷"),backgroundColor: Colors.grey.shade300,),
        backgroundColor: Colors.grey.shade500,
        floatingActionButton: FloatingActionButton
        (
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView
        (
          children:
          [
            ListView.builder
            (
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile
                (
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dataTime
                )
            ),
          ],
        )
      ),
    );
  }
}
