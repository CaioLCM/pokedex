import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonApi {
  static Future<Map<String, dynamic>> searchPokemon(int number) async{
    final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon-form/$number/"));
    if (response.statusCode == 200){
      return json.decode(response.body);
    } else {
      throw Exception("Erro ao listar Pokemon $number");
    }
  }
}