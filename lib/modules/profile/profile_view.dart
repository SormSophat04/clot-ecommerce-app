import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mutedSurface =
        theme.inputDecorationTheme.fillColor ?? AppColors.backgroundColor2;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return _ProfileActionTile(
                mutedSurface: mutedSurface,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE6E0FA),
                  child: Icon(Icons.person, color: AppColors.primaryColor),
                ),
                title: 'Edit Profile',
                onTap: () => Get.toNamed(Routes.editProfile),
              );
            case 1:
              return _ProfileActionTile(
                mutedSurface: mutedSurface,
                leading: Icon(
                  Icons.location_on_outlined,
                  color: colors.onSurfaceVariant,
                ),
                title: 'Addresses',
                onTap: () => Get.toNamed(Routes.addresses),
              );
            case 2:
              return _ProfileActionTile(
                mutedSurface: mutedSurface,
                leading: Icon(
                  Icons.receipt_long_outlined,
                  color: colors.onSurfaceVariant,
                ),
                title: 'My Orders',
                onTap: () => Get.toNamed(Routes.orders),
              );
            case 3:
              return _ProfileActionTile(
                mutedSurface: mutedSurface,
                leading: Icon(
                  Icons.notifications_outlined,
                  color: colors.onSurfaceVariant,
                ),
                title: 'Notifications',
                onTap: () => Get.toNamed(Routes.notifications),
              );
            default:
              return _ProfileActionTile(
                mutedSurface: colors.errorContainer.withValues(alpha: 0.24),
                leading: Icon(Icons.logout, color: colors.error),
                title: 'Logout',
                titleColor: colors.error,
                trailing: const SizedBox.shrink(),
                onTap: () => _showLogoutDialog(context),
              );
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(Routes.login);
            },
            child: Text('Logout', style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.mutedSurface,
    required this.leading,
    required this.title,
    required this.onTap,
    this.trailing,
    this.titleColor,
  });

  final Color mutedSurface;
  final Widget leading;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: mutedSurface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: titleColor ?? colors.onSurface,
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: colors.onSurfaceVariant,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
