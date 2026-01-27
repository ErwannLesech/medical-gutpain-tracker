import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Slider d'intensité de douleur (1-5)
class PainIntensitySlider extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final bool showLabels;

  const PainIntensitySlider({
    super.key,
    required this.value,
    this.onChanged,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emojis et labels
        if (showLabels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                final intensity = index + 1;
                final isSelected = value == intensity;
                return GestureDetector(
                  onTap: () => onChanged?.call(intensity),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? WakyColors.getIntensityColor(intensity).withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _getEmoji(intensity),
                          style: TextStyle(
                            fontSize: isSelected ? 32 : 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$intensity',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? WakyColors.getIntensityColor(intensity)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        const SizedBox(height: 16),
        // Slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: WakyColors.getIntensityColor(value),
            inactiveTrackColor: WakyColors.getIntensityColor(value).withValues(alpha: 0.2),
            thumbColor: WakyColors.getIntensityColor(value),
            overlayColor: WakyColors.getIntensityColor(value).withValues(alpha: 0.2),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (v) => onChanged?.call(v.round()),
          ),
        ),
        // Label de l'intensité actuelle
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Container(
            key: ValueKey(value),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: WakyColors.getIntensityColor(value),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getLabel(value),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getEmoji(int intensity) {
    switch (intensity) {
      case 1:
        return '😐';
      case 2:
        return '😕';
      case 3:
        return '😣';
      case 4:
        return '😖';
      case 5:
        return '😫';
      default:
        return '❓';
    }
  }

  String _getLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Légère';
      case 2:
        return 'Modérée';
      case 3:
        return 'Moyenne';
      case 4:
        return 'Forte';
      case 5:
        return 'Intense';
      default:
        return '';
    }
  }
}

/// Slider de niveau (1-5) générique
class LevelSlider extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int>? onChanged;
  final Color? activeColor;
  final List<String>? levelLabels;

  const LevelSlider({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.levelLabels,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? Theme.of(context).colorScheme.primary;
    final labels = levelLabels ?? ['Très bas', 'Bas', 'Moyen', 'Élevé', 'Très élevé'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                labels[value - 1],
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (v) => onChanged?.call(v.round()),
          ),
        ),
      ],
    );
  }
}

/// Sélecteur de quantité (1-3)
class QuantitySelector extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;

  const QuantitySelector({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _QuantityOption(
          label: 'Légère',
          icon: Icons.restaurant,
          isSelected: value == 1,
          onTap: () => onChanged?.call(1),
        ),
        const SizedBox(width: 12),
        _QuantityOption(
          label: 'Normale',
          icon: Icons.restaurant_menu,
          isSelected: value == 2,
          onTap: () => onChanged?.call(2),
        ),
        const SizedBox(width: 12),
        _QuantityOption(
          label: 'Copieuse',
          icon: Icons.lunch_dining,
          isSelected: value == 3,
          onTap: () => onChanged?.call(3),
        ),
      ],
    );
  }
}

class _QuantityOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const _QuantityOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
