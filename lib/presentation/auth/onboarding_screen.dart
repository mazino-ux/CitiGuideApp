import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    OnboardingPage(
      image: 'assets/images/onboarding1.jpg',
      title: 'Discover Hidden Gems',
      description: 'Explore the best attractions and local favorites in every city you visit',
      color: Colors.deepPurple,
    ),
    OnboardingPage(
      image: 'assets/images/onboarding2.jpg',
      title: 'Personalized Recommendations',
      description: 'Get tailored suggestions based on your interests and preferences',
      color: Colors.purple[800]!,
    ),
    OnboardingPage(
      image: 'assets/images/onboarding3.jpg',
      title: 'Local Insights',
      description: 'Learn from locals and experienced travelers about the best spots',
      color: Colors.deepPurple[700]!,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with ListView to prevent overflow
          ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[900]!,
                      Colors.grey[850]!,
                    ],
                  ),
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: _pages,
                ),
              ),
            ],
          ),
          
          // Skip button - Modern transparent with border
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 30,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha(128), // Changed from withOpacity(0.5)
                  width: 1.5,
                ),
              ),
              child: TextButton(
                onPressed: () => _goToRoleSelection(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          
          // Page indicator - Purple with custom design
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  expansionFactor: 3.5,
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: Colors.purple[300]!,
                  dotColor: Colors.white.withAlpha(102), // Changed from withOpacity(0.4)
                  spacing: 8,
                ),
              ),
            ),
          ),
          
          // Next/Get Started button - Elegant floating button
          Positioned(
            bottom: 60,
            right: 30,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _currentPage == _pages.length - 1 ? 160 : 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple[300]!.withAlpha(230), // Changed from withOpacity(0.9)
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withAlpha(76), // Changed from withOpacity(0.3)
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    if (_currentPage == _pages.length - 1) {
                      _goToRoleSelection();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuint,
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage == _pages.length - 1)
                          Text(
                            'GET STARTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        Icon(
                          _currentPage == _pages.length - 1 
                            ? Icons.arrow_forward_rounded 
                            : Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToRoleSelection() {
    Navigator.pushReplacementNamed(context, '/roleSelection');
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Color color;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image with modern frame
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(76), // Changed from withOpacity(0.3)
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Title with gradient text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [color, Colors.purpleAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Description with elegant typography
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withAlpha(204), 
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}