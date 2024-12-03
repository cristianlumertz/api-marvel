class Character {
  final String name;
  final String description;
  final String thumbnail;


  const Character ({required this.name, required this.thumbnail, required this.description});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(name: json["name"], description: json["description"], thumbnail: json["thumbnail"]+".jpg");
    }
}