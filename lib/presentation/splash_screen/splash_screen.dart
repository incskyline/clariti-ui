import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isLoading = true;
  bool _showRetry = false;
  String _loadingText = "Initializing...";

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward();
    _loadingController.repeat();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _loadingText = "Loading preferences...";
      });
      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _loadingText = "Preparing emotions...";
      });
      await Future.delayed(const Duration(milliseconds: 700));

      setState(() {
        _loadingText = "Almost ready...";
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if user is returning or new
      final bool isReturningUser = await _checkUserStatus();

      if (mounted) {
        _navigateToNextScreen(isReturningUser);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showRetry = true;
        });
      }
    }
  }

  Future<bool> _checkUserStatus() async {
    // Simulate checking authentication status
    await Future.delayed(const Duration(milliseconds: 300));
    // For demo purposes, randomly determine if user is returning
    return DateTime.now().millisecondsSinceEpoch % 2 == 0;
  }

  void _navigateToNextScreen(bool isReturningUser) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Navigate based on user status
    final String route =
        isReturningUser ? '/home-dashboard' : '/onboarding-flow';

    Navigator.pushReplacementNamed(context, route);
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _showRetry = false;
      _loadingText = "Retrying...";
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF7B2CBF), // Deep purple
              Color(0xFF9D4EDD), // Medium purple
              Color(0xFF6A0C83), // Dark purple
              Color(0xFFBA68C8), // Light purple
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo Section
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Opacity(
                      opacity: _logoFadeAnimation.value,
                      child: _buildLogo(),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.h),

              // Loading Section
              if (_isLoading) _buildLoadingSection(),
              if (_showRetry) _buildRetrySection(),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Logo Image - Updated to use new Clariti logo
        SizedBox(
          width: 25.w,
          height: 25.w,
          child: ClarityLogoWidget.medium(),
        ),

        SizedBox(height: 2.h),

        // Tagline
        Text(
          'Find clarity in every decision',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Indicator
        AnimatedBuilder(
          animation: _loadingAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _loadingAnimation.value * 2 * 3.14159,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'refresh',
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 4.w,
                ),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Loading Text
        Text(
          _loadingText,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 1.h),

        // Progress Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _loadingAnimation,
              builder: (context, child) {
                final double delay = index * 0.3;
                final double animationValue =
                    (_loadingAnimation.value + delay) % 1.0;
                final double opacity = animationValue < 0.5
                    ? animationValue * 2
                    : (1.0 - animationValue) * 2;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: opacity * 0.8),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRetrySection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: Colors.white.withValues(alpha: 0.8),
          size: 8.w,
        ),

        SizedBox(height: 2.h),

        Text(
          'Connection timeout',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 1.h),

        Text(
          'Please check your internet connection',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 3.h),

        // Retry Button
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Retry',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
