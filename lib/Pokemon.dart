// To parse this JSON data, do
//
//     final FlyingPokemon = FlyingPokemonFromJson(jsonString);

import 'dart:convert';

FlyingPokemon FlyingPokemonFromJson(String str) =>
    FlyingPokemon.fromJson(json.decode(str));

String FlyingPokemonToJson(FlyingPokemon data) => json.encode(data.toJson());

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

  Map<String, dynamic> toJson() => {
        "pokemon": List<dynamic>.from(pokemon.map((x) => x.toJson())),
      };
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
  
  Map<String, dynamic> toJson() => {
        "pokemon": pokemon.toJson(),
        "slot": slot,
      };
}
