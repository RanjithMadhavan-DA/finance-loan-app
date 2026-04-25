import 'package:flutter/material.dart';
import '../provider/finance_provider.dart';
import 'dart:convert';
import '../provider/finance_provider.dart';
import '../model/transaction_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, this.loanId});

  final String? loanId;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String formatDate(String date) {
    final dt = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FinanceProvider>().loadTransaction(widget.loanId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Transaction History'),
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: Text(
          //     "Transaction History",
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          // ),
          Expanded(
            child: Consumer<FinanceProvider>(
              builder: (context, value, child) {
                final transactions = value.transaction
                    .where((t) => t.loanId == widget.loanId)
                    .toList();

                if (transactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("No Transactions Yet"),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Transaction Summary",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Total: ₹${transactions.fold(0.0, (sum, t) => sum + t.amount!)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];

                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            padding: EdgeInsets.all(14),
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
                            child: Row(
                              children: [
                                /// LEFT ICON
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: tx.type == "CREDIT"
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    tx.type == "CREDIT"
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: tx.type == "CREDIT"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),

                                SizedBox(width: 12),

                                /// TEXT SECTION
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.type == "CREDIT"
                                            ? "Payment Received"
                                            : "Amount Added",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),

                                      SizedBox(height: 4),

                                      Text(
                                        formatDate(tx.date ?? ""),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// AMOUNT
                                Text(
                                  "${tx.type == "CREDIT" ? "+" : "-"} ₹${tx.amount}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: tx.type == "CREDIT"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );

                          // return Card(
                          //   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          //   elevation: 3,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(12),
                          //     child: Row(
                          //       children: [
                          //         /// ICON
                          //         CircleAvatar(
                          //           radius: 22,
                          //           backgroundColor: tx.type == "CREDIT"
                          //               ? Colors.green.shade100
                          //               : Colors.red.shade100,
                          //           child: Icon(
                          //             tx.type == "CREDIT"
                          //                 ? Icons.arrow_downward
                          //                 : Icons.arrow_upward,
                          //             color: tx.type == "CREDIT"
                          //                 ? Colors.green
                          //                 : Colors.red,
                          //           ),
                          //         ),

                          //         SizedBox(width: 12),

                          //         /// TEXT SECTION
                          //         Expanded(
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: [
                          //               Text(
                          //                 tx.type == "CREDIT"
                          //                     ? "Payment Received"
                          //                     : "Amount Added",
                          //                 style: TextStyle(
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 15,
                          //                 ),
                          //               ),

                          //               SizedBox(height: 4),

                          //               Text(
                          //                 tx.date ?? '',
                          //                 style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontSize: 12,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),

                          //         /// AMOUNT
                          //         Column(
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           children: [
                          //             Text(
                          //               "₹${tx.amount}",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 16,
                          //                 color: tx.type == "CREDIT"
                          //                     ? Colors.green
                          //                     : Colors.red,
                          //               ),
                          //             ),

                          //             SizedBox(height: 4),

                          //             Container(
                          //               padding: EdgeInsets.symmetric(
                          //                 horizontal: 6,
                          //                 vertical: 2,
                          //               ),
                          //               decoration: BoxDecoration(
                          //                 color: tx.type == "CREDIT"
                          //                     ? Colors.green.shade50
                          //                     : Colors.red.shade50,
                          //                 borderRadius: BorderRadius.circular(6),
                          //               ),
                          //               child: Text(
                          //                 tx.type!,
                          //                 style: TextStyle(
                          //                   fontSize: 10,
                          //                   color: tx.type == "CREDIT"
                          //                       ? Colors.green
                          //                       : Colors.red,
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );

                          // premium card here
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
