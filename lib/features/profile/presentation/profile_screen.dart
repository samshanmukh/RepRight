import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fitness Enthusiast',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'fitbuddy@example.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  '24',
                  'Workouts',
                  Icons.fitness_center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  '12h',
                  'Training Time',
                  Icons.timer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  '85%',
                  'Accuracy',
                  Icons.check_circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings sections
          _buildSectionHeader('Preferences'),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            'Workout Reminders',
            Icons.notifications_outlined,
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Toggle notifications
              },
            ),
          ),
          _buildSettingsTile(
            context,
            'Voice Coaching',
            Icons.mic_outlined,
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Toggle voice coaching
              },
            ),
          ),
          _buildSettingsTile(
            context,
            'Camera Mirror Mode',
            Icons.flip_camera_android_outlined,
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Toggle mirror mode
              },
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('Account'),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            'Edit Profile',
            Icons.person_outline,
            onTap: () {
              // TODO: Navigate to edit profile
            },
          ),
          _buildSettingsTile(
            context,
            'Privacy & Security',
            Icons.lock_outline,
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          _buildSettingsTile(
            context,
            'Subscription',
            Icons.card_membership_outlined,
            onTap: () {
              // TODO: Navigate to subscription
            },
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('Support'),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context,
            'Help Center',
            Icons.help_outline,
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          _buildSettingsTile(
            context,
            'Send Feedback',
            Icons.feedback_outlined,
            onTap: () {
              // TODO: Open feedback form
            },
          ),
          _buildSettingsTile(
            context,
            'About',
            Icons.info_outline,
            onTap: () {
              // TODO: Show about dialog
            },
          ),
          const SizedBox(height: 24),

          // Logout button
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement logout
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
