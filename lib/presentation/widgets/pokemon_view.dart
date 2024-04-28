import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pokemon_game/api/bloc/game_bloc/game_bloc.dart';
import 'package:pokemon_game/api/bloc/game_bloc/game_event.dart';
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
  final player = AudioPlayer();
  Logger logger = Logger();
  bool isBlackAndWhite = true;
  String pokemonName = '';
  late ConfettiController _confettiController;
  bool win = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    pokemonName = widget.pokemon.name;
    if (!win) {
      BlocProvider.of<PokemonNamesBloc>(context)
          .add(GetRandomPokemonNamesEvent(count: 3));
    }

    return Column(
      children: [
        Image.memory(isBlackAndWhite
            ? widget.pokemonArtworkBlackWhite
            : widget.pokemonArtworkColor),

        const Text(
          "Who's That Pokémon?",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // then a bloc builder to show the random names
        BlocBuilder<PokemonNamesBloc, PokemonState>(
          builder: (context, state) {
            if (state is PokemonRandomNamesState) {
              var options = state.pokemonNames;
              if (!options.contains(pokemonName)) {
                options.add(pokemonName);
              }
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
                                win = true;
                                isBlackAndWhite = false;
                              });
                              _confettiController.play();
                              playSucces();

                              BlocProvider.of<PokemonNamesBloc>(context)
                                  .add(PokemonChosenEvent(e));

                              BlocProvider.of<GameBloc>(context)
                                  .add(AddWinEvent());

                              logger.i('You win');
                            } else {
                              playFailure();
                              BlocProvider.of<GameBloc>(context)
                                  .add(AddLoseEvent());
                              logger.i('You lose');
                            }
                          },
                          child: Text(
                            '${e[0].toUpperCase()}${e.substring(1)}',
                          ),
                        ))
                    .toList(),
              );
            } else if (state is PokemonChosenWin) {
              return Text(
                'You win, the pokemon is: ${pokemonName[0].toUpperCase()}${pokemonName.substring(1)}',
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              );
            } else {
              return const Text('No random names yet');
            }
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.7,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        )
      ],
    );
  }

  Future<void> playSucces() async {
    String audioPath = 'sounds/success.mp3';
    await player.play(AssetSource(audioPath));
  }

  Future<void> playFailure() async {
    String audioPath = 'sounds/failure.mp3';
    await player.play(AssetSource(audioPath));
  }
}
