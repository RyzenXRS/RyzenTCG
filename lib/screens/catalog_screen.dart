import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '/models/pokemon_card.dart';
import 'add_card.dart';

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
        title: const Text(
          'Katalog RYZENTCG',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<PokemonCardModel>>(
        future: _futureCards,
        builder: (context, snapshot) {
          // Menampilkan loading spinner saat menunggu data dari server
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
          // Error Handling terjadi error jaringan
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Error Handling jika data kosong (belum ada kartu yang ditambahkan)
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Koleksi masih kosong, Trainer!\nYuk tambah kartu pertamamu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Jika data berhasil ditarik dan ada isinya
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
                    child: Icon(Icons.catching_pokemon, color: Colors.white),
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
          // .then() ini penting banget! Fungsinya agar list kartu otomatis me-refresh saat form ditutup
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
