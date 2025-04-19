import 'dart:convert'; // Para usar jsonDecode
import 'package:api_earthquake/models/quake.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<List<Quake>> getQuakes() async {
    const String url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson';
    
    try {
      // Fazendo a requisição GET
      final response = await http.get(Uri.parse(url));
      
      // Verifica se a requisição foi bem-sucedida
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> features = data['features'];
        
        // Transforma cada item da lista features em um objeto Quake
        return features.map((json) => Quake.fromJson(json)).toList();
      } else {
        // Se a resposta não foi 200 OK, lança uma exceção
        throw Exception('Falha ao carregar os dados');
      }
    } catch (e) {
      // Em caso de erro, printa no console e retorna uma lista vazia
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Tracker'),
      ),
      body: FutureBuilder<List<Quake>>(
        future: getQuakes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Ciculo de loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Exibe uma mensagem de erro se algo der errado
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Exibe os terremotos em lista
            final quakes = snapshot.data!;
            return ListView.builder(
              itemCount: quakes.length,
              itemBuilder: (context, index) {
                final quake = quakes[index];
                return ListTile(
                  title: Text('${quake.magnitude} - ${quake.place}'),
                  subtitle: Text('Lat: ${quake.latitude}, Lon: ${quake.longitude}, Depth: ${quake.depth} km'),
                  onTap: () {
                    // on tap para obter mais informações
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Terremoto em ${quake.place}'),
                        content: Text('Para mais informações, acesse:\n${quake.url}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Fechar'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else {
            // Se não houver dados, exibe uma mensagem
            return const Center(child: Text('Nenhum terremoto encontrado.'));
          }
        },
      ),
    );
  }
}
