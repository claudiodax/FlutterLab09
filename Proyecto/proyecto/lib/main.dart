import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart'; // En el primer Codelabs nos muestra como agregar librerias a nuestro proyecto en este caso english_words
// En el tercer paso del Primer Codelab nos hace crear un List view infinito con palabras ramdon
// EN el Segundo COdelab agregamos simbolos y funcionalidad a la lista

//Para poder llegar a esta parte se hizo la primera parte del CodeLabs
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de nombres',
      theme: ThemeData(
        //cambiar el color de la barra superior
        primaryColor: Colors.red,
      ),
      home: RandomWords(),
    );
  }
}

// este es un widget sin estado que llama a un widget con estado
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

//Este es un widget con estado
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{}; // Se agrega un nueva variable a la clase random
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generador de nombres'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              onPressed:
                  _pushSaved), // boton con icono de lista y llamado de la funcion pushSaved
        ],
      ),
      body: _buildSuggestions(),
    );
  }

// funcion para Navigator
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //muestra un elemento Scaffold que contiene la barra de la aplicación de la ruta nueva, que se llama SavedSuggestions.
          //El cuerpo de la ruta nueva incluye una ListView que contiene las filas de ListTiles(las palabras marcadas como favoritas).
          // Cada fila está separada por una línea divisoria.
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        //El itemBuilder callback  se llama una vez por combinación de palabras sugeridas y coloca cada sugerencia en una ListTile row
        //Para filas pares, la función agrega una ListTile row para el emparejamiento de palabras.
        //Para filas impares, la función agrega un widget Divider para separar visualmente las entradas.
        itemBuilder: (BuildContext _context, int i) {
          // añade un widget de un pixel de alto antes de cada fila en la Lista
          if (i.isOdd) {
            return Divider();
          }
          // esta constante y sentecia if hacen que el valor se divida entre 2 y se redondee para hacer un integer
          //el resultado seria 0 1 1 2 2 3 3 ...
          // esto para colocar el divisor y la palabra en la lista
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            //si se llega al final la lista esta funcion if añade 10 espacios mas
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

// Contenedor de la palabra random
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        // Se agrega el icono a la lista
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // Se agrega funcionalidad al icono
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}