import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stockmarketdata/db/model/stock_data_model.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  late Box<StockMarketModel> stockBox;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    stockBox = await Hive.openBox<StockMarketModel>('stockBox');
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteStock(int index) async {
    await stockBox.deleteAt(index);
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Watch list',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2), // Company name
                      1: FlexColumnWidth(1), // Price
                      2: FlexColumnWidth(1), // Action
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Company',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(
                        stockBox.length,
                        (index) {
                          final stock = stockBox.getAt(index);
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(stock?.name ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('\$${stock?.price ?? ''}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => deleteStock(index),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  if (stockBox.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No stocks in watchlist',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}