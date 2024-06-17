import 'package:flutter/cupertino.dart';
import 'package:irc_stew/model/expense.dart';

class ExpenseDatabase extends ChangeNotifier
{
  // list of ALL expenses
  List<Expense> overallExpenseList = [];

  //get expense list
  List<Expense> getAllExpenseList()
  {
    return overallExpenseList;
  }

  void addNewExpense(Expense newExpense)
  {
    overallExpenseList.add(newExpense);
    notifyListeners();
  }

  void deleteExpense(Expense expense)
  {
    overallExpenseList.remove(expense);
    notifyListeners();
  }

  String getDayName(DateTime dateTime)
  {
    switch(dateTime.weekday)
    {
      case 1:
        return "Mon";
      case 2:
        return "Tue";
      case 3:
        return "Wed";
      case 4:
        return "Thu";
      case 5:
        return "Fri";
      case 6:
        return "Sat";
      case 7:
        return "Sun";
      default:
        return '';
    }
  }

  DateTime startOfWeekDate()
  {
    DateTime? startOfWeek;

    DateTime today = DateTime.now();

    for(int i=0; i<7; i++)
    {
      if(getDayName(today.subtract(Duration(days: i)))=='Sun')
      {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpense()
  {
    Map<String, double> dailyExpense = {};

    for(var expense in overallExpenseList)
    {
      String date = convertDateTimeToString(expense.dataTime);
      double amount = double.parse(expense.amount);

      if(dailyExpense.containsKey(date))
      {
        double currentAmount = dailyExpense[date]!;
        currentAmount += amount;
        dailyExpense[date] = currentAmount;
      }
      else
      {
        dailyExpense.addAll({date: amount});
      }
    }
    return dailyExpense;
  }

  String convertDateTimeToString(DateTime datetime)
  {
    String year = datetime.year.toString();

    String month = datetime.month.toString();
    if(month.length == 1)
    {
      month = '0$month';
    }

    String day = datetime.day.toString();
    if(day.length == 1)
    {
      day = '0$day';
    }

    String yyyymmdd = year + month + day;

    return yyyymmdd;
  }

}
