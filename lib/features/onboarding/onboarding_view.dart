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
              'LogBook App membantu Anda mencatat aktivitas harian dengan mudah dan terorganisir',
        };
      case 2:
        return {
          'image': 'assets/images/onboarding2.png',
          'icon': Icons.edit_note,
          'title': 'Kelola Catatan',
          'description':
              'Buat, edit, dan kelola semua catatan Anda dalam satu tempat yang aman',
        };
      case 3:
        return {
          'image': 'assets/images/onboarding3.png',
          'icon': Icons.analytics,
          'title': 'Pantau Progress',
          'description':
              'Lihat statistik dan perkembangan aktivitas Anda secara real-time',
        };
      default:
        return {
          'image': 'assets/images/onboarding1.png',
          'icon': Icons.book,
          'title': 'LogBook App',
          'description': 'Mulai petualangan Anda',
        };
    }
  }

  // Widget untuk menampilkan gambar dengan fallback ke icon
  Widget _buildStepImage(String imagePath, IconData fallbackIcon) {
    return Image.asset(
      imagePath,
      height: 250,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Jika gambar tidak ditemukan, tampilkan icon sebagai fallback
        return Icon(
          fallbackIcon,
          size: 150,
          color: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }

  // Widget untuk Page Indicator (dots)
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final pageNumber = index + 1;
        final isActive = pageNumber == step;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _getStepContent();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Gambar/Icon
              _buildStepImage(content['image'], content['icon']),

              const SizedBox(height: 40),

              // Page Indicator
              _buildPageIndicator(),

              const SizedBox(height: 32),

              // Title
              Text(
                content['title'],
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  content['description'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(),

              // Step indicator text
              Text(
                'Step $step dari 3',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),

              const SizedBox(height: 16),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    step < 3 ? 'Lanjut' : 'Mulai Sekarang',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
