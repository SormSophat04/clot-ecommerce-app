import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  static const String _productName = "Men's Harrington Jacket";
  static const String _priceLabel = '\$148';
  static const String _description =
      'Built for life and made to last, this full-zip corduroy jacket is '
      'part of our Nike Life collection. The spacious fit gives you room '
      'to layer through every season.';

  static const List<String> _sizes = <String>['XS', 'S', 'M', 'L', 'XL'];
  static const List<Color> _colorOptions = <Color>[
    Color(0xFFA9AF86),
    Color(0xFF767C56),
    Color(0xFF3A3C44),
  ];
  static const List<Color> _galleryColors = <Color>[
    Color(0xFFB8C49D),
    Color(0xFFA3B183),
    Color(0xFF9BAE7C),
  ];

  String _selectedSize = 'S';
  int _selectedColorIndex = 0;
  int _quantity = 1;
  bool _isWishlisted = false;

  void _updateQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 99);
    });
  }

  Future<void> _showSizePicker(BuildContext context) async {
    final theme = Theme.of(context);
    final selectedSize = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _sizes
                  .map(
                    (size) => ChoiceChip(
                      label: Text(size),
                      selected: _selectedSize == size,
                      onSelected: (_) => Navigator.of(context).pop(size),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );

    if (selectedSize != null && mounted) {
      setState(() => _selectedSize = selectedSize);
    }
  }

  Future<void> _showColorPicker(BuildContext context) async {
    final theme = Theme.of(context);
    final selectedColor = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(_colorOptions.length, (index) {
                final isSelected = _selectedColorIndex == index;
                return InkWell(
                  onTap: () => Navigator.of(context).pop(index),
                  borderRadius: BorderRadius.circular(22),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _colorOptions[index],
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }),
            ),
          ),
        );
      },
    );

    if (selectedColor != null && mounted) {
      setState(() => _selectedColorIndex = selectedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final shellBackground = isDark
        ? const Color(0xFF16171D)
        : const Color(0xFFD5D5D5);
    final panelSurface = isDark
        ? const Color(0xFF20222B)
        : const Color(0xFFF7F7F7);
    final mutedSurface = isDark
        ? const Color(0xFF2D2F39)
        : const Color(0xFFECECEE);
    final mutedText = isDark
        ? colorScheme.onSurfaceVariant
        : const Color(0xFF8B8B90);
    final buttonGradient = <Color>[
      AppColors.primaryColor,
      const Color(0xFF7A5ADE),
    ];

    return Scaffold(
      backgroundColor: shellBackground,
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    _RoundIconAction(
                      onTap: Get.back,
                      backgroundColor: mutedSurface,
                      icon: Image.asset(
                        AppAssets.backArrow,
                        width: 18,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    _RoundIconAction(
                      onTap: () =>
                          setState(() => _isWishlisted = !_isWishlisted),
                      backgroundColor: mutedSurface,
                      icon: Image.asset(
                        AppAssets.heart,
                        width: 18,
                        color: _isWishlisted
                            ? AppColors.primaryColor
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 252,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: _galleryColors.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) =>
                                _GalleryCard(tint: _galleryColors[index]),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _productName,
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.onSurface,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _priceLabel,
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _OptionTile(
                          label: 'Size',
                          backgroundColor: mutedSurface,
                          trailing: InkWell(
                            onTap: () => _showSizePicker(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _selectedSize,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _OptionTile(
                          label: 'Color',
                          backgroundColor: mutedSurface,
                          trailing: InkWell(
                            onTap: () => _showColorPicker(context),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _colorOptions[_selectedColorIndex],
                                      border: Border.all(
                                        color: colorScheme.outline.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _OptionTile(
                          label: 'Quantity',
                          backgroundColor: mutedSurface,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _QuantityAction(
                                icon: Icons.add,
                                onTap: () => _updateQuantity(1),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$_quantity',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _QuantityAction(
                                icon: Icons.remove,
                                onTap: () => _updateQuantity(-1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _description,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            color: mutedText,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _AddToBagButton(
                  priceLabel: _priceLabel,
                  gradient: buttonGradient,
                  onTap: () {
                    final itemText = _quantity > 1 ? 'items' : 'item';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added $_quantity $itemText ($_selectedSize) to bag.',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  width: 118,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconAction extends StatelessWidget {
  const _RoundIconAction({
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
  });

  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.tint});

  final Color tint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 166,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tint.withValues(alpha: 0.93),
              tint.withValues(alpha: 0.78),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -54,
              left: -30,
              right: -30,
              child: Container(
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.26),
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 12,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.92),
                  BlendMode.srcIn,
                ),
                child: Image.asset(AppAssets.logo, width: 23, height: 23),
              ),
            ),
            Center(
              child: Icon(
                Icons.checkroom_rounded,
                size: 86,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.backgroundColor,
    required this.trailing,
  });

  final String label;
  final Color backgroundColor;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: onSurface,
            ),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }
}

class _QuantityAction extends StatelessWidget {
  const _QuantityAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _AddToBagButton extends StatelessWidget {
  const _AddToBagButton({
    required this.priceLabel,
    required this.gradient,
    required this.onTap,
  });

  final String priceLabel;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Row(
                children: [
                  Text(
                    priceLabel,
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Add to Bag',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
  }
}
