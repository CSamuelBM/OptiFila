import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../enum/turn_status_enum.dart';
import '../../models/turn_model.dart';

class MisTurnosTab extends StatefulWidget {
  const MisTurnosTab({super.key});
  @override
  State<MisTurnosTab> createState() => _State();
}

class _State extends State<MisTurnosTab> {
  int _tabIdx = 0;
  static const _tabs = ['Todos', 'Activos', 'Completados', 'Cancelados'];

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;
    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final all = ctrl.allTurns;
        final active = ctrl.activeTurns;
        final completed = ctrl.completedTurns;
        final cancelled = ctrl.cancelledTurns;
        final lists = [all, active, completed, cancelled];
        final counts = [all.length, active.length, completed.length, cancelled.length];

        // ── Se añadió el Container con el color de fondo ──
        return Container(
          color: const Color(0xFFD6EAF8),
          child: Column(
            children: [
              // Header con degradado y botón "Volver"
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.headerTeal.withOpacity(0.8),
                      AppTheme.headerTeal
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          SizedBox(width: 6),
                          Text('Volver', style: TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Mis Turnos',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('Historial y turnos activos',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Activos',
                            value: active.length,
                            icon: Icons.circle,
                            iconColor: AppTheme.successGreen,
                            isSelected: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Completados',
                            value: completed.length,
                            icon: Icons.check_circle_outline,
                            iconColor: AppTheme.textSecondary,
                            isSelected: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Filter tabs
              Container(
                // Se cambió a transparente para que se vea el fondo azul claro
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final sel = _tabIdx == i;
                      return GestureDetector(
                        onTap: () => setState(() => _tabIdx = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel ? AppTheme.headerTeal : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? AppTheme.headerTeal : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            '${_tabs[i]} (${counts[i]})',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: sel ? Colors.white : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: lists[_tabIdx].length,
                  itemBuilder: (ctx, i) => _TurnCard(turn: lists[_tabIdx][i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 8),
        Text('$value',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
    ),
  );
}

class _TurnCard extends StatelessWidget {
  final TurnModel turn;
  const _TurnCard({required this.turn});

  Color get _numColor {
    switch (turn.status) {
      case TurnStatus.active:
        return AppTheme.headerTeal;
      case TurnStatus.completed:
        return Colors.blue.shade300;
      case TurnStatus.cancelled:
        return AppTheme.errorRed;
    }
  }

  Color get _borderColor {
    switch (turn.status) {
      case TurnStatus.active:
        return AppTheme.successGreen;
      case TurnStatus.completed:
        return Colors.blue.shade100;
      case TurnStatus.cancelled:
        return AppTheme.errorRed.withOpacity(0.4);
    }
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Hoy - ${_t(d)}';
    }
    final yest = now.subtract(const Duration(days: 1));
    if (d.year == yest.year && d.month == yest.month && d.day == yest.day) {
      return 'Ayer - ${_t(d)}';
    }
    return '${d.day} Mar - ${_t(d)}';
  }

  String _t(DateTime d) {
    final h = d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final suffix = h >= 12 ? 'PM' : 'AM';
    final h12 = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$h12:$m $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: _borderColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _numColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('${turn.number}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _numColor)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              turn.businessName,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (turn.status == TurnStatus.active)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Activo',
                                  style: TextStyle(
                                      fontSize: 11, color: AppTheme.successGreen, fontWeight: FontWeight.bold)),
                            )
                          else
                            Icon(
                              turn.status == TurnStatus.completed
                                  ? Icons.check_circle_outline
                                  : Icons.cancel_outlined,
                              size: 22,
                              color: turn.status == TurnStatus.completed
                                  ? Colors.blue.shade300
                                  : AppTheme.errorRed,
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(turn.businessType,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(turn.address,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(_formatDate(turn.dateTime),
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          if (turn.status == TurnStatus.active && turn.waitMinutes != null) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Espera: ${turn.waitMinutes} min',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ],
                      ),
                    ],
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