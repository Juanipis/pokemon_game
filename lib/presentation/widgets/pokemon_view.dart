import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_names_bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
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
  String pokemonName = '';

  @override
  Widget build(BuildContext context) {
    pokemonName = widget.pokemon.name;
    BlocProvider.of<PokemonNamesBloc>(context)
        .add(GetRandomPokemonNamesEvent(count: 3));
    return Column(
      children: [
        const Text('Pokemon:'),
        Image.memory(isBlackAndWhite
            ? widget.pokemonArtworkBlackWhite
            : widget.pokemonArtworkColor),

        const Text('What is the name of this pokemon?'),
        // then a bloc builder to show the random names
        BlocBuilder<PokemonNamesBloc, PokemonState>(
          builder: (context, state) {
            if (state is PokemonRandomNamesState) {
              var options = state.pokemonNames;
              // check if the right answer is in the list
              if (!options.contains(pokemonName)) {
                options.add(pokemonName);
              }

              // sort randomly the list
              options.shuffle();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // We are making a game where we have to guess the pokemon
                // So each option is a buttom, if we click on the right one
                // we win, if we click on the wrong one we lose
                // we need to add the rigth answer to the list of options
                // so we can check if the user clicked on the right one
                children: options
                    .map((e) => ElevatedButton(
                          onPressed: () {
                            if (e == pokemonName) {
                              setState(() {
                                isBlackAndWhite = false;
                              });
                              logger.i('You win');
                            } else {
                              logger.i('You lose');
                            }
                          },
                          child: Text(e),
                        ))
                    .toList(),
              );
            } else {
              return const Text('No random names yet');
            }
          },
        ),
      ],
    );
  }
}
