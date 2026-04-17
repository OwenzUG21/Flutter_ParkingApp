class OnboardingContent {
  final String title;
  final String subtitle;
  final String animationPath;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.animationPath,
  });

  static List<OnboardingContent> contents = [
    OnboardingContent(
      title: 'Find Parking Fast',
      subtitle: 'Locate nearby parking spaces in seconds',
      animationPath: 'assets/animations/car_park.json',
    ),
    OnboardingContent(
      title: 'Book in Seconds',
      subtitle: 'Reserve your spot before you arrive',
      animationPath: 'assets/animations/Man_waiting_car.json',
    ),
    OnboardingContent(
      title: 'Safe Parking',
      subtitle: 'Secure, reliable, and stress-free experience',
      animationPath: 'assets/animations/driving.json',
    ),
  ];
}
