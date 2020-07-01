import 'package:flying_pokemon/PokemonData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PokemonData.dart';

enum PersistenceActionType {
  add, remove
}

class PersistenceManager {
  final key = 'favorite';

  load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    return Pokemon.decodePokemons(data);
  }

  save(List<Pokemon> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, Pokemon.encodePokemon(favorites));
    print("saved");
  }
}
