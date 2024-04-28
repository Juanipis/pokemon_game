import 'package:equatable/equatable.dart';

abstract class GameState extends Equatable {}

class GameInitial extends GameState {
  @override
  List<Object> get props => [];
}

class GameWinState extends GameState {
  final int wins;
  final int loses;

  GameWinState(this.wins, this.loses);

  @override
  List<Object> get props => [wins];
}

class GameLoseState extends GameState {
  final int wins;
  final int loses;

  GameLoseState(this.wins, this.loses);

  @override
  List<Object> get props => [loses];
}
