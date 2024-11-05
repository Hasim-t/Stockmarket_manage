import 'dart:convert'; 
import 'dart:developer';

import 'package:http/http.dart' as http;


String apiKey = '6GE3SY8VET9I0W69';

Future<Map<String, dynamic>?> gettingStockInfo(String symbol) async {
  try {
    final url = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=$symbol&apikey=$apiKey";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    log('Overview response status: ${response.statusCode}'); // Debugging
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      String companyName = json['Name'] ?? symbol;

      // Fetch the latest price
      final priceUrl = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&apikey=$apiKey";
      final priceResponse = await http.get(Uri.parse(priceUrl));
      log('Price response status: ${priceResponse.statusCode}'); // Debugging

      String latestClosePrice = 'N/A';
      if (priceResponse.statusCode == 200) {
        final priceJson = jsonDecode(priceResponse.body);
        if (priceJson['Time Series (Daily)'] != null) {
          latestClosePrice = priceJson['Time Series (Daily)'].entries.first.value['4. close'];
        }
      }

      log('Company Name: $companyName'); // Debugging
      log('Latest Close Price: $latestClosePrice'); // Debugging

      return {
        'companyName': companyName,
        'latestClosePrice': latestClosePrice,
      };
    } else {
      print('Error fetching overview: ${response.statusCode} - ${response.body}');
      return null; 
    }
  } catch (e) {
    print('Exception: ${e.toString()}');
    return null; 
  }
}

class StockSuggestionService {
  static const String apiKey = '6GE3SY8VET9I0W69';

  static Future<List<Map<String, String>>> getStockSuggestions(String query) async {
    // Using Alpha Vantage Symbol Search endpoint
    final url = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$apiKey";
    
    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}'); // Debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        log('Response body: $data'); // Debugging

        if (data['bestMatches'] != null) {
          return (data['bestMatches'] as List).map<Map<String, String>>((match) {
            return {
              'symbol': match['1. symbol'] ?? '',
              'name': match['2. name'] ?? '',
              'type': match['3. type'] ?? '',
              'region': match['4. region'] ?? '',
            };
          }).toList();
        }
      }
      return [];
    } catch (e) {
      log('Error fetching stock suggestions: $e');
      return [];
    }
  }
}
