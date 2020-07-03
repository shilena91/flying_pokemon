import 'package:http/http.dart' as http;
import '../Model/PokemonData.dart';
import 'dart:convert';

class NetworkManager {
  static const String _url = 'https://pokeapi.co/api/v2/type/3/';

  Future<List<Pokemon>> getPokemons() async {
    final _response = await http.get(_url);

    if (_response.statusCode == 200) {
      return FlyingPokemon.fromJson(json.decode(_response.body)).pokemon;
    } else {
      throw Exception('Failed to fetch pokemon data');
    }
  }
}
