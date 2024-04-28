import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_names_bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';
import 'package:pokemon_game/presentation/widgets/pokemon_view.dart';

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
          BlocProvider(create: (context) => PokemonNamesBloc(pokemonService))
        ],
        child: MaterialApp(
          title: 'Pokemon Game',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Flutter Pokemon Game'),
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BlocBuilder<PokemonBloc, PokemonState>(
                    builder: (context, state) {
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
                    return const Text('Press the button to get a Pokemon');
                  }
                })
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<PokemonBloc>().add(GetPokemonByIdEvent(
                  Random().nextInt(1025),
                ));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.play_arrow),
        ));
  }
}
