import 'package:bloc/bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';
import 'package:pokemon_game/api/service/pokemon_to_black.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService pokemonService;
  PokemonBloc(this.pokemonService) : super(PokemonInitial()) {
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
  }
}
