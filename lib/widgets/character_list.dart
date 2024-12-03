import 'package:flutter/material.dart';
import 'package:ap2/models/character.dart';
import 'package:ap2/services/character_service.dart';
import 'dart:async';

class CharacterList extends StatefulWidget {
  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<List<Character>> _filteredCharactersController = StreamController<List<Character>>();
  List<Character> _allCharacters = [];

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
    _searchController.addListener(_applyFilter);
  }

  Future<void> _fetchCharacters() async {
    try {
      _allCharacters = await CharactersService().getCharacters();
      _filteredCharactersController.add(_allCharacters);
    } catch (error) {
      _filteredCharactersController.addError('Erro ao carregar personagens');
    }
  }

  void _applyFilter() {
    String query = _searchController.text.toLowerCase();
    List<Character> filteredCharacters = _allCharacters
        .where((character) => character.name.toLowerCase().contains(query))
        .toList();

    _filteredCharactersController.add(filteredCharacters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredCharactersController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personagens da Marvel'),
        backgroundColor: Colors.red.shade800, // Tema Marvel
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/marvel_background.jpg'), // Substitua pela imagem da Marvel
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black87, BlendMode.darken),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black54,
                  labelText: 'Buscar Personagem',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Character>>(
                stream: _filteredCharactersController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.red));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum personagem encontrado.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  } else {
                    final characters = snapshot.data!;
                    return ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ExpansionTile(
                            iconColor: Colors.red,
                            collapsedIconColor: Colors.white,
                            title: Text(
                              characters[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                characters[index].thumbnail,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, color: Colors.white70);
                                },
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  characters[index].description.isNotEmpty
                                      ? characters[index].description
                                      : 'Descrição não disponível.',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
