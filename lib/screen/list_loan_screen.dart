import 'package:flutter/material.dart';
import '../provider/finance_provider.dart';
import '../model/fin_model.dart';

import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/finance_provider.dart';

import '../model/fin_model.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../screen/dashboard_screen.dart';
import '../model/transaction_model.dart';
import '../screen/transaction_screen.dart';
import '../widgets/ui.dart';

class ListLoanPage extends StatefulWidget {
  const ListLoanPage({super.key});

  @override
  State<ListLoanPage> createState() => _ListLoanPageState();
}

class _ListLoanPageState extends State<ListLoanPage> {
  TextEditingController _searchController = TextEditingController();

  String selectedFilter = 'ALL';

  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Filter"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              filterOption(context, "ALL"),
              filterOption(context, "OPEN"),
              filterOption(context, "CLOSED"),
            ],
          ),
        );
      },
    );
  }

  Widget filterOption(BuildContext context, String value) {
    return RadioListTile(
      title: Text(value),
      value: value,
      groupValue: selectedFilter,
      onChanged: (val) {
        setState(() {
          selectedFilter = val!;
        });
        context.read<FinanceProvider>().applySearchFilter(value);

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
            icon: Icon(Icons.dashboard),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Row(
            // children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<FinanceProvider>().searchFinance(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search Customer...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),

                  suffixIcon: IconButton(
                    onPressed: () {
                      showFilterDialog(context);
                    },
                    icon: Icon(Icons.tune),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            // ],
            // ),
            SizedBox(height: 10),
            Expanded(
              child: Consumer<FinanceProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: value.finance.length,
                    itemBuilder: (context, index) {
                      final loan = value.finance[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME + STATUS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loan.customerName ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: loan.balance == 0
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    loan.balance == 0 ? "Closed" : "Open",
                                    style: TextStyle(
                                      color: loan.balance == 0
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),

                            /// AMOUNTS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Given: ₹${loan.amountTaken}"),
                                Text("Paid: ₹${loan.amountPaid}"),
                              ],
                            ),

                            SizedBox(height: 6),

                            Text(
                              "Balance: ₹${loan.balance}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),

                            SizedBox(height: 12),

                            /// ACTION BUTTONS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                actionBtn(
                                  Icons.payment,
                                  "Pay",
                                  Colors.indigo,
                                  () {
                                    showPaymentSheet(context, loan);
                                    // showPaymentDialog(context, loan);
                                  },
                                ),

                                actionBtn(
                                  Icons.warning,
                                  "Fine",
                                  Colors.orange,
                                  () {
                                    showFineSheet(context, loan);
                                    // showFineDialog(context, loan);
                                  },
                                ),

                                IconButton(
                                  icon: Icon(Icons.visibility),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            TransactionPage(loanId: loan.id!),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );

                      // return appCard(
                      //   // elevation: 5,
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         loan.customerName ?? '',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),

                      //       SizedBox(height: 6),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text("₹${loan.amountTaken}"),
                      //           statusChip(loan.status),
                      //         ],
                      //       ),

                      //       SizedBox(height: 6),

                      //       Text("Balance: ₹${loan.balance}"),

                      //       SizedBox(height: 10),

                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           actionButton(Icons.payment, "Pay", () {
                      //             showPaymentDialog(context, loan);
                      //           }),

                      //           actionButton(Icons.warning, "Fine", () {
                      //             showFineDialog(context, loan);
                      //           }),

                      //           IconButton(
                      //             icon: Icon(Icons.visibility),
                      //             onPressed: () {
                      //               Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (_) =>
                      //                       TransactionPage(loanId: loan.id!),
                      //                 ),
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
      ),
    );
  }
}

// void showPaymentDialog(BuildContext context, FinanceModel loan) {
//   final controller = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Add Payment"),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(hintText: "Enter amount"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final amount = double.tryParse(controller.text) ?? 0;

//               await context.read<FinanceProvider>().addAmount(loan.id!, amount);
//               //transaction
//               final transaction = TransactionModel(
//                 id: Uuid().v4(),
//                 loanId: loan.id,
//                 type: 'CREDIT',
//                 amount: amount,
//                 date: DateTime.now().toString(),
//               );
//               await Provider.of<FinanceProvider>(
//                 context,
//                 listen: false,
//               ).insertTransaction(transaction);

//               Navigator.pop(context);
//             },
//             child: Text("Pay"),
//           ),
//         ],
//       );
//     },
//   );
// }

// void showFineDialog(BuildContext context, FinanceModel loan) {
//   final controller = TextEditingController();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Add Fine"),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(hintText: "Enter fine amount"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final fine = double.tryParse(controller.text) ?? 0;

//               await context.read<FinanceProvider>().addFine(loan.id!, fine);
//               //transaction
//               final transaction = TransactionModel(
//                 id: Uuid().v4(),
//                 loanId: loan.id,
//                 type: 'DEBIT',
//                 amount: fine,
//                 date: DateTime.now().toString(),
//               );
//               await Provider.of<FinanceProvider>(
//                 context,
//                 listen: false,
//               ).insertTransaction(transaction);

//               Navigator.pop(context);
//             },
//             child: Text("Add Fine"),
//           ),
//         ],
//       );
//     },
//   );
// }

void showPaymentSheet(BuildContext context, FinanceModel loan) {
  final controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TITLE
            Text(
              "Add Payment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            /// INPUT
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                prefixIcon: Icon(Icons.currency_rupee),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            /// BUTTON
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
                onPressed: () async {
                  final amount = double.tryParse(controller.text) ?? 0;

                  await context.read<FinanceProvider>().addAmount(
                    loan.id!,
                    amount,
                  );

                  /// TRANSACTION
                  final transaction = TransactionModel(
                    id: Uuid().v4(),
                    loanId: loan.id,
                    type: 'CREDIT',
                    amount: amount,
                    date: DateTime.now().toString(),
                  );

                  await context.read<FinanceProvider>().insertTransaction(
                    transaction,
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  "Confirm Payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showFineSheet(BuildContext context, FinanceModel loan) {
  final controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Fine",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter fine amount",
                prefixIcon: Icon(Icons.warning),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final fine = double.tryParse(controller.text) ?? 0;

                  await context.read<FinanceProvider>().addFine(loan.id!, fine);

                  final transaction = TransactionModel(
                    id: Uuid().v4(),
                    loanId: loan.id,
                    type: 'DEBIT',
                    amount: fine,
                    date: DateTime.now().toString(),
                  );

                  await context.read<FinanceProvider>().insertTransaction(
                    transaction,
                  );

                  Navigator.pop(context);
                },
                child: Text("Add Fine", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
