import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'landing_screen.dart';

/// A simple profile page that lists primary options
/// and ends with a logout button.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Helper that logs the user out and redirects to LandingScreen.
  Future<void> _logOut(BuildContext context) async {
    final authService = AuthService();
    await authService.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, size: iconSize),
              title: const Text('View Profile'),
              subtitle: const Text('Your personal information'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onTap: () {},
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit, size: iconSize),
              title: const Text('Edit Profile'),
              subtitle: const Text('Change name, avatar, etc.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onTap: () {},
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.history, size: iconSize),
              title: const Text('Order History'),
              subtitle: const Text('See past orders'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.settings, size: iconSize),
              title: const Text('Settings'),
              subtitle: const Text('App preferences'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              onTap: () {},
            ),
            const Divider(height: 1),
            const SizedBox(height: 32),
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => _logOut(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Log Out'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
