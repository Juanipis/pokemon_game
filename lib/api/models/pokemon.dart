class OfficialArtwork {
  final Uri? frontDefault;
  final Uri? frontShiny;

  OfficialArtwork({required this.frontDefault, required this.frontShiny});

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    return OfficialArtwork(
        frontDefault: json['front_default'] != null
            ? Uri.parse(json['front_default'])
            : null,
        frontShiny: json['front_shiny'] != null
            ? Uri.parse(json['front_shiny'])
            : null);
  }
}

class Sprites {
  final OfficialArtwork officialArtwork;

  Sprites({required this.officialArtwork});

  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
        officialArtwork:
            OfficialArtwork.fromJson(json['other']['official-artwork']));
  }
}

class Pokemon {
  final String id;
  final String name;
  final int baseExperience;
  final int height;
  final int weight;
  final Sprites sprites;

  Pokemon(
      {required this.id,
      required this.name,
      required this.baseExperience,
      required this.height,
      required this.weight,
      required this.sprites});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
        id: json['id'].toString(),
        name: json['name'],
        baseExperience: json['base_experience'],
        height: json['height'],
        weight: json['weight'],
        sprites: Sprites.fromJson(json['sprites']));
  }
}
