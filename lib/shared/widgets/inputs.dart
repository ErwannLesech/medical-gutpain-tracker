import 'package:flutter/material.dart';

/// Champ de saisie d'aliments avec suggestions
class FoodInputField extends StatefulWidget {
  final List<String> foods;
  final List<String> suggestions;
  final ValueChanged<List<String>> onChanged;
  final String? hintText;

  const FoodInputField({
    super.key,
    required this.foods,
    this.suggestions = const [],
    required this.onChanged,
    this.hintText,
  });

  @override
  State<FoodInputField> createState() => _FoodInputFieldState();
}

class _FoodInputFieldState extends State<FoodInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text.toLowerCase().trim();
    if (text.isEmpty) {
      setState(() => _filteredSuggestions = []);
      return;
    }

    setState(() {
      _filteredSuggestions = widget.suggestions
          .where((s) => s.toLowerCase().contains(text))
          .where((s) => !widget.foods.contains(s))
          .take(5)
          .toList();
    });
  }

  void _addFood(String food) {
    final trimmed = food.trim();
    if (trimmed.isEmpty) return;
    if (widget.foods.contains(trimmed)) return;

    widget.onChanged([...widget.foods, trimmed]);
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _removeFood(String food) {
    widget.onChanged(widget.foods.where((f) => f != food).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chips des aliments ajoutés
        if (widget.foods.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.foods.map((food) {
              return Chip(
                label: Text(food),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeFood(food),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // Champ de saisie
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Ajouter un aliment...',
            prefixIcon: const Icon(Icons.add),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => _addFood(_controller.text),
                  )
                : null,
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _addFood,
        ),

        // Suggestions
        if (_filteredSuggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filteredSuggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                avatar: const Icon(Icons.add, size: 18),
                onPressed: () => _addFood(suggestion),
              );
            }).toList(),
          ),
        ],

        // Suggestions rapides (récents)
        if (_controller.text.isEmpty && widget.suggestions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Suggestions',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.suggestions
                .where((s) => !widget.foods.contains(s))
                .take(8)
                .map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () => _addFood(suggestion),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// Champ de notes avec compteur de caractères
class NotesField extends StatelessWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final int maxLength;
  final String? hintText;
  final int minLines;

  const NotesField({
    super.key,
    this.value,
    this.onChanged,
    this.maxLength = 500,
    this.hintText,
    this.minLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      maxLength: maxLength,
      maxLines: null,
      minLines: minLines,
      decoration: InputDecoration(
        hintText: hintText ?? 'Notes optionnelles...',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

/// Sélecteur de symptômes (chips)
class SymptomSelector extends StatelessWidget {
  final List<SymptomOption> options;
  final List<int> selectedIndexes;
  final ValueChanged<List<int>> onChanged;

  const SymptomSelector({
    super.key,
    required this.options,
    required this.selectedIndexes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = selectedIndexes.contains(index);

        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(option.emoji),
              const SizedBox(width: 6),
              Text(option.label),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onChanged([...selectedIndexes, index]);
            } else {
              onChanged(selectedIndexes.where((i) => i != index).toList());
            }
          },
          selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          checkmarkColor: Theme.of(context).colorScheme.primary,
        );
      }).toList(),
    );
  }
}

class SymptomOption {
  final String label;
  final String emoji;

  const SymptomOption({
    required this.label,
    required this.emoji,
  });
}

/// Sélecteur de type de repas
class MealTypeSelector extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onChanged;

  const MealTypeSelector({
    super.key,
    this.selectedIndex,
    required this.onChanged,
  });

  static const _types = [
    {'emoji': '🌅', 'label': 'Petit-déj'},
    {'emoji': '☀️', 'label': 'Déjeuner'},
    {'emoji': '🌙', 'label': 'Dîner'},
    {'emoji': '🍪', 'label': 'Collation'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _types.asMap().entries.map((entry) {
        final index = entry.key;
        final type = entry.value;
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onChanged(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  type['emoji']!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  type['label']!,
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
      }).toList(),
    );
  }
}
