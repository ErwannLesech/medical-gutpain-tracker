import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'meals_provider.dart';
import 'meal_form_screen.dart';
import 'shopping_list_screen.dart';

/// Écran principal des repas avec calendrier
class MealsScreen extends ConsumerStatefulWidget {
  const MealsScreen({super.key});

  @override
  ConsumerState<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends ConsumerState<MealsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final mealsState = ref.watch(mealsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // En-tête avec date
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes repas',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          DateFormat('EEEE d MMMM', 'fr_FR')
                              .format(mealsState.selectedDate),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    tooltip: 'Liste de courses',
                    onPressed: () => _navigateToShoppingList(context),
                  ),
                  IconButton(
                    icon: Icon(
                      _calendarFormat == CalendarFormat.week
                          ? Icons.calendar_view_month
                          : Icons.calendar_view_week,
                    ),
                    onPressed: () {
                      setState(() {
                        _calendarFormat = _calendarFormat == CalendarFormat.week
                            ? CalendarFormat.month
                            : CalendarFormat.week;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Calendrier
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              locale: 'fr_FR',
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) {
                return isSameDay(mealsState.selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                HapticService.selection();
                ref.read(mealsProvider.notifier).selectDate(selectedDay);
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: WakyColors.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: WakyColors.primary,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.grey.shade600),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),

            // Liste des repas
            Expanded(
              child: mealsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : mealsState.meals.isEmpty
                      ? _buildEmptyState(context)
                      : _buildMealsList(context, mealsState.meals),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍽️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Aucun repas pour cette journée',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez votre premier repas',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            _buildAddMealButton(context),
            const SizedBox(height: 16),
            WakyPrimaryButton(
              label: 'Générer les repas du jour',
              icon: Icons.auto_fix_high,
              onPressed: () async {
                // TODO: Récupérer les settings
                // Pour l'instant, on utilise des valeurs par défaut
                await ref.read(mealsProvider.notifier).generatePlannedMeals(
                  AppSettings(),
                );
                HapticService.success();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsList(BuildContext context, List<Meal> meals) {
    // Trie les repas par heure planifiée
    final sortedMeals = List<Meal>.from(meals)
      ..sort((a, b) => a.plannedDateTime.compareTo(b.plannedDateTime));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMeals.length + 1, // +1 pour le bouton d'ajout
      itemBuilder: (context, index) {
        if (index == sortedMeals.length) {
          // Bouton d'ajout en bas de la liste
          return Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: _buildAddMealButton(context),
          );
        }
        
        final meal = sortedMeals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MealCard(
            mealType: meal.typeName,
            emoji: meal.typeEmoji,
            time: DateFormat('HH:mm').format(meal.plannedDateTime),
            foods: meal.foods,
            title: meal.title,
            notes: meal.notes,
            onTap: () => _navigateToEditMeal(context, meal),
          ),
        );
      },
    );
  }

  Widget _buildAddMealButton(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToAddMeal(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: WakyColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: WakyColors.success,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: WakyColors.success,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Appuyer pour ajouter un repas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: WakyColors.success,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddMeal(BuildContext context) {
    final selectedDate = ref.read(mealsProvider).selectedDate;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealFormScreen(
          initialDate: selectedDate,
        ),
      ),
    );
  }

  void _navigateToEditMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealFormScreen(
          meal: meal,
        ),
      ),
    );
  }

  void _navigateToShoppingList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ShoppingListScreen(),
      ),
    );
  }
}
