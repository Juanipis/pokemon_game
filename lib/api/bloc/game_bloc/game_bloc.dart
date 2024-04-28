import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_game/api/bloc/game_bloc/game_event.dart';
import 'package:pokemon_game/api/bloc/game_bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  var _winCount = 0;
  var _loseCount = 0;

  GameBloc() : super(GameInitial()) {
    on<AddWinEvent>((event, emit) {
      emit(GameWinState(++_winCount, _loseCount));
    });

    on<AddLoseEvent>((event, emit) {
      emit(GameLoseState(winCount, ++_loseCount));
    });
  }
  get winCount => _winCount;
  get loseCount => _loseCount;
}
