import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/models/pokemon_names.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';

class PokemonNamesBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService pokemonService;
  Map<int, String> pokemonNames = pokemonNamesMap;

  PokemonNamesBloc(this.pokemonService) : super(PokemonLoadingState()) {
    on<GetRandomPokemonNamesEvent>((event, emit) async {
      try {
        var randomPokemonNames = <String>[];
        var pokemonIndex = <int>[];
        for (var i = 0; i < event.count; i++) {
          var randomIndex = Random().nextInt(pokemonNames.length);
          while (pokemonIndex.contains(randomIndex)) {
            randomIndex = Random().nextInt(pokemonNames.length);
          }
          pokemonIndex.add(randomIndex);
          randomPokemonNames.add(pokemonNames[randomIndex + 1]!);
        }
        emit(PokemonRandomNamesState(randomPokemonNames));
      } catch (e) {
        emit(PokemonErrorState('Failed to load pokemon'));
      }
    });
  }
}
