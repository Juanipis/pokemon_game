import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';

class PokemonNamesBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService pokemonService;
  Map<int, String> pokemonNames = {
    1: 'bulbasaur',
    2: 'ivysaur',
    3: 'venusaur',
    4: 'charmander',
    5: 'charmeleon',
    6: 'charizard',
  };

  PokemonNamesBloc(this.pokemonService) : super(PokemonLoadingState()) {
    /*
    pokemonService.fecthAllPokemonIdNameFrom0To100000().then((names) {
      pokemonNames = names;
    }).catchError((error) {
      // Handle error
    });
    */
    on<GetRandomPokemonNamesEvent>((event, emit) async {
      try {
        // from the map of pokemon names we get a random subset of names
        // so using Math.NextInt we get a random index
        // and we get the name from the map
        // and put it in a list
        var randomPokemonNames = <String>[];
        var pokemonIndex = <int>[];
        for (var i = 0; i < event.count; i++) {
          var randomIndex = Random().nextInt(pokemonNames.length);
          //check if the index is already in the list
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
