import 'package:equatable/equatable.dart';
import 'package:pokemon_game/api/models/pokemon.dart';

abstract class PokemonState extends Equatable {}

class PokemonLoadingState extends PokemonState {
  @override
  List<Object> get props => [];
}

class PokemonLoadedState extends PokemonState {
  final Pokemon pokemon;

  PokemonLoadedState(this.pokemon);

  @override
  List<Object> get props => [pokemon];
}

class PokemonErrorState extends PokemonState {
  final String message;

  PokemonErrorState(this.message);

  @override
  List<Object> get props => [message];
}