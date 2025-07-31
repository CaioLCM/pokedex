import 'dart:convert';
import 'package:http/http.dart' as http;

class MongoServer {
  static const String apiUrl = 'https://pokedex-api-lmk9.onrender.com/api/v1/pokedex';

  static Future<void> postPokemon(Map<String, dynamic> pokemon) async{
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userID": "10428fd9-6ab5-4df0-9322-defdf25c98db", "pokemonID": pokemon["id"]})
    );
  }

  static Future<List<String>> listarPokemonsCapturados() async{
    final response = await http.get(Uri.parse("https://pokedex-api-lmk9.onrender.com/api/v1/pokedex/10428fd9-6ab5-4df0-9322-defdf25c98db"));
    final body = json.decode(response.body);
    List<String> lista = (body["data"]["pokemon"] as List).map((item) => item["pokemonID"].toString()).toList();
    return lista;
  }
}