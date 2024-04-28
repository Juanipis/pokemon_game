import 'package:bloc/bloc.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_event.dart';
import 'package:pokemon_game/api/bloc/pokemon_bloc/pokemon_state.dart';
import 'package:pokemon_game/api/service/pokemon_service.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService pokemonService;

  PokemonBloc(this.pokemonService) : super(PokemonLoadingState()) {
    on<GetPokemonByIdEvent>((event, emit) async {
      emit(PokemonLoadingState());
      try {
        var pokemon = await pokemonService.fetchPokemon(event.id);
        emit(PokemonLoadedState(pokemon));
      } catch (e) {
        emit(PokemonErrorState('Failed to load pokemon'));
      }
    });
  }
}
