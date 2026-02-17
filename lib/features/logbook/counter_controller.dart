import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)
  String _username = ''; // Username untuk per-user storage

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

  // Getter: full history untuk keperluan penyimpanan
  List<Map<String, String>> get fullHistory => List.from(_history);

  // Keys untuk SharedPreferences (per-user)
  String _getCounterKey() => 'counter_$_username';
  String _getHistoryKey() => 'history_$_username';

  String _timestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  // === PERSISTENCE METHODS ===

  /// Set username untuk storage keys
  void setUsername(String username) {
    _username = username;
  }

  /// Load counter value dari SharedPreferences
  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt(_getCounterKey()) ?? 0;
  }

  /// Save counter value ke SharedPreferences
  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_getCounterKey(), _counter);
  }

  /// Load history dari SharedPreferences
  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_getHistoryKey());

    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        _history.clear();
        _history.addAll(
          decoded.map((item) => Map<String, String>.from(item)).toList(),
        );
      } catch (e) {
        // Jika error saat decode, skip dan mulai dengan history kosong
        _history.clear();
      }
    }
  }

  /// Save history ke SharedPreferences
  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String historyJson = jsonEncode(_history);
    await prefs.setString(_getHistoryKey(), historyJson);
  }

  /// Load semua data (counter + history)
  Future<void> loadAll() async {
    await loadCounter();
    await loadHistory();
  }

  /// Save semua data (counter + history)
  Future<void> saveAll() async {
    await saveCounter();
    await saveHistory();
  }

  // === BUSINESS LOGIC METHODS (dengan auto-save) ===

  Future<void> increment() async {
    _counter += _step;
    _history.add({
      'type': 'increment',
      'message': 'User menambah nilai sebesar $_step pada jam ${_timestamp()}',
    });

    // Auto-save setelah perubahan
    await saveAll();
  }

  Future<void> decrement() async {
    if (_counter > 0) {
      _counter -= _step;
      _history.add({
        'type': 'decrement',
        'message':
            'User mengurangi nilai sebesar $_step pada jam ${_timestamp()}',
      });

      // Auto-save setelah perubahan
      await saveAll();
    }
  }

  Future<void> reset() async {
    _counter = 0;
    _history.add({
      'type': 'reset',
      'message': 'User mereset counter pada jam ${_timestamp()}',
    });

    // Auto-save setelah perubahan
    await saveAll();
  }

  /// Clear all data (untuk testing atau reset total)
  Future<void> clearAll() async {
    _counter = 0;
    _history.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getCounterKey());
    await prefs.remove(_getHistoryKey());
  }
}
