import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/crisis_model.dart';
import '../services/supabase_service.dart';

class CrisisDialog extends StatefulWidget {
  const CrisisDialog({super.key});

  @override
  State<CrisisDialog> createState() => _CrisisDialogState();
}

class _CrisisDialogState extends State<CrisisDialog> {
  double _painLevel = 5;
  String _selectedZone = 'Jambes';
  final List<String> _selectedSymptoms = [];
  final List<String> _selectedTreatments = [];

  final List<String> _zones = ['Bras', 'Jambes', 'Dos', 'Poitrine', 'Abdomen', 'Tête'];
  final List<String> _symptoms = ['Fièvre', 'Fatigue extrême', 'Difficulté respiratoire', 'Vertiges'];
  final List<String> _treatments = ['Hydratation intense', 'Paracétamol', 'Morphine/Antalgique fort', 'Repos'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enregistrer une crise", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A365D))),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Niveau de douleur : ${_painLevel.toInt()}/10", style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _painLevel,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: Colors.redAccent,
              label: _painLevel.toInt().toString(),
              onChanged: (val) => setState(() => _painLevel = val),
            ),
            const SizedBox(height: 12),
            const Text("Zone principale :", style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: _zones.map((zone) {
                final isSelected = _selectedZone == zone;
                return ChoiceChip(
                  label: Text(zone),
                  selected: isSelected,
                  selectedColor: const Color(0xFF38BDF8),
                  onSelected: (val) => setState(() => _selectedZone = zone),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text("Symptômes associés :", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._symptoms.map((symptom) => CheckboxListTile(
                  title: Text(symptom, style: const TextStyle(fontSize: 14)),
                  value: _selectedSymptoms.contains(symptom),
                  dense: true,
                  onChanged: (val) {
                    setState(() {
                      val! ? _selectedSymptoms.add(symptom) : _selectedSymptoms.remove(symptom);
                    });
                  },
                )),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A365D)),
          onPressed: () async {
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null) {
              final crisis = Crisis(
                userId: user.id,
                painLevel: _painLevel.toInt(),
                bodyZone: _selectedZone,
                symptoms: _selectedSymptoms,
                treatments: _selectedTreatments,
                createdAt: DateTime.now(),
              );
              await SupabaseService().logCrisis(crisis);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("Enregistrer", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
