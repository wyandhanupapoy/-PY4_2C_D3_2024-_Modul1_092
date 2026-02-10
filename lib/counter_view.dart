import 'package:flutter/material.dart';
import 'counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});
  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  // Menampilkan dialog konfirmasi sebelum reset
  void _confirmReset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Reset'),
        content: const Text('Apakah Anda yakin ingin mereset counter? Data counter akan kembali ke 0.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _controller.reset());
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Counter berhasil direset!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Menentukan warna berdasarkan tipe riwayat
  Color _historyColor(String type) {
    switch (type) {
      case 'increment':
        return Colors.green;
      case 'decrement':
        return Colors.red;
      case 'reset':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Menentukan ikon berdasarkan tipe riwayat
  IconData _historyIcon(String type) {
    switch (type) {
      case 'increment':
        return Icons.arrow_upward;
      case 'decrement':
        return Icons.arrow_downward;
      case 'reset':
        return Icons.refresh;
      default:
        return Icons.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LogBook: Versi SRP")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Total Hitungan:"),
          Text('${_controller.value}', style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text('Step: ${_controller.step}', style: const TextStyle(fontSize: 18)),
          Slider(
            value: _controller.step.toDouble(),
            min: 1,
            max: 100,
            divisions: 99,
            label: '${_controller.step}',
            onChanged: (val) => setState(() => _controller.step = val.toInt()),
          ),
          // Tombol Increment, Decrement, Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _controller.decrement()),
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _confirmReset,
                child: const Text("Reset"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => _controller.increment()),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Riwayat (5 terakhir):",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          // Daftar riwayat aktivitas dengan warna berbeda
          Expanded(
            child: ListView.builder(
              itemCount: _controller.history.length,
              itemBuilder: (context, index) {
                final item = _controller.history[index];
                final type = item['type'] ?? '';
                return ListTile(
                  leading: Icon(_historyIcon(type), color: _historyColor(type)),
                  title: Text(
                    item['message'] ?? '',
                    style: TextStyle(color: _historyColor(type)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _controller.increment()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
