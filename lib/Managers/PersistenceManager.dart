import 'package:flying_pokemon/Model/PokemonData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/PokemonData.dart';

class PersistenceManager {
  final _key = 'favorite';
  static final shared = PersistenceManager();

  load() async {
    final _prefs = await SharedPreferences.getInstance();
    final _data = _prefs.getString(_key);

    return Pokemon.decodePokemons(_data);
  }

  save(List<Pokemon> favorites) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString(_key, Pokemon.encodePokemon(favorites));
  }
}
