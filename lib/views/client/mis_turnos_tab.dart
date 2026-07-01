import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/service/ticket_queue_client.dart';

class MyTicketsTab extends StatefulWidget {
  const MyTicketsTab({super.key});

  @override
  State<MyTicketsTab> createState() => _MyTicketsTabState();
}

class _MyTicketsTabState extends State<MyTicketsTab> {
  int _tabIdx = 0;

  // Pestañas actualizadas al español
  static const _tabs = [
    'Todos',
    'Activos',
    'Completados',
    'Cancelados',
    'Perdidos',
  ];

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        // Obtenemos las listas del controlador
        final all = ctrl.allTickets;
        final completed = ctrl.completedTickets;
        final cancelled = ctrl.cancelledTickets;
        final active = ctrl.activeTickets;

        // Filtrando 'MISSED' manualmente
        final missed = all.where((t) => t.status == 'MISSED').toList();

        final lists = [all, active, completed, cancelled, missed];
        final counts = [
          all.length,
          active.length,
          completed.length,
          cancelled.length,
          missed.length,
        ];

        return Container(
          color: const Color(0xFFD6EAF8), // Fondo azul claro
          child: Column(
            children: [
              // ── Encabezado ──
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.headerTeal.withOpacity(0.8),
                      AppTheme.headerTeal,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 32,
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mis Tickets',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Historial y tickets activos',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
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

              // ── Pestañas de Filtro ──
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_tabs.length, (i) {
                      final sel = _tabIdx == i;
                      return GestureDetector(
                        onTap: () => setState(() => _tabIdx = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: sel ? AppTheme.headerTeal : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? AppTheme.headerTeal
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            '${_tabs[i]} (${counts[i]})',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // ── Lista de Tickets ──
              Expanded(
                child: ctrl.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : lists[_tabIdx].isEmpty
                    ? const Center(
                        child: Text("No hay tickets en esta categoría"),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: lists[_tabIdx].length,
                        itemBuilder: (ctx, i) =>
                            _TicketCard(ticket: lists[_tabIdx][i]),
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketQueueClient ticket;

  const _TicketCard({required this.ticket});

  // Determina el color principal basado en el estado
  Color get _mainColor {
    switch (ticket.status) {
      case 'WAITING':
        return AppTheme.headerTeal;
      case 'IN_PROGRESS':
        return AppTheme.successGreen;
      case 'COMPLETED':
        return Colors.blue.shade400;
      case 'CANCELLED':
        return AppTheme.errorRed;
      case 'MISSED':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Traduce el estado del API a un string en español amigable para el usuario
  String get _displayStatus {
    switch (ticket.status) {
      case 'WAITING':
        return 'En espera';
      case 'IN_PROGRESS':
        return 'En progreso';
      case 'COMPLETED':
        return 'Completado';
      case 'CANCELLED':
        return 'Cancelado';
      case 'MISSED':
        return 'Perdido';
      default:
        return ticket.status;
    }
  }

  // Renderiza la posición o un ícono dependiendo del estado
  Widget _buildPositionIndicator() {
    // WAITING -> mostrar posición real
    if (ticket.status == 'WAITING') {
      return Text(
        '${ticket.position}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _mainColor,
        ),
      );
    }

    // IN_PROGRESS -> mostrar ícono de atención
    if (ticket.status == 'IN_PROGRESS') {
      return Icon(Icons.campaign_rounded, color: _mainColor, size: 26);
    }

    IconData iconData;

    switch (ticket.status) {
      case 'COMPLETED':
        iconData = Icons.check_circle_outline;
        break;

      case 'CANCELLED':
        iconData = Icons.cancel_outlined;
        break;

      case 'MISSED':
        iconData = Icons.timer_off_outlined;
        break;

      default:
        iconData = Icons.info_outline;
        break;
    }

    return Icon(iconData, color: _mainColor, size: 26);
  }

  // Muestra un diálogo de confirmación antes de cancelar
  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar fila'),
        content: const Text('¿Estás seguro de cancelar este ticket?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('No'),
          ),

          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final success = await AppControllers.client.cancelTicket(
                ticket.client.clientId,
              );

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? 'Cancelación enviada' : 'Error cancelando ticket',
                  ),
                ),
              );
            },
            child: const Text(
              'Sí, cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
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
            border: Border(left: BorderSide(color: _mainColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Indicador de Posición o Ícono
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _mainColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: _buildPositionIndicator()),
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
                              ticket.service.serviceName,
                              // Nombre del servicio
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _mainColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _displayStatus,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Categoría del servicio
                      Text(
                        ticket.service.category.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            // Email del servicio
                            child: Text(
                              ticket.service.email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (ticket.status == 'IN_PROGRESS') ...[
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.notifications_active,
                              size: 16,
                              color: AppTheme.successGreen,
                            ),

                            const SizedBox(width: 6),

                            const Text(
                              'Es tu turno ahora',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successGreen,
                              ),
                            ),
                          ],
                        ),
                      ],

                      if (ticket.status == 'WAITING') ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => _confirmCancel(context),
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 16,
                              color: AppTheme.errorRed,
                            ),
                            label: const Text(
                              'Cancelar fila',
                              style: TextStyle(
                                color: AppTheme.errorRed,
                                fontSize: 13,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: AppTheme.errorRed.withOpacity(
                                0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
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
