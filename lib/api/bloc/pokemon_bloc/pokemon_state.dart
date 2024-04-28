import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:pokemon_game/api/models/pokemon.dart';

abstract class PokemonState extends Equatable {}

class PokemonLoadingState extends PokemonState {
  @override
  List<Object> get props => [];
}

class PokemonLoadedState extends PokemonState {
  final Pokemon pokemon;
  final Uint8List pokemonArtworkColor;
  final Uint8List pokemonArtworkBlackWhite;

  PokemonLoadedState(
      this.pokemon, this.pokemonArtworkColor, this.pokemonArtworkBlackWhite);

  @override
  List<Object> get props => [pokemon];
}

class PokemonErrorState extends PokemonState {
  final String message;

  PokemonErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class PokemonRandomNamesState extends PokemonState {
  final List<String> pokemonNames;

  PokemonRandomNamesState(this.pokemonNames);

  @override
  List<Object> get props => [pokemonNames];
}
