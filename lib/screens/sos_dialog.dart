import 'package:flutter/material.dart';

class SosDialog extends StatelessWidget {
  const SosDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFEF2F2),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
          SizedBox(width: 8),
          Text("URGENCE SOS", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Alerte SOS Déclenchée !", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Notification Push envoyée aux proches."),
          Text("• SMS de géolocalisation transmis."),
          SizedBox(height: 16),
          Divider(),
          Text("Fiche Médicale d'Urgence :", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A365D))),
          Text("Pathologie : Drépanocytose SS"),
          Text("Groupe Sanguin : A+"),
          Text("Médecin Référent : Dr. Martin (06 00 00 00 00)"),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(context),
          child: const Text("Fermer l'Alerte", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
