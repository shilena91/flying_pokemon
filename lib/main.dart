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
  Future<List<Pokemon>> _flyingPokemons;
  PersistenceManager _persistenceManager = PersistenceManager.shared;
  var _favoritePokemon = List<Pokemon>();

  @override
  void initState() {
    super.initState();
    _flyingPokemons = NetworkManager().getPokemons();
    _loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemons can fly'),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _goToSaveRoute),
        ],
      ),
      body: _bodyPokemonList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _flyingPokemons = NetworkManager().getPokemons();
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.update),
      ),
    );
  }

  Widget _bodyPokemonList() {
    return FutureBuilder(
        future: _flyingPokemons,
        builder: (context, pokemonSnap) {
          if (pokemonSnap.connectionState == ConnectionState.done) {
            if (pokemonSnap.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: pokemonSnap.data.isNotEmpty
                    ? (pokemonSnap.data.length * 2) - 1
                    : 0,
                itemBuilder: (context, i) {
                  if (i.isOdd) return Divider();
                  final index = i ~/ 2;
                  List<Pokemon> pokemonList = pokemonSnap.data;
                  return _buildRow(pokemonList, index);
                },
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildRow(List<Pokemon> pokemonList, int index) {
    final pokemonInThisRow = pokemonList[index];
    final pokemonName = pokemonInThisRow.pokemon.name;
    bool alreadySaved = _checkAlreadySaved(_favoritePokemon, pokemonInThisRow);

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
              ? _favoritePokemon.removeWhere(
                  (item) => item.pokemon.name == pokemonInThisRow.pokemon.name)
              : _favoritePokemon.add(pokemonInThisRow);
          _persistenceManager.save(_favoritePokemon);
        });
      },
    );
  }

  _loadFavourites() {
    _persistenceManager.load().then((value) {
      _favoritePokemon = value;
    }).catchError((e) => print(e));
  }

  bool _checkAlreadySaved(List<Pokemon> favorite, Pokemon pokemon) {
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

  void _goToSaveRoute() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Favourite Flying Pokemons'),
          ),
          body: ListView.builder(
              itemCount: _favoritePokemon.isNotEmpty
                  ? (_favoritePokemon.length * 2) - 1
                  : 0,
              itemBuilder: (context, i) {
                if (i.isOdd)
                  return Divider(
                    height: 0.0,
                  );
                final index = i ~/ 2;
                final item = _favoritePokemon[index].pokemon.name;

                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(item),
                  onDismissed: (direction) {
                    setState(() {
                      _favoritePokemon.removeAt(i);
                      _persistenceManager.save(_favoritePokemon);
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
