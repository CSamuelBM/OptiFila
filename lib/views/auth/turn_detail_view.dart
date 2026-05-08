import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app_theme.dart';
import '../../models/business_model.dart';

class TurnDetailView extends StatelessWidget {
  final BusinessModel business;
  const TurnDetailView({super.key, required this.business});

  static const int _turnNumber    = 42;
  static const int _currentServing = 39;
  static const int _peopleAhead   = 3;
  static const int _waitMinutes   = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // ── Header ──
                Container(
                  width: double.infinity,
                  color: AppTheme.headerTeal,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    bottom: 32,
                    left: 16, right: 16,
                  ),
                  child: Column(children: [
                    // Back
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                          Text('Volver', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Tu turno', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 12),
                    // Turn number circle
                    Container(
                      width: 100, height: 100,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Center(
                        child: Text(
                          '$_turnNumber',
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppTheme.accentOrange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      business.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: Colors.white70),
                      const SizedBox(width: 3),
                      Text(business.address, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ]),
                  ]),
                ),

                // ── Status card ──
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderColor, width: 0.5),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Tiempo estimado',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          Row(children: [
                            Container(
                              width: 28, height: 28,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(color: AppTheme.orangePale, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.access_time_outlined, size: 15, color: AppTheme.accentOrange),
                            ),
                            const Text('$_waitMinutes min',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                          ]),
                        ]),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          const Text('Personas delante',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                          const Text('$_peopleAhead',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Atendiendo: #$_currentServing',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        Text('Tu turno: #$_turnNumber',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.3,
                        minHeight: 6,
                        backgroundColor: AppTheme.bgGray,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentOrange),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Confirmed chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF3B82F6)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Tu turno está confirmado. Te avisaremos cuando estés cerca.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF3B82F6)),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),

                // ── Importante ──
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderColor, width: 0.5),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.info_outline, size: 18, color: AppTheme.accentOrange),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Importante',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                        SizedBox(height: 4),
                        Text(
                          'Por favor, mantente cerca del establecimiento. Si no estás presente cuando sea tu turno, este será cancelado automáticamente.',
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5),
                        ),
                      ]),
                    ),
                  ]),
                ),

                // ── QR Code ──
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderColor, width: 0.5),
                  ),
                  child: Column(children: [
                    const Text('Código QR de tu turno',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    const SizedBox(height: 16),
                    // QR placeholder
                    const _QrPlaceholder(),
                    const SizedBox(height: 12),
                    const Text('Muestra este código en el establecimiento',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ]),
                ),

                // ── Cancel button ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: OutlinedButton(
                    onPressed: () => _confirmCancel(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.errorRed, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Cancelar Turno',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.borderColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('¿Cancelar turno?',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text('Esta acción no se puede deshacer.',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close sheet
              Navigator.pop(context); // close turn detail
              Navigator.pop(context); // close business detail
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorRed),
            child: const Text('Sí, cancelar'),
          )),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mantener turno', style: TextStyle(color: AppTheme.textPrimary)),
          )),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// Simple QR placeholder drawn with Canvas
class _QrPlaceholder extends StatelessWidget {
  const _QrPlaceholder();

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(130, 130),
    painter: _QrPainter(),
  );
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF6B7280);
    final w = size.width;
    final h = size.height;
    final cs = w * 0.22; // corner square size
    final t  = w * 0.04; // thickness

    void cornerSquare(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cs, cs), p);
      canvas.drawRect(Rect.fromLTWH(x + t, y + t, cs - t * 2, cs - t * 2), Paint()..color = Colors.white);
      canvas.drawRect(Rect.fromLTWH(x + t * 2, y + t * 2, cs - t * 4, cs - t * 4), p);
    }

    cornerSquare(0, 0);
    cornerSquare(w - cs, 0);
    cornerSquare(0, h - cs);

    // Data lines
    p.strokeWidth = t;
    p.strokeCap   = StrokeCap.round;
    final rng     = math.Random(42);
    for (int row = 0; row < 8; row++) {
      double x = cs + t * 2;
      final y  = (h / 10) * (row + 1.5);
      while (x < w - t) {
        final len = (rng.nextDouble() * w * 0.15) + w * 0.04;
        canvas.drawLine(Offset(x, y), Offset(math.min(x + len, w - t), y), p);
        x += len + (rng.nextDouble() * w * 0.06) + w * 0.03;
      }
    }
  }
  @override bool shouldRepaint(_) => false;
}
