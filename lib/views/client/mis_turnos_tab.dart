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

  // Tabs actualizados para coincidir con la lógica del controlador
  static const _tabs = ['Todos', 'Activos', 'Completados', 'Cancelados', 'No asistió'];

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        // Obtenemos las listas desde el controlador
        final all = ctrl.allTurns;
        final completed = ctrl.completedTurns;
        final cancelled = ctrl.cancelledTurns;

        // CORRECCIÓN: Filtrar 'missed' manualmente ya que no existe en el controlador
        final missed = all.where((t) => t.status == TurnStatus.missed).toList();

        // CORRECCIÓN: Asegurar que 'active' incluya waiting e inProgress si el controller no lo hace
        final active = all.where((t) => t.status == TurnStatus.waiting || t.status == TurnStatus.inProgress).toList();

        final lists = [all, active, completed, cancelled, missed];
        final counts = [all.length, active.length, completed.length, cancelled.length, missed.length];

        return Container(
          color: const Color(0xFFD6EAF8), // Fondo azul claro solicitado
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.headerTeal.withOpacity(0.8), AppTheme.headerTeal],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16, right: 16, bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
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
                            icon: Icons.access_time_filled,
                            iconColor: AppTheme.successGreen,
                            isSelected: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            label: 'Completados',
                            value: completed.length,
                            icon: Icons.check_circle,
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
                            border: Border.all(color: sel ? AppTheme.headerTeal : Colors.grey.shade300),
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
                child: lists[_tabIdx].isEmpty
                    ? const Center(child: Text("No hay turnos en esta categoría"))
                    : ListView.builder(
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

// CORRECCIÓN: Widget _StatCard definido
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
  Widget build(BuildContext context) {
    return Container(
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
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}

class _TurnCard extends StatelessWidget {
  final TurnModel turn;
  const _TurnCard({required this.turn});

  Color get _mainColor {
    switch (turn.status) {
      case TurnStatus.waiting: return AppTheme.headerTeal;
      case TurnStatus.inProgress: return AppTheme.successGreen;
      case TurnStatus.completed: return Colors.blue.shade400;
      case TurnStatus.canceled: return AppTheme.errorRed;
      case TurnStatus.missed: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: _mainColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: _mainColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('${turn.number}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _mainColor)),
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
                            child: Text(turn.businessName,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _mainColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              turn.status.toSpanish(),
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _mainColor),
                            ),
                          ),
                        ],
                      ),
                      Text(turn.businessType, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(turn.address,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
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