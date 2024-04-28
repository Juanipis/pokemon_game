import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:pokemon_game/api/models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonService {
  var logger = Logger();
  final String pokemonApi = 'pokeapi.co';
  final String pokemonEnpoint = '/api/v2/pokemon/';

  Future<Pokemon> fetchPokemon(int id) async {
    logger.i('fetchPokemon: $id');
    final String pokemonId = id.toString();
    var url = Uri.https(pokemonApi, pokemonEnpoint + pokemonId);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      logger.i('fetchPokemon: $id success');
      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return Pokemon.fromJson(decodedResponse);
    } else {
      logger.e('fetchPokemon: $id failed');
      throw Exception('Failed to load pokemon');
    }
  }
}
