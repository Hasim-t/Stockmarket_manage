import 'package:hive/hive.dart';
part 'stock_data_model.g.dart';

@HiveType(typeId: 1)
class StockMarketModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String price;

  StockMarketModel({required this.name, required this.price});
}
