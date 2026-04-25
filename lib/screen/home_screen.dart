import 'dart:convert';

import '../model/transaction_model.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../provider/finance_provider.dart';

import '../model/fin_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/ui.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _amountTakenController = TextEditingController();
  TextEditingController _dateIssueController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _intrestController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void addFunction() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _amountTakenController.text.isEmpty ||
        _dateIssueController.text.isEmpty)
      return;

    final loan = FinanceModel(
      id: Uuid().v6(),
      customerName: _nameController.text,
      phoneNumber: _phoneController.text,
      dateIssued: (_dateIssueController.text),
      amountTaken: double.parse(_amountTakenController.text),
      amountPaid: 0,
      description: _descriptionController.text,
      interestRate: double.parse(_intrestController.text),
      fineAmount: 0,
    );
    String jsonData = jsonEncode(loan);
    print(jsonData);
    await Provider.of<FinanceProvider>(
      context,
      listen: false,
    ).addCustomer(loan);

    ///TRANSACTION
    final transaction = TransactionModel(
      id: Uuid().v4(),
      loanId: loan.id,
      type: 'DEBIT',
      amount: loan.amountTaken,
      date: DateTime.now().toString(),
    );
    await Provider.of<FinanceProvider>(
      context,
      listen: false,
    ).insertTransaction(transaction);
    func_clear();
  }

  void func_clear() {
    _nameController.clear();
    _phoneController.clear();
    _dateIssueController.clear();
    _amountTakenController.clear();
    _descriptionController.clear();
    _intrestController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Loan Registration Form'),
      ),

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       TextField(
      //         controller: _nameController,
      //         decoration: InputDecoration(hintText: 'Name'),
      //       ),
      //       TextField(
      //         controller: _phoneController,
      //         decoration: InputDecoration(hintText: 'phone'),
      //       ),
      //       TextField(
      //         controller: _dateIssueController,
      //         decoration: InputDecoration(hintText: 'DateIssued'),
      //       ),
      //       TextField(
      //         controller: _amountTakenController,
      //         decoration: InputDecoration(hintText: 'AmountTaken'),
      //       ),
      //       TextField(
      //         controller: _descriptionController,
      //         decoration: InputDecoration(hintText: 'Description'),
      //       ),

      //       TextField(
      //         controller: _intrestController,
      //         decoration: InputDecoration(hintText: 'intrest'),
      //       ),

      //       //  TextField(controller: _nameController,decoration: InputDecoration(hintText: 'Name'),),
      //       SizedBox(height: 10),
      //       ElevatedButton(
      //         onPressed: () {
      //           addFunction();
      //         },
      //         child: Text('ADD'),
      //       ),

      //       SizedBox(height: 10),
      //       Expanded(
      //         child: Consumer<FinanceProvider>(
      //           builder: (context, value, child) {
      //             return ListView.builder(
      //               itemCount: value.finance.length,
      //               itemBuilder: (context, index) {
      //                 final loan = value.finance[index];

      //                 return ListTile(
      //                   title: Text(loan.customerName ?? ''),
      //                   subtitle: Text(
      //                     "Balance: ₹${loan.balance} | Status: ${loan.status}",
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 HEADER
              Text(
                "Create Loan",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Enter customer and loan details",
                style: TextStyle(color: Colors.grey),
              ),

              SizedBox(height: 20),

              /// 🔥 FORM CARD
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildField(
                      controller: _nameController,
                      label: "Customer Name",
                      icon: Icons.person,
                      validator: (value) =>
                          value!.isEmpty ? "Enter name" : null,
                    ),

                    buildField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      keyboard: TextInputType.number,
                      validator: (value) =>
                          value!.length != 10 ? "Enter valid number" : null,
                    ),

                    // buildField(
                    //   controller: _dateIssueController,
                    //   label: "Taken Date",
                    //   icon: Icons.calendar_today,
                    //   validator: (value) =>
                    //       value!.isEmpty ? "Enter date" : null,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextFormField(
                        controller: _dateIssueController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Taken Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            /// 🔥 FORMAT DATE HERE
                            String formattedDate = DateFormat(
                              'dd-MM-yyyy',
                            ).format(pickedDate);

                            _dateIssueController.text = formattedDate;
                          }
                        },
                      ),
                    ),

                    buildField(
                      controller: _amountTakenController,
                      label: "Amount",
                      icon: Icons.currency_rupee,
                      keyboard: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Enter amount" : null,
                    ),

                    buildField(
                      controller: _intrestController,
                      label: "Interest %",
                      icon: Icons.percent,
                      keyboard: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? "Enter interest" : null,
                    ),

                    buildField(
                      controller: _descriptionController,
                      label: "Description (optional)",
                      icon: Icons.notes,
                    ),

                    SizedBox(height: 20),

                    /// 🔥 BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addFunction();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Loan created successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            /// 🔥 GO BACK TO LIST PAGE
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Create Loan",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
