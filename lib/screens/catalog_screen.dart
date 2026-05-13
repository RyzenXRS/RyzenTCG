import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '/models/pokemon_card.dart';
import 'add_card.dart';
import 'submit.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late Future<List<PokemonCardModel>> _futureCards;

  @override
  void initState() {
    super.initState();
    _refreshCards();
  }

  // Call ulang data dari API
  void _refreshCards() {
    setState(() {
      _futureCards = ApiService.fetchCards();
    });
  }

  // menghapus kartu (soft delete)
  void _handleDelete(int id) async {
    bool success = await ApiService.deleteCard(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kartu berhasil dihapus dari koleksi!')),
      );
      _refreshCards();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menghapus kartu.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Row(
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: Icon(
                Icons.catching_pokemon,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Collection RYZENTCG',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            tooltip: 'Submit Tugas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubmitScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<PokemonCardModel>>(
        future: _futureCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Koleksi masih kosong, Trainer!\nYuk tambah kartu pertamamu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final cards = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Icon(Icons.catching_pokemon, color: Colors.white),
                    ),
                  ),
                  title: Text(
                    card.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Harga: Rp ${card.price.toInt()}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(card.description),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _handleDelete(card.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCardScreen()),
          ).then((_) => _refreshCards());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
