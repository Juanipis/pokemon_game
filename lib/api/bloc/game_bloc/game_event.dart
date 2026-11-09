import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {}

class AddWinEvent extends GameEvent {
  AddWinEvent();

  @override
  List<Object> get props => [];
}

class AddLoseEvent extends GameEvent {
  AddLoseEvent();

  @override
  List<Object> get props => [];
}
