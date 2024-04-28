import 'package:bloc/bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';
import 'package:pokemon_game/api/service/pokemon_to_black.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService pokemonService;
  Map<int, String> pokemonNames = {
    1: 'bulbasaur',
    2: 'ivysaur',
    3: 'venusaur',
    4: 'charmander',
    5: 'charmeleon',
    6: 'charizard',
  };

  PokemonBloc(this.pokemonService) : super(PokemonLoadingState()) {
    /*
    pokemonService.fecthAllPokemonIdNameFrom0To100000().then((names) {
      pokemonNames = names;
    }).catchError((error) {
      // Handle error
    });
    */
    on<GetPokemonByIdEvent>((event, emit) async {
      emit(PokemonLoadingState());
      try {
        var pokemon = await pokemonService.fetchPokemon(event.id);
        var pokemonArtList = await convertToBlackAndWhite(
            pokemon.sprites.officialArtwork.frontDefault!);
        emit(PokemonLoadedState(pokemon, pokemonArtList.$1, pokemonArtList.$2));
      } catch (e) {
        emit(PokemonErrorState('Failed to load pokemon'));
      }
    });

    on<GetRandomPokemonNamesEvent>((event, emit) async {
      emit(PokemonLoadingState());
      try {
        // from the map of pokemon names we get a random subset of names
        // from event.count we have the number of names we want
        Map<int, String> randomPokemonNames = {};
        // using the map of pokemon names we get a random subset of names
        for (int i = 0; i < event.count; i++) {
          var randomIndex = (pokemonNames.length * (i + 1) / event.count)
              .floor(); // we get a random index
          var randomPokemon = pokemonNames.entries.elementAt(randomIndex);
          randomPokemonNames[randomPokemon.key] = randomPokemon.value;
        }
        emit(PokemonRandomNamesState(randomPokemonNames));
      } catch (e) {
        emit(PokemonErrorState('Failed to load pokemon'));
      }
    });
  }
}
