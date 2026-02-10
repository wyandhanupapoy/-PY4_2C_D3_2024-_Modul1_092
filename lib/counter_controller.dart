class CounterController {
  int _counter = 0; // Variabel private (Enkapsulasi)

  int get value => _counter; // Getter untuk akses data

  int _step = 1; // Nilai step default

  int get step => _step; // Getter untuk akses step
  set step(int val) => _step = val.clamp(1, 100); // Setter dengan batas 1-100

  void increment() => _counter += _step;
  void decrement() {
    if (_counter > 0) _counter -= _step;
  }
  void reset() => _counter = 0;
}
