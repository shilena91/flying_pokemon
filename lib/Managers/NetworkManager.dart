import 'package:http/http.dart' as http;
import '../Model/PokemonData.dart';
import 'dart:convert';

class NetworkManager {
  static const String url = 'https://pokeapi.co/api/v2/type/3/';

  Future<List<Pokemon>> getPokemons() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return FlyingPokemon.fromJson(json.decode(response.body)).pokemon;
    }
    else {
      throw Exception('Failed to fetch pokemon data');
    }
  }
}
