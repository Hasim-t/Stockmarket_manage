import 'package:flutter/material.dart';
import 'package:stockmarketdata/db/model/stock_data_model.dart';

ValueNotifier<List<StockMarketModel>> stocklistNotifier = ValueNotifier([]);

void addstock(StockMarketModel value) {
  stocklistNotifier.value.add(value);
  print(value.toString());
}
