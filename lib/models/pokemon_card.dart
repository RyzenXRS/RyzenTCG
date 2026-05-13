class PokemonCardModel {
  final int id;
  final String name;
  final double price;
  final String description;

  PokemonCardModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory PokemonCardModel.fromJson(Map<String, dynamic> json) {
    return PokemonCardModel(
      id: json['id'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'],
    );
  }
}

// mengirim data kartu baru ke API
class CardRequestModel {
  final String name;
  final int price;
  final String description;

  CardRequestModel({
    required this.name,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price, 'description': description};
  }
}

// untuk submit
class SubmitTaskModel {
  final String name;
  final int price;
  final String description;
  final String githubUrl;

  SubmitTaskModel({
    required this.name,
    required this.price,
    required this.description,
    required this.githubUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'github_url': githubUrl,
    };
  }
}
