import 'package:flutter/material.dart';
import 'package:logbook_app_001/features/auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  // State variable untuk tracking step
  int step = 1;

  // Fungsi untuk handle tombol Next
  void _handleNext() {
    setState(() {
      step++;
    });

    // Jika step > 3, pindah ke LoginView
    if (step > 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  // Fungsi untuk mendapatkan konten berdasarkan step
  Map<String, dynamic> _getStepContent() {
    switch (step) {
      case 1:
        return {
          'image': 'assets/images/onboarding1.png',
          'icon': Icons.book,
          'title': 'Selamat Datang',
          'description':
              'LogBook App membantu Anda mencatat aktivitas harian dengan mudah',
        };
      case 2:
        return {
          'image': 'assets/images/onboarding2.png',
          'icon': Icons.edit_note,
          'title': 'Kelola Catatan',
          'description':
              'Buat, edit, dan kelola semua catatan Anda dalam satu tempat',
        };
      case 3:
        return {
          'image': 'assets/images/onboarding3.png',
          'icon': Icons.analytics,
          'title': 'Pantau Progress',
          'description': 'Lihat statistik dan perkembangan aktivitas Anda',
        };
      default:
        return {
          'image': 'assets/images/onboarding1.png',
          'icon': Icons.book,
          'title': 'LogBook App',
          'description': 'Selamat datang di aplikasi logbook',
        };
    }
  }

  // Fungsi untuk menampilkan gambar dengan fallback ke icon
  Widget _buildStepImage(String imagePath, IconData fallbackIcon) {
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Jika gambar tidak ditemukan, tampilkan icon sebagai fallback
        return Icon(
          fallbackIcon,
          size: 100,
          color: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _getStepContent();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to LogBook App"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar atau Icon berdasarkan step
              // Menggunakan Image.asset dengan error handling
              Container(
                height: 200,
                child: _buildStepImage(content['image'], content['icon']),
              ),
              const SizedBox(height: 30),
              // Title berdasarkan step
              Text(
                content['title'],
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Description berdasarkan step
              Text(
                content['description'],
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Indicator step (tampilkan step berapa)
              Text(
                'Step $step dari 3',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              // Tombol Next
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text("Next", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
