class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)

  int get value => _counter; // Getter untuk akses data

  int _step = 1; // Nilai step default

  int get step => _step; // Getter untuk akses step
  set step(int val) => _step = val.clamp(1, 100); // Setter dengan batas 1-100

  // List private untuk menampung riwayat aktivitas
  // Setiap item berisi 'type' (increment/decrement/reset) dan 'message'
  final List<Map<String, String>> _history = [];

  // Getter: hanya tampilkan 5 aktivitas terakhir (manipulasi List)
  List<Map<String, String>> get history => _history.length > 5
      ? _history.sublist(_history.length - 5)
      : List.from(_history);

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  void increment() {
    _counter += _step;
    _history.add({
      'type': 'increment',
      'message': 'User menambah nilai sebesar $_step pada jam ${_timestamp()}',
    });
  }

  void decrement() {
    if (_counter > 0) {
      _counter -= _step;
      _history.add({
        'type': 'decrement',
        'message': 'User mengurangi nilai sebesar $_step pada jam ${_timestamp()}',
      });
    }
  }

  void reset() {
    _counter = 0;
    _history.add({
      'type': 'reset',
      'message': 'User mereset counter pada jam ${_timestamp()}',
    });
  }
}
