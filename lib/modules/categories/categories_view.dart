import 'package:clot_ecommerce_app/core/widgets/common/app_bar.dart';
import 'package:clot_ecommerce_app/core/routes/app_routes.dart';
import 'package:clot_ecommerce_app/modules/categories/categories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriesController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    final mutedSurface =
        theme.inputDecorationTheme.fillColor ?? colors.surfaceContainerHighest;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Shop by Categories',
                style: textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: _CategoriesList(
                  controller: controller,
                  textTheme: textTheme,
                  colors: colors,
                  mutedSurface: mutedSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  const _CategoriesList({
    required this.controller,
    required this.textTheme,
    required this.colors,
    required this.mutedSurface,
  });

  final CategoriesController controller;
  final TextTheme textTheme;
  final ColorScheme colors;
  final Color mutedSurface;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: controller.categories.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = controller.categories[index];

        return Material(
          color: mutedSurface,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => Get.toNamed(Routes.product, arguments: category.name),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _categoryAccentColor(colors, index),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(category.icon, size: 24, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Color _categoryAccentColor(ColorScheme colors, int index) {
  final accents = <Color>[
    colors.primaryContainer,
    colors.secondaryContainer,
    colors.tertiaryContainer,
    colors.primaryContainer.withValues(alpha: 0.7),
    colors.secondaryContainer.withValues(alpha: 0.7),
  ];
  return accents[index % accents.length];
}
