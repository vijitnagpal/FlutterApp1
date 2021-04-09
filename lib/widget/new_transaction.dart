import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransation extends StatefulWidget {
  final Function newTx;

  NewTransation(this.newTx);

  @override
  _NewTransationState createState() => _NewTransationState();
}

class _NewTransationState extends State<NewTransation> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime _selectedDate;

  void submit() {
    // print(title);
    // print(amount);
    //print(titleController.text);
    //print(amountController.text);
    final entertitle = titleController.text;
    final enteramount = double.parse(amountController.text);

    if (entertitle.isEmpty || enteramount <= 0  || _selectedDate == null) {
      return;
    }
    widget.newTx(
      // widget is used to call function or variable from another class
      entertitle,
      enteramount,
      _selectedDate,
    );

    Navigator.of(context)
        .pop(); // Navigator is used to automatically return to homepage on entering the submit button using a pop() function
  }

  void _printdate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((dateselected) {
      if (dateselected == null) {
        return;
      }
      _selectedDate = dateselected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top:10,right:10,left:10,bottom:MediaQuery.of(context).viewInsets.bottom + 10), //viewInsets give information about the things that are coming in there way
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onSubmitted: (_) => submit,
                //onChanged: (val) => title = val,
                controller: titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submit,
                //onChanged: (val) => amount = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(child: Text(_selectedDate == null ? 'No date choosen' : DateFormat.yMd().format(_selectedDate))),
                    TextButton(
                      onPressed: _printdate,
                      child: Text(
                        'Choose date',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: submit,
                /* () {
                  // print(title);
                  // print(amount);
                  //print(titleController.text);
                  //print(amountController.text);
                  newTx(
                    titleController.text,
                    double.parse(amountController.text),
                  );
                }, */
                child: Text(
                  'Add Transaction',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
