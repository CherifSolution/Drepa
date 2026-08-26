import 'package:flutter/material.dart';
import 'crisis_dialog.dart';
import 'sos_dialog.dart';
import 'pdf_report_service.dart';
import '../services/supabase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _waterDrank = 1.5;
  final double _waterGoal = 3.0;
  final SupabaseService _supabaseService = SupabaseService();

  void _addWater(double amount) {
    setState(() {
      _waterDrank = (_waterDrank + amount).clamp(0.0, _waterGoal);
    });
    _supabaseService.addWater(amount);
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (_waterDrank / _waterGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Drep'Care", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A365D),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            tooltip: 'Exporter Rapport PDF',
            onPressed: () async {
              final crises = await _supabaseService.getCrises();
              if (context.mounted) {
                PdfReportService.generateAndPrintReport(crises);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alerte Météo Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF59E0B)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wb_sunny_rounded, color: Color(0xFFD97706), size: 30),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Alerte Température", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                        Text("Chaleur élevée aujourd'hui (31°C). Augmentez votre consommation d'eau.", style: TextStyle(fontSize: 12, color: Color(0xFFB45309))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card Hydratation
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Hydratation du jour", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A365D))),
                        Text("${_waterDrank.toStringAsFixed(1)}L / ${_waterGoal.toStringAsFixed(0)}L", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: percentage,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF38BDF8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _addWater(0.25),
                          icon: const Icon(Icons.local_drink),
                          label: const Text("+250ml"),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0F2FE), foregroundColor: const Color(0xFF0284C7)),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _addWater(0.50),
                          icon: const Icon(Icons.water_drop),
                          label: const Text("+500ml"),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0F2FE), foregroundColor: const Color(0xFF0284C7)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Boutons d'action rapides
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => showDialog(context: context, builder: (_) => const CrisisDialog()),
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_alert_rounded, color: Color(0xFF2563EB), size: 36),
                          SizedBox(height: 8),
                          Text("Saisir une Crise", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => showDialog(context: context, builder: (_) => const SosDialog()),
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sos_rounded, color: Colors.redAccent, size: 40),
                          SizedBox(height: 4),
                          Text("BOUTON SOS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
