import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pokemon_card.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  // Kita siapkan 4 Controller untuk 4 inputan
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();

  bool _isLoading = false;

  void _handleSubmit() async {
    // 1. Validasi Input agar tidak ada yang kosong
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descController.text.isEmpty ||
        _githubController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi, Trainer!')),
      );
      return;
    }

    // 2. Validasi Harga (harus angka)
    int? parsedPrice = int.tryParse(_priceController.text);
    if (parsedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harga harus berupa angka bulat!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 3. Masukkan data dari inputan TextFields ke dalam Model
    SubmitTaskModel taskData = SubmitTaskModel(
      name: _nameController.text.trim(),
      price: parsedPrice,
      description: _descController.text.trim(),
      githubUrl: _githubController.text.trim(),
    );

    // 4. Kirim ke API Submit
    bool success = await ApiService.submitTask(taskData);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil dikirim ke asisten! 🎉')),
      );
      Navigator.pop(context); // Kembali ke halaman katalog jika sukses
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim tugas. Coba cek lagi datamu.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Submit Tugas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.send_rounded, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Langkah Terakhir!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Isi detail tugas dan masukkan link repository GitHub kamu.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // Input 1: Nama Proyek/Tugas
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama / Judul Tugas',
                prefixIcon: const Icon(Icons.title, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input 2: Harga
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga (Angka)',
                prefixIcon: const Icon(
                  Icons.monetization_on,
                  color: Colors.green,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input 3: Deskripsi
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Pesan / Deskripsi Singkat',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Input 4: Link GitHub
            TextField(
              controller: _githubController,
              decoration: InputDecoration(
                labelText: 'Link Repository GitHub',
                hintText: 'https://github.com/username/repo',
                prefixIcon: const Icon(Icons.link, color: Colors.blue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Submit
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'KIRIM TUGAS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
