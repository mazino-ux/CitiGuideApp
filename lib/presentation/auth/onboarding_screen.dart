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
          // Background with PageView
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
          
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 30,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withAlpha(128),
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

          // Navigation controls at bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 3.5,
                    dotHeight: 6,
                    dotWidth: 6,
                    activeDotColor: Colors.purple[300]!,
                    dotColor: Colors.white.withAlpha(102),
                    spacing: 8,
                  ),
                ),
                const SizedBox(height: 20),
                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button (only shows when not on first page)
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: _currentPage > 0 
                              ? Colors.purple[300]!.withAlpha(230)
                              : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: _currentPage > 0 
                              ? [
                                  BoxShadow(
                                    color: Colors.purple.withAlpha(76),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : [],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _currentPage > 0
                                ? () {
                                    _pageController.previousPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOutQuint,
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ),
                      
                      // Next/Get Started button
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.purple[300]!.withAlpha(230),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withAlpha(76),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _currentPage == _pages.length - 1
                                ? Icons.check_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_currentPage == _pages.length - 1) {
                              _goToRoleSelection();
                            } else {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOutQuint,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with modern frame
          Container(
            height: 280, // Reduced to prevent overflow
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(76),
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
          const SizedBox(height: 40),
          // Title with gradient text
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [color, Colors.purpleAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 28, // Reduced to prevent overflow
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
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
    );
  }
}