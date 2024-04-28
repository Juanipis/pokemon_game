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

  Future<Map<int, String>> fecthAllPokemonIdNameFrom0To1025() async {
    logger.i('fecthAllPokemonIdNameFrom0To1025');
    Map<int, String> pokemonIdNameMap = {};
    // to fecth all pokemon from 0 to 1025
    // we use this endpoint https://pokeapi.co/api/v2/pokemon?limit=302&offset=0
    // only we can fetch 302 pokemon per request
    // so we need to make request varying the offset until we reach 1025
    int offset = 0;
    int limit = 302;
    while (offset < 1025) {
      var url = Uri.https(pokemonApi, pokemonEnpoint,
          {'limit': limit.toString(), 'offset': offset.toString()});
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        var results = decodedResponse['results'] as List<dynamic>;
        for (var result in results) {
          var id =
              int.parse(result['url'].toString().split('/').reversed.first);
          pokemonIdNameMap[id] = result['name'];
        }
        offset += limit;
      } else {
        logger.e('fecthAllPokemonIdNameFrom0To100000 failed');
        throw Exception('Failed to load pokemon');
      }
    }
    logger.i('fecthAllPokemonIdNameFrom0To100000 success');
    return pokemonIdNameMap;
  }
}
