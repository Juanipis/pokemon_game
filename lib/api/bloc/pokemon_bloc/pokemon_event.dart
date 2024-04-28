import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {}

class GetPokemonByIdEvent extends PokemonEvent {
  final int id;

  GetPokemonByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetRandomPokemonNamesEvent extends PokemonEvent {
  final int count;

  GetRandomPokemonNamesEvent({required this.count});
  @override
  List<Object> get props => [];
}

class PokemonChosenEvent extends PokemonEvent {
  final String pokemonName;

  PokemonChosenEvent(this.pokemonName);

  @override
  List<Object> get props => [pokemonName];
}
