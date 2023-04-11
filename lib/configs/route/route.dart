import '../../core/login/screen/login_screen.dart';
import '../../modules/canteen/screen/canteen_screen.dart';
import '../../modules/canteen/screen/iWallet/screens/iwallet_screen.dart';
import '../../modules/canteen/screen/pre_order/screens/pre_order_screen.dart';
import '../../modules/canteen/screen/purchase_limit/screens/purchase_screen.dart';
import '../../modules/canteen/screen/team_conditions/screens/team_conditions.dart';
import '../../modules/canteen/screen/topup/screens/topup_screen.dart';
import '../../modules/home_screen/screen/home_screen.dart';
import '../../modules/profile/screens/profile_screen.dart';

var route = {
  'login': (context) => const LoginScreen(),
  'home': (context) => const HomeScreen(),
  'profile': (context) => const ProfileScreen(),
  'canteen': (context) => const CanteenScreen(),
  'top-up': (context) => const TopUpScreen(),
  'iwallet': (context) => const IWalletScreen(
        index: 0,
      ),
  'pre-order': (context) => const PreOrderScreen(),
  'purchase-limit': (context) => const PurchaseLimitScreen(),
  'terms-conditlions': (context) => const TermsAndConditionsScreen(),
};
