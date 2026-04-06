import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: inputFillColor,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Payment',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  Text(
                    'Cards',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PaymentTile(
                    cardNumber: '**** 4187',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _PaymentTile(
                    cardNumber: '**** 9387',
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Paypal',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: inputFillColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      title: Text(
                        'Cloth@gmail.com',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: colorScheme.onSurface,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-card'),
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String cardNumber;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.cardNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final inputFillColor =
        theme.inputDecorationTheme.fillColor ?? colorScheme.surfaceContainerHighest;

    return Container(
      decoration: BoxDecoration(
        color: inputFillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Row(
          children: [
            Text(
              cardNumber,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            // Placeholder for Mastercard logo
            Container(
              width: 24,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, size: 10, color: Colors.red),
                  Icon(Icons.circle, size: 10, color: Colors.amber),
                ],
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: colorScheme.onSurface,
        ),
        onTap: onTap,
      ),
    );
  }
}

class PaymentBinding extends Bindings {
  @override
  void dependencies() {}
}
