import 'dart:convert';

class FlyingPokemon {
  FlyingPokemon({
    this.pokemon,
  });

  List<Pokemon> pokemon;

  factory FlyingPokemon.fromJson(Map<String, dynamic> json) {
    return FlyingPokemon(
        pokemon:
            List<Pokemon>.from(json["pokemon"].map((x) => Pokemon.fromJson(x))),
      );
  }
}

class Generation {
  String name;
  String url;

  Generation({
    this.name,
    this.url,
  });

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
        name: json["name"],
        url: json["url"],
      );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class Pokemon {
  Generation pokemon;
  int slot;

  Pokemon({
    this.pokemon,
    this.slot,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
        pokemon: Generation.fromJson(json["pokemon"]),
        slot: json["slot"],
      );
  }
  
  static Map<String, dynamic> toMap(Pokemon pokemon) => {
        "pokemon": pokemon.pokemon,
        "slot": pokemon.slot,
      };

  static String encodePokemon(List<Pokemon> pokemons) => json.encode(
    pokemons
      .map<Map<String, dynamic>>((pokemon) => Pokemon.toMap(pokemon)).toList(),
  );

  static List<Pokemon> decodePokemons(String pokemons) {
    print("decode");
    return (json.decode(pokemons)).map<Pokemon>((item) => Pokemon.fromJson(item)).toList();
  }
}
