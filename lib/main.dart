import 'package:flutter/material.dart';
import 'Managers/PersistenceManager.dart';
import 'Managers/NetworkManager.dart';
import 'Model/PokemonData.dart';

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
  }
}

class FlyingPokemonList extends StatefulWidget {
  @override
  FlyingPokemonListState createState() {
    return FlyingPokemonListState();
  }
}

class FlyingPokemonListState extends State<FlyingPokemonList> {
  Future<List<Pokemon>> flyingPokemons;
  PersistenceManager persistenceManager = PersistenceManager.shared;
  var favoritePokemon = List<Pokemon>();
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = true;
    flyingPokemons = NetworkManager().getPokemons();
    loadFavourites();
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
            flyingPokemons = NetworkManager().getPokemons();
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.update),
      ),
    );
  }

  Widget bodyPokemonList() {
    return FutureBuilder(
        future: flyingPokemons,
        builder: (context, pokemonSnap) {
          if (pokemonSnap.connectionState == ConnectionState.done) {
            if (pokemonSnap.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: (pokemonSnap.data.length * 2) - 1,
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
  }

  Widget buildRow(List<Pokemon> pokemonList, int index) {
    final pokemonInThisRow = pokemonList[index];
    final pokemonName = pokemonInThisRow.pokemon.name;
    bool alreadySaved = checkAlreadySaved(favoritePokemon, pokemonInThisRow);

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
          print(alreadySaved);
          print(favoritePokemon);
          alreadySaved
              ? favoritePokemon.removeWhere(
                  (item) => item.pokemon.name == pokemonInThisRow.pokemon.name)
              : favoritePokemon.add(pokemonInThisRow);
          print(favoritePokemon);
          persistenceManager.save(favoritePokemon);
        });
      },
    );
  }

  loadFavourites() {
    persistenceManager.load().then((value) {
      favoritePokemon = value;
    }).catchError((e) => print(e));
  }

  bool checkAlreadySaved(List<Pokemon> favorite, Pokemon pokemon) {
    final name = pokemon.pokemon.name;
    bool saved = false;

    favorite.forEach((element) {
      if (element.pokemon.name == name) {
        saved = true;
        return;
      }
    });
    return saved;
  }

  void goToSaveRoute() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Favourite Flying Pokemons'),
          ),
          body: ListView.builder(
              itemCount: (favoritePokemon.length * 2) - 1,
              itemBuilder: (context, i) {
                if (i.isOdd)
                  return Divider(
                    height: 0.0,
                  );
                final index = i ~/ 2;
                final item = favoritePokemon[index].pokemon.name;

                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(item),
                  onDismissed: (direction) {
                    setState(() {
                      favoritePokemon.removeAt(i);
                      persistenceManager.save(favoritePokemon);
                    });
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('$item deleted!'),
                    ));
                  },
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(title: Text('$item')),
                );
              }),
        );
      }),
    );
  }
}
