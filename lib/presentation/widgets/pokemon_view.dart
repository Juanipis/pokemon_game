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
        Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.memory(
              isBlackAndWhite
                  ? widget.pokemonArtworkBlackWhite
                  : widget.pokemonArtworkColor,
              key: ValueKey(isBlackAndWhite),
              height: 400,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Who's That Pokémon?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        // then a bloc builder to show the random names
        BlocBuilder<PokemonNamesBloc, PokemonState>(
          builder: (context, state) {
            if (state is PokemonRandomNamesState) {
              var options = List<String>.from(state.pokemonNames);
              if (!options.contains(pokemonName)) {
                options.add(
                    pokemonName); // Ensure the correct name is in the options.
              }
              options
                  .shuffle(); // Shuffle the options to randomize their order.

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: options.map((name) {
                    return ElevatedButton(
                      onPressed: () {
                        if (name == pokemonName) {
                          setState(() {
                            win = true;
                            isBlackAndWhite = false;
                          });
                          _confettiController.play();
                          playSucces();
                          BlocProvider.of<PokemonNamesBloc>(context)
                              .add(PokemonChosenEvent(name));
                          BlocProvider.of<GameBloc>(context).add(AddWinEvent());
                          logger.i('You win');
                        } else {
                          playFailure();
                          BlocProvider.of<GameBloc>(context)
                              .add(AddLoseEvent());
                          logger.i('You lose');
                        }
                      },
                      child: Text(
                        name.substring(0, 1).toUpperCase() +
                            name.substring(1), // Capitalize the first letter
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else if (state is PokemonChosenWin) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Correct! It\'s ${pokemonName[0].toUpperCase()}${pokemonName.substring(1)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else if (state is PokemonErrorState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              );
            } else {
              // This covers the initial state or any unhandled state
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Guess the Pokémon name!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
        ),

        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag:
                0.05, // increase the drag so that the confetti falls slower
            emissionFrequency: 0.6,
            numberOfParticles: 10, // a lot of particles at once
            gravity: 0.2,
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
