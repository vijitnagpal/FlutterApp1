import 'package:flutter/services.dart';

import './widget/chart.dart';
import 'package:flutter/material.dart';

import './widget/new_transaction.dart';
import './model/transactions.dart';
import './widget/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([
      // SystemChrome comes in services.dart package which helps in setting the orientation of the device
     //  DeviceOrientation.portraitUp,
     //   DeviceOrientation.portraitDown,
    //]);
    return MaterialApp(
      title: 'Expense Tracker',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String title;
  //String amount;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> _userTransaction = [
    /* Transactions(
      id: 't1',
      title: 'books',
      amount: 99.99,
      date: DateTime.now(),
    ),
    Transactions(
      id: 't2',
      title: 'food',
      amount: 69.99,
      date: DateTime.now(),
    ), */
  ];

  List<Transactions> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transactions(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransation(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  

  @override
  Widget build(BuildContext context) {
    final isLandscaped = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      //backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        'Weekly cost expenses', /*style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 40),*/
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );

    final transactionListTile = Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.6,
                      child:
                          TransactionList(_userTransaction, _deleteTransaction),
                    );
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
      ),
      home: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /* Container(
                width: double.infinity,
                child: Card(
                  color: Colors.blue,
                  child: Text('Card!'),
                  elevation: 5,
                ),
              ), */

             if(isLandscaped) Row(children: [
                Text('ShowChart'),
                Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    }),
              ]),

              if(!isLandscaped)Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.3,
                      child: Chart(_recentTransaction),
                    ),
              if(!isLandscaped)transactionListTile,

              if(isLandscaped)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransaction),
                    )
                  : transactionListTile
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ),
    );
  }
}
