import 'package:flutter/material.dart';
import 'NetworkServices.dart';
import 'Pokemon.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon',
      home: FlyingPokemonList(),
    );
    throw UnimplementedError();
  }
}

class FlyingPokemonList extends StatefulWidget {
  @override
  FlyingPokemonListState createState() {
    return FlyingPokemonListState();
    throw UnimplementedError();
  }
}

class FlyingPokemonListState extends State<FlyingPokemonList> {
  Future<List<Pokemon>> flyingPokemons;
  final favouritePokemon = Set<Pokemon>();
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = true;
    flyingPokemons = NetworkServices().getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemons can fly'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: goToSaveRoute),
        ],
      ),
      body: bodyPokemonList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            flyingPokemons = NetworkServices().getPokemons();
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.update),
      ),
    );
    throw UnimplementedError();
  }

  Widget bodyPokemonList() {
    return FutureBuilder(
        future: flyingPokemons,
        builder: (context, pokemonSnap) {
          if (pokemonSnap.connectionState == ConnectionState.done) {
            if (pokemonSnap.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: pokemonSnap.data.length,
                itemBuilder: (context, i) {
                  if (i.isOdd) return Divider();
                  final index = i ~/ 2;
                  List<Pokemon> pokemonList = pokemonSnap.data;
                  return buildRow(pokemonList, index);
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        });

    // return ListView.builder(
    //   padding: EdgeInsets.all(16.0),
    //   itemBuilder: (context, i) {
    //     if (i.isOdd) return Divider();
    //     final index = i ~/ 2;
    //     flyingPokemons = FutureBuilder<FlyingPokemon>(
    //       future: fetchedData,
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return snapshot.data.pokemon;
    //         }
    //       }
    //       );

    //     return buildRow(flyingPokemons[index]);
    //   },
    //   );
  }

  Widget buildRow(List<Pokemon> pokemonList, int index) {
    final pokemonInThisRow = pokemonList[index];
    final pokemonName = pokemonInThisRow.pokemon.name;
    final alreadySaved = favouritePokemon.contains(pokemonInThisRow);

    return ListTile(
      title: Text(
        pokemonName,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          alreadySaved
              ? favouritePokemon.remove(pokemonInThisRow)
              : favouritePokemon.add(pokemonInThisRow);
        });
      },
    );
  }

  void goToSaveRoute() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        final tiles = favouritePokemon.map((Pokemon pokemon) {
          return ListTile(
            title: Text(
              pokemon.pokemon.name,
            ),
          );
        });
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Favourite Flying Pokemons'),
          ),
          body: ListView(children: divided),
        );
      }),
    );
  }
}
