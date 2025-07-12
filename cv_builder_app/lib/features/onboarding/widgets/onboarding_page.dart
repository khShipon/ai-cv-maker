import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../screens/onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Illustration
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: _buildIllustration(),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Content
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Title
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  Text(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.mediumGray,
                      height: 1.4,
                    ),
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    // Since we don't have the actual images, I'll create SVG-like illustrations
    // that match the design from your screenshots
    
    if (data.imagePath.contains('onboarding_1')) {
      return _buildFirstPageIllustration();
    } else if (data.imagePath.contains('onboarding_2')) {
      return _buildSecondPageIllustration();
    } else {
      return _buildThirdPageIllustration();
    }
  }

  Widget _buildFirstPageIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circles
        Positioned(
          top: 50,
          left: 50,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.lightPeach.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: 40,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.lightTeal.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Laptop with CV
        Center(
          child: Container(
            width: 200,
            height: 140,
            decoration: BoxDecoration(
              color: AppTheme.mediumGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Screen
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CV',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(4, (index) => Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            height: 3,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryTeal,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                // Keyboard
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkText,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Chat bubbles
        Positioned(
          top: 60,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryTeal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(4, (index) => Container(
                margin: const EdgeInsets.only(right: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )),
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: 30,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.lightOrange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 30,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        // Plant decoration
        Positioned(
          bottom: 40,
          left: 30,
          child: Container(
            width: 40,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.lightOrange,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryTeal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondPageIllustration() {
    return Center(
      child: Container(
        width: 250,
        height: 200,
        child: Stack(
          children: [
            // Template cards
            ...List.generate(3, (index) {
              return Positioned(
                top: index * 20.0,
                left: index * 15.0,
                child: Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == 0 ? AppTheme.primaryTeal : AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(6, (lineIndex) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          height: 4,
                          width: lineIndex == 0 ? 80 : (lineIndex % 2 == 0 ? 100 : 60),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdPageIllustration() {
    return Center(
      child: Container(
        width: 220,
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ATS scanner effect
            Container(
              width: 180,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: 80,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryTeal,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Content lines with highlights
                    ...List.generate(8, (index) {
                      final isHighlighted = [1, 3, 5].contains(index);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 6,
                        width: index % 3 == 0 ? 120 : (index % 2 == 0 ? 100 : 80),
                        decoration: BoxDecoration(
                          color: isHighlighted ? AppTheme.primaryTeal.withOpacity(0.3) : AppTheme.lightGray,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            
            // Scanning line animation
            Positioned(
              top: 40,
              child: Container(
                width: 180,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppTheme.primaryTeal,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // Checkmark
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
