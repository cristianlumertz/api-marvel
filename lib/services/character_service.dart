import 'dart:convert';
import 'package:ap2/models/character.dart';
import 'package:http/http.dart' as http;
import 'package:ap2/helper/helper.dart';

class CharactersService {
  Future<List<Character>> getCharacters({int limit = 100,}) async {
    var url = '$urlFinal&limit=$limit'; //
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Character> characters = [];

      for (var item in data['data']['results']) {
        characters.add(Character(
          name: item['name'],
          description: item['description'],
          thumbnail: '${item['thumbnail']['path']}.${item['thumbnail']['extension']}',
        ));
      }

      return characters;
    } else {
      throw Exception('Falha ao carregar personagens');
    }
  }
}
