import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_game/api/bloc/game_bloc/game_bloc.dart';
import 'package:pokemon_game/api/bloc/game_bloc/game_state.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_names_bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';
import 'package:pokemon_game/presentation/widgets/pokemon_view.dart';
import 'package:flutter_svg/svg.dart'; // Import flutter_svg package

void main() {
  final PokemonService pokemonService = PokemonService();
  runApp(MyApp(pokemonService: pokemonService));
}

class MyApp extends StatelessWidget {
  final PokemonService pokemonService;
  const MyApp({super.key, required this.pokemonService});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PokemonBloc>(
            create: (context) => PokemonBloc(pokemonService),
          ),
          BlocProvider(create: (context) => PokemonNamesBloc(pokemonService)),
          BlocProvider(create: (context) => GameBloc()),
        ],
        child: MaterialApp(
          title: 'Pokemon Game',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              buttonColor: Colors.yellowAccent,
            ),
          ),
          home: const MyHomePage(
            title: 'Flutter Pokemon Game',
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center title
          children: <Widget>[
            SvgPicture.asset(
                'images/pikachu.svg', // Replace with your actual asset path
                height: 40, // Adjust the size to fit your AppBar design
                width: 40,
                colorFilter: const ColorFilter.mode(
                    Colors.yellow,
                    BlendMode
                        .srcIn) // Adjust the size to fit your AppBar design
                ),
            const SizedBox(width: 10), // Space between icon and text
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily:
                    'YourCustomFont', // Replace with your actual font family
                fontSize: 24, // Adjust the size accordingly
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BlocBuilder<GameBloc, GameState>(builder: (context, state) {
                if (state is GameWinState) {
                  return Text(
                    'Wins: ${state.wins}, Loses: ${state.loses}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  );
                } else if (state is GameLoseState) {
                  return Text(
                    'Wins: ${state.wins}, Loses: ${state.loses}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  );
                }
                return Container();
              }),
              BlocBuilder<PokemonBloc, PokemonState>(builder: (context, state) {
                if (state is PokemonLoadingState) {
                  return const CircularProgressIndicator();
                } else if (state is PokemonLoadedState) {
                  return PokemonView(
                    pokemon: state.pokemon,
                    pokemonArtworkColor: state.pokemonArtworkColor,
                    pokemonArtworkBlackWhite: state.pokemonArtworkBlackWhite,
                  );
                } else if (state is PokemonErrorState) {
                  return Text(state.message);
                } else {
                  return const Text('Press the button to start the game');
                }
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.read<PokemonBloc>().add(GetPokemonByIdEvent(
                      Random().nextInt(1024) + 1,
                    ));
              },
              icon: const Icon(
                Icons.catching_pokemon,
                size: 30,
              ),
              label: const Text('Get Pokémon', style: TextStyle(fontSize: 16)),
              // to make an overlay on the button
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(Colors.red),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
