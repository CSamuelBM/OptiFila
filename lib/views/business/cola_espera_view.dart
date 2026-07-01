import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/service/ticket_queue_client.dart';

class QueueManagementView extends StatelessWidget {
  const QueueManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos la misma instancia del controlador para mantener la vista sincronizada
    final ctrl = AppControllers.business;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: const Text('Gestión de Fila', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.headerTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: ctrl,
        builder: (context, _) {
          if (ctrl.isLoading && ctrl.activeQueue.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => ctrl.loadDashboardData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // --- SERVING SECTION ---
                if (ctrl.servingTickets.isNotEmpty) ...[
                  const _SectionHeader(
                      title: 'Atendiendo Ahora',
                      icon: Icons.play_circle_fill,
                      color: AppTheme.accentOrange
                  ),
                  ...ctrl.servingTickets.map((ticket) => _TicketListItem(
                    ticket: ticket,
                    isActive: true,
                    onStatusUpdate: (clientId, action) {
                      // Mapeamos la acción string al método del controlador
                      if (action == 'missed') {
                        ctrl.missedTicket(clientId);
                      } else if (action == 'cancelled') {
                        ctrl.cancelTicket(clientId);
                      } else if (action == 'completed') {
                        ctrl.completeTicket(clientId);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Procesando solicitud...'))
                      );
                    },
                  )),
                  const SizedBox(height: 24),
                ],

                // --- WAITING SECTION ---
                _SectionHeader(
                    title: 'En Cola (${ctrl.waitingTickets.length})',
                    icon: Icons.people_alt,
                    color: AppTheme.headerTeal
                ),
                if (ctrl.waitingTickets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: Text('No hay clientes en espera', style: TextStyle(color: Colors.grey))),
                  )
                else
                  ...ctrl.waitingTickets.map((ticket) => _TicketListItem(
                    ticket: ticket,
                    isActive: false,
                    onStatusUpdate: (clientId, action) {
                      if (action == 'cancelled') {
                        ctrl.cancelTicket(clientId);
                      }
                    },
                  )),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TicketListItem extends StatelessWidget {
  final TicketQueueClient ticket;
  final bool isActive;
  final Function(String, String) onStatusUpdate;

  const _TicketListItem({
    required this.ticket,
    required this.isActive,
    required this.onStatusUpdate
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isActive ? Border.all(color: AppTheme.accentOrange.withOpacity(0.5), width: 2) : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isActive ? AppTheme.accentOrange : AppTheme.headerTeal.withOpacity(0.1),
                  child: isActive
                      ? const Icon(Icons.support_agent, color: Colors.white, size: 22)
                      : Text(
                    '${ticket.position}',
                    style: const TextStyle(
                        color: AppTheme.headerTeal,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.client.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Llegada: ${ticket.joinedAt.hour}:${ticket.joinedAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (!isActive)
                  const Icon(Icons.drag_indicator, color: Colors.grey),
              ],
            ),

            // Show action buttons ONLY if the ticket is being served
            if (isActive) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatusActionButton(
                    label: 'No asistió',
                    color: Colors.orange,
                    icon: Icons.person_off_outlined,
                    // Se envía el ID del cliente en lugar del ticketId
                    onPressed: () => onStatusUpdate(ticket.client.clientId, 'missed'),
                  ),
                  _StatusActionButton(
                    label: 'Cancelar',
                    color: Colors.redAccent,
                    icon: Icons.cancel_outlined,
                    // Se envía el ID del cliente en lugar del ticketId
                    onPressed: () => onStatusUpdate(ticket.client.clientId, 'cancelled'),
                  ),
                  _StatusActionButton(
                    label: 'Finalizar',
                    color: AppTheme.successGreen,
                    icon: Icons.check_circle_outline,
                    // Se envía el ID del cliente en lugar del ticketId
                    onPressed: () => onStatusUpdate(ticket.client.clientId, 'completed'),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
          ),
        ],
      ),
    );
  }
}

class _StatusActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _StatusActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
                label,
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)
            ),
          ],
        ),
      ),
    );
  }
}