import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/widgets.dart';
import 'meals_provider.dart';

/// Écran de formulaire pour ajouter/modifier un repas
class MealFormScreen extends ConsumerStatefulWidget {
  final Meal? meal;
  final DateTime? initialDate;

  const MealFormScreen({
    super.key,
    this.meal,
    this.initialDate,
  });

  @override
  ConsumerState<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends ConsumerState<MealFormScreen> {
  late MealType _selectedType;
  late DateTime _plannedDateTime;
  late List<String> _foods;
  late int _quantity;
  String? _title;
  String? _notes;
  bool _isLoading = false;
  
  late TextEditingController _titleController;

  bool get _isEditing => widget.meal != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _selectedType = widget.meal!.type;
      _plannedDateTime = widget.meal!.plannedDateTime;
      _foods = List.from(widget.meal!.foods);
      _quantity = widget.meal!.quantity;
      _title = widget.meal!.title;
      _notes = widget.meal!.notes;
    } else {
      _selectedType = _guessNextMealType();
      _plannedDateTime = widget.initialDate ?? DateTime.now();
      _foods = [];
      _quantity = 2;
      _title = null;
      _notes = null;
    }
    
    _titleController = TextEditingController(text: _title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  MealType _guessNextMealType() {
    final hour = DateTime.now().hour;
    if (hour < 10) return MealType.breakfast;
    if (hour < 14) return MealType.lunch;
    if (hour < 18) return MealType.snack;
    return MealType.dinner;
  }

  @override
  Widget build(BuildContext context) {
    final suggestedFoods = ref.watch(suggestedFoodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier le repas' : 'Nouveau repas'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type de repas
            Text(
              'Type de repas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            MealTypeSelector(
              selectedIndex: _selectedType.index,
              onChanged: (index) {
                HapticService.selection();
                setState(() {
                  _selectedType = MealType.values[index];
                });
              },
            ),

            const SizedBox(height: 24),

            // Titre du repas (nouveau)
            Text(
              'Titre du repas (optionnel)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Ex: Pâtes carbo, Salade César...',
                prefixIcon: const Icon(Icons.restaurant_menu),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _title = value.isEmpty ? null : value;
              },
            ),

            const SizedBox(height: 24),

            // Date et heure
            Text(
              'Date et heure',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      DateFormat('EEE d MMM', 'fr_FR').format(_plannedDateTime),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      DateFormat('HH:mm').format(_plannedDateTime),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quantité
            Text(
              'Quantité',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            QuantitySelector(
              value: _quantity,
              onChanged: (value) {
                HapticService.selection();
                setState(() {
                  _quantity = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Aliments
            Text(
              'Aliments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            suggestedFoods.when(
              data: (suggestions) => FoodInputField(
                foods: _foods,
                suggestions: suggestions,
                onChanged: (foods) {
                  setState(() {
                    _foods = foods;
                  });
                },
              ),
              loading: () => FoodInputField(
                foods: _foods,
                suggestions: const [],
                onChanged: (foods) {
                  setState(() {
                    _foods = foods;
                  });
                },
              ),
              error: (_, __) => FoodInputField(
                foods: _foods,
                suggestions: const [],
                onChanged: (foods) {
                  setState(() {
                    _foods = foods;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Notes
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            NotesField(
              value: _notes,
              hintText: 'Commentaires sur ce repas...',
              onChanged: (value) {
                _notes = value.isEmpty ? null : value;
              },
            ),

            const SizedBox(height: 32),

            // Bouton de sauvegarde
            WakyGradientButton(
              label: _isEditing ? 'Enregistrer' : 'Ajouter le repas',
              icon: Icons.check,
              isLoading: _isLoading,
              onPressed: _save,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _plannedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('fr', 'FR'),
    );

    if (date != null) {
      setState(() {
        _plannedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _plannedDateTime.hour,
          _plannedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_plannedDateTime),
    );

    if (time != null) {
      setState(() {
        _plannedDateTime = DateTime(
          _plannedDateTime.year,
          _plannedDateTime.month,
          _plannedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final meal = _isEditing
          ? widget.meal!.copyWith(
              type: _selectedType,
              plannedDateTime: _plannedDateTime,
              title: _title,
              foods: _foods,
              quantity: _quantity,
              notes: _notes,
            )
          : Meal(
              type: _selectedType,
              plannedDateTime: _plannedDateTime,
              title: _title,
              foods: _foods,
              quantity: _quantity,
              notes: _notes,
            );

      bool success;
      if (_isEditing) {
        success = await ref.read(mealsProvider.notifier).updateMeal(meal);
      } else {
        final created = await ref.read(mealsProvider.notifier).createMeal(meal);
        success = created != null;
      }

      if (success && mounted) {
        HapticService.success();
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le repas ?'),
        content: const Text(
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(mealsProvider.notifier).deleteMeal(widget.meal!.id);
              if (mounted) {
                HapticService.medium();
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
