import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pokemon_game/api/models/pokemon.dart';

class PokemonView extends StatefulWidget {
  final Pokemon pokemon;
  final Uint8List pokemonArtworkColor;
  final Uint8List pokemonArtworkBlackWhite;

  const PokemonView(
      {super.key,
      required this.pokemon,
      required this.pokemonArtworkColor,
      required this.pokemonArtworkBlackWhite});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  Logger logger = Logger();
  bool isBlackAndWhite = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Pokemon:'),
        Text('Name: ${widget.pokemon.name}'),
        Text('Height: ${widget.pokemon.height}'),
        Text('Weight: ${widget.pokemon.weight}'),

        // Display the image in black and white if the isBlackAndWhite is true
        Image.memory(isBlackAndWhite
            ? widget.pokemonArtworkBlackWhite
            : widget.pokemonArtworkColor),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isBlackAndWhite = !isBlackAndWhite;
            });
          },
          child: Text(isBlackAndWhite
              ? 'Show Colored Image'
              : 'Show Black and White Image'),
        ),
      ],
    );
  }
}
