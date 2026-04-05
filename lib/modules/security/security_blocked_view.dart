import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/security/app_security_service.dart';
import '../../core/widgets/custom_buttons/primary_button.dart';

class SecurityBlockedView extends StatelessWidget {
  const SecurityBlockedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final securityState = Get.find<AppSecurityService>().state;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Icon(
                Icons.security_rounded,
                size: 72,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 20),
              Text(
                'Device Security Risk Detected',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'For your protection, this app is blocked on this device '
                'because it does not meet required security checks.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Detected risks:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...securityState.risks.map(
                (risk) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('- $risk', style: theme.textTheme.bodyMedium),
                ),
              ),
              if (securityState.warnings.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  securityState.warnings.join('\n'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const Spacer(),
              PrimaryButton(
                text: 'Close App',
                backgroundColor: theme.colorScheme.error,
                textColor: theme.colorScheme.onError,
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
