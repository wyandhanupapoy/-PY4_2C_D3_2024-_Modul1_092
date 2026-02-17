class LoginController {
  // Database Multiple Users menggunakan Map<String, String>
  // Key: Username, Value: Password
  final Map<String, String> _validUsers = {
    "admin": "123",
    "user": "password",
    "mahasiswa": "kampus",
  };

  // Tracking percobaan login
  int _attemptCount = 0;
  DateTime? _lockoutEndTime;

  // Getter untuk attempt count (agar view bisa menampilkan)
  int get attemptCount => _attemptCount;
  int get remainingAttempts => 3 - _attemptCount;

  // Cek apakah sedang dalam masa lockout
  bool get isLockedOut {
    if (_lockoutEndTime == null) return false;

    // Jika waktu lockout sudah lewat, reset
    if (DateTime.now().isAfter(_lockoutEndTime!)) {
      _attemptCount = 0;
      _lockoutEndTime = null;
      return false;
    }

    return true;
  }

  // Mendapatkan sisa waktu lockout dalam detik
  int get lockoutRemainingSeconds {
    if (_lockoutEndTime == null) return 0;
    final remaining = _lockoutEndTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  // Validasi input kosong
  String? validateInput(String username, String password) {
    if (username.trim().isEmpty && password.trim().isEmpty) {
      return "Username dan Password tidak boleh kosong!";
    }
    if (username.trim().isEmpty) {
      return "Username tidak boleh kosong!";
    }
    if (password.trim().isEmpty) {
      return "Password tidak boleh kosong!";
    }
    return null; // Valid
  }

  // Fungsi login dengan validasi dan attempt tracking
  Map<String, dynamic> login(String username, String password) {
    // Cek apakah sedang lockout
    if (isLockedOut) {
      return {
        'success': false,
        'message':
            'Terlalu banyak percobaan gagal. Coba lagi dalam ${lockoutRemainingSeconds} detik.',
        'isLocked': true,
      };
    }

    // Validasi input kosong
    String? validationError = validateInput(username, password);
    if (validationError != null) {
      return {'success': false, 'message': validationError, 'isLocked': false};
    }

    // Cek kredensial
    if (_validUsers.containsKey(username) &&
        _validUsers[username] == password) {
      // Login berhasil - reset attempt count
      _attemptCount = 0;
      _lockoutEndTime = null;

      return {'success': true, 'message': 'Login berhasil!', 'isLocked': false};
    } else {
      // Login gagal - increment attempt
      _attemptCount++;

      // Jika sudah 3 kali gagal, lockout selama 10 detik
      if (_attemptCount >= 3) {
        _lockoutEndTime = DateTime.now().add(const Duration(seconds: 10));

        return {
          'success': false,
          'message': 'Login gagal 3 kali! Akun dikunci selama 10 detik.',
          'isLocked': true,
        };
      }

      return {
        'success': false,
        'message':
            'Username atau Password salah! (Percobaan ${_attemptCount}/3)',
        'isLocked': false,
      };
    }
  }

  // Reset attempt count (untuk testing atau admin reset)
  void resetAttempts() {
    _attemptCount = 0;
    _lockoutEndTime = null;
  }
}
