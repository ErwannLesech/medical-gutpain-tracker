import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/theme/colors.dart';
import 'pain_provider.dart';

/// Écran de saisie rapide de douleur
class PainFormScreen extends ConsumerStatefulWidget {
  final PainEvent? event;

  const PainFormScreen({
    super.key,
    this.event,
  });

  @override
  ConsumerState<PainFormScreen> createState() => _PainFormScreenState();
}

class _PainFormScreenState extends ConsumerState<PainFormScreen> {
  late int _intensity;
  late bool _isUsual;
  late DigestiveState _digestiveState;
  late List<int> _symptomsIndexes;
  String? _description;
  String? _otherMomentDescription;
  bool _isLoading = false;

  bool get _isEditing => widget.event != null;

  // Options de symptômes
  static const _symptomOptions = [
    SymptomOption(label: 'Ballonnements', emoji: '🎈'),
    SymptomOption(label: 'Nausées', emoji: '🤢'),
    SymptomOption(label: 'Crampes', emoji: '💥'),
    SymptomOption(label: 'Brûlures', emoji: '🔥'),
    SymptomOption(label: 'Diarrhée', emoji: '💨'),
    SymptomOption(label: 'Constipation', emoji: '🧱'),
    SymptomOption(label: 'Gaz', emoji: '💨'),
    SymptomOption(label: 'Reflux', emoji: '🔼'),
    SymptomOption(label: 'Fatigue', emoji: '😴'),
    SymptomOption(label: 'Autre', emoji: '❓'),
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _intensity = widget.event!.intensity;
      _isUsual = widget.event!.isUsual;
      _digestiveState = widget.event!.digestiveState;
      _symptomsIndexes = List.from(widget.event!.symptomsIndexes);
      _description = widget.event!.description;
      _otherMomentDescription = widget.event!.otherMomentDescription;
    } else {
      _intensity = 3;
      _isUsual = true; // Activé par défaut
      _digestiveState = DigestiveState.hungry;
      _symptomsIndexes = [];
      _description = null;
      _otherMomentDescription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier' : 'Nouvelle douleur'),
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
            // Intensité
            Text(
              'Intensité de la douleur',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            PainIntensitySlider(
              value: _intensity,
              onChanged: (value) {
                HapticService.selection();
                setState(() => _intensity = value);
              },
            ),

            const SizedBox(height: 32),

            // Douleur habituelle ?
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cette douleur est-elle habituelle ?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Switch(
                  value: _isUsual,
                  onChanged: (value) {
                    HapticService.selection();
                    setState(() => _isUsual = value);
                  },
                ),
              ],
            ),

            // Champ de description si la douleur n'est PAS habituelle
            if (!_isUsual) ...[
              const SizedBox(height: 12),
              NotesField(
                value: _description,
                hintText: 'Décrivez cette nouvelle douleur...',
                minLines: 2,
                maxLength: 200,
                onChanged: (value) {
                  _description = value.isEmpty ? null : value;
                },
              ),
            ],

            const SizedBox(height: 24),

            // État digestif
            Text(
              'État au moment de la douleur',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DigestiveState.values.map((state) {
                final isSelected = _digestiveState == state;
                return WakySelectButton(
                  label: _getDigestiveStateName(state),
                  emoji: _getDigestiveStateEmoji(state),
                  isSelected: isSelected,
                  onTap: () {
                    HapticService.selection();
                    setState(() => _digestiveState = state);
                  },
                );
              }).toList(),
            ),

            // Champ pour préciser "Autre" moment
            if (_digestiveState == DigestiveState.other) ...[
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: _otherMomentDescription),
                decoration: InputDecoration(
                  hintText: 'Précisez le moment...',
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  _otherMomentDescription = value.isEmpty ? null : value;
                },
              ),
            ],

            const SizedBox(height: 24),

            // Symptômes
            Text(
              'Symptômes associés',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            SymptomSelector(
              options: _symptomOptions,
              selectedIndexes: _symptomsIndexes,
              onChanged: (indexes) {
                HapticService.selection();
                setState(() => _symptomsIndexes = indexes);
              },
            ),

            const SizedBox(height: 24),

            // Description (uniquement si douleur habituelle, sinon c'est déjà affiché plus haut)
            if (_isUsual) ...[
              Text(
                'Description (optionnel)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              NotesField(
                value: _description,
                hintText: 'Décrivez brièvement la douleur...',
                minLines: 2,
                maxLength: 200,
                onChanged: (value) {
                  _description = value.isEmpty ? null : value;
                },
              ),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 8),

            // Bouton de sauvegarde
            WakyGradientButton(
              label: _isEditing ? 'Enregistrer' : 'Enregistrer la douleur',
              icon: Icons.check,
              isLoading: _isLoading,
              gradient: LinearGradient(
                colors: [
                  WakyColors.getIntensityColor(_intensity),
                  WakyColors.getIntensityColor(_intensity).withValues(alpha: 0.7),
                ],
              ),
              onPressed: _save,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _getDigestiveStateName(DigestiveState state) {
    switch (state) {
      case DigestiveState.hungry:
        return 'À jeun';
      case DigestiveState.postMeal:
        return 'Après repas';
      case DigestiveState.other:
        return 'Autre';
    }
  }

  String _getDigestiveStateEmoji(DigestiveState state) {
    switch (state) {
      case DigestiveState.hungry:
        return '🍽️';
      case DigestiveState.postMeal:
        return '🍴';
      case DigestiveState.other:
        return '❓';
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);

    try {
      final event = _isEditing
          ? widget.event!.copyWith(
              intensity: _intensity,
              isUsual: _isUsual,
              digestiveState: _digestiveState,
              symptomsIndexes: _symptomsIndexes,
              description: _description,
              otherMomentDescription: _otherMomentDescription,
            )
          : PainEvent(
              dateTime: DateTime.now(),
              intensity: _intensity,
              isUsual: _isUsual,
              digestiveState: _digestiveState,
              symptomsIndexes: _symptomsIndexes,
              description: _description,
              otherMomentDescription: _otherMomentDescription,
            );

      bool success;
      if (_isEditing) {
        success = await ref.read(painEventsProvider.notifier).updateEvent(event);
      } else {
        final created = await ref.read(painEventsProvider.notifier).createEvent(event);
        success = created != null;
      }

      if (success && mounted) {
        HapticService.success();
        // Rafraîchir les événements récents
        ref.invalidate(recentPainEventsProvider);
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
        title: const Text('Supprimer ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(painEventsProvider.notifier).deleteEvent(widget.event!.id);
              if (mounted) {
                HapticService.medium();
                ref.invalidate(recentPainEventsProvider);
                ref.invalidate(weeklyPainEventsCountProvider);
                ref.invalidate(painStatsProvider);
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
