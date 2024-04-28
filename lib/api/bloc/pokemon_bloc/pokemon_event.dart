import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {}

class GetPokemonByIdEvent extends PokemonEvent {
  final int id;

  GetPokemonByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
