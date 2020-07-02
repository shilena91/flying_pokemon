import 'package:flying_pokemon/Model/PokemonData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/PokemonData.dart';

class PersistenceManager {
  final key = 'favorite';
  static final shared = PersistenceManager();

  load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    return Pokemon.decodePokemons(data);
  }

  save(List<Pokemon> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, Pokemon.encodePokemon(favorites));
  }
}
