import '../widget/chartBar.dart';

import '../model/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Chart extends StatelessWidget {
  List<Transactions> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(
          Duration(days: index),
        );
        var totalSum = 0.0;
        for (var i = 0; i < recentTransaction.length; i++) {
          if (recentTransaction[i].date.day == weekDay.day &&
              recentTransaction[i].date.month == weekDay.month &&
              recentTransaction[i].date.year == weekDay.year) {
            totalSum += recentTransaction[i].amount;
          }
        }

        //print('day:'+ DateFormat.E().format(weekDay)+ 'Amount: '+ (totalSum.toStringAsFixed(2)));
        return {'day': DateFormat.E().format(weekDay), 'Amount': totalSum};
      },
    ).reversed.toList();
  }

  double get totalspending {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return sum + item['Amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(groupTransactionValues);
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data['day'],
                    data['Amount'],
                    totalspending == 0.0
                        ? 0.0
                        : (data['Amount'] as double) / totalspending),
              );
            }).toList(),
          ),
        ));
  }
}
