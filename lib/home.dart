import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stockmarketdata/db/model/stock_data_model.dart';
import 'package:stockmarketdata/services/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  List<Map<String, String>> _suggestions = [];
  bool isLoading = false;
  Timer? debounceTimer;
  

  void _searchStock(String symbol) async {
    if (symbol.isEmpty) {
      setState(() {
        _result = '';
        _suggestions = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await gettingStockInfo(symbol);
    if (response != null) {
      setState(() {
        _result =
            'Company: ${response['companyName']}\nPrice: \$${response['latestClosePrice']}';
        isLoading = false;
        _suggestions = []; // Clear suggestions after selecting
      });
    } else {
      setState(() {
        _result = 'No data available';
        isLoading = false;
      });
    }
  }

  void fetchSuggestions(String query) {
    // Cancel any existing timer
    debounceTimer?.cancel();

   
    debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.length >= 1) {
        final suggestions =
            await StockSuggestionService.getStockSuggestions(query);
        setState(() {
          _suggestions = suggestions;
          _result = ''; // Clear previous results while suggesting
        });
      } else {
        setState(() {
          _suggestions = [];
          _result = '';
        });
      }
    });
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
           const  Text('Stock Market Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                fetchSuggestions(value);
              },
              decoration: InputDecoration(
                hintText: 'Enter Stock Symbol or Company Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (_suggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return ListTile(
                      title: Text(
                          '${suggestion['symbol']} - ${suggestion['name']}'),
                      subtitle: Text(
                          'Type: ${suggestion['type']}, Region: ${suggestion['region']}'),
                      onTap: () {
                   
                      },
                      trailing: IconButton(onPressed: ()=>onAddStockbuttonClicked(suggestion), icon: const Icon(Icons.add)),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            if (isLoading)
            const   Center(child: CircularProgressIndicator())
            else if (_result.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _result,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> onAddStockbuttonClicked(Map<String, String> stockData) async {
    try {
      final stockBox = await Hive.openBox<StockMarketModel>('stockBox');
      
      // Get stock price
      final stockInfo = await gettingStockInfo(stockData['symbol'] ?? '');
      if (stockInfo != null) {
        final stockModel = StockMarketModel(
          name: '${stockData['symbol']} - ${stockData['name']}',
          price: stockInfo['latestClosePrice'],
        );
        
        await stockBox.add(stockModel);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stock added to watchlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding stock to watchlist')),
      );
    }
  }
}
