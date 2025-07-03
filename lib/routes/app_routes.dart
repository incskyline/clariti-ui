import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/create_decision/create_decision.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/decision_results/decision_results.dart';
import '../presentation/community_feed/community_feed.dart';
import '../presentation/thread_detail/thread_detail.dart';
import '../presentation/membership_upgrade/membership_upgrade.dart';
import '../presentation/user_profile/user_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String createDecision = '/create-decision';
  static const String homeDashboard = '/home-dashboard';
  static const String decisionResults = '/decision-results';
  static const String communityFeed = '/community-feed';
  static const String threadDetail = '/thread-detail';
  static const String membershipUpgrade = '/membership-upgrade';
  static const String userProfile = '/user-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    createDecision: (context) => const CreateDecision(),
    homeDashboard: (context) => const HomeDashboard(),
    decisionResults: (context) => const DecisionResults(),
    communityFeed: (context) => const CommunityFeed(),
    threadDetail: (context) => const ThreadDetail(),
    membershipUpgrade: (context) => const MembershipUpgrade(),
    userProfile: (context) => const UserProfile(),
    // TODO: Add your other routes here
  };
}
