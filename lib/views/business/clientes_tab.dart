import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/client_model.dart';

class ClientesTab extends StatelessWidget {
  const ClientesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.business;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final clients = ctrl.filteredClients;

        return Container(
          color: const Color(0xFFD6EAF8), // Fondo azul claro
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── ENCABEZADO Y TARJETAS FLOTANTES ──
              Stack(
                clipBehavior: Clip.none, // Permite que las tarjetas sobresalgan del Stack
                children: [
                  // 1. Fondo Azul del Header
                  Container(
                    width: double.infinity,
                    color: AppTheme.headerTeal,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                      right: 16,
                      bottom: 64, // Extra espacio inferior para empujar el contenido abajo
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Clientes',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        const Text('Gestiona tu base de clientes',
                            style: TextStyle(fontSize: 14, color: Colors.white70)),
                        const SizedBox(height: 20),
                        // Buscador
                        TextField(
                          onChanged: ctrl.searchClients,
                          decoration: InputDecoration(
                            hintText: 'Buscar clientes...',
                            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: AppTheme.textLight),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Módulos de Estadísticas Flotantes Separados
                  Positioned(
                    bottom: -35, // Las empujamos hacia abajo a la mitad entre lo azul y el fondo
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(child: _StatCard(value: ctrl.totalClients, label: 'Total')),
                        const SizedBox(width: 12), // Separación entre tarjetas
                        Expanded(child: _StatCard(value: ctrl.todayClients, label: 'Hoy')),
                        const SizedBox(width: 12),
                        Expanded(child: _StatCard(value: ctrl.weekClients, label: 'Esta semana')),
                      ],
                    ),
                  ),
                ],
              ),

              // Espacio vacío para compensar lo que ocupan las tarjetas flotantes
              const SizedBox(height: 55),

              // ── CONTADOR DE CLIENTES ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${clients.length} clientes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                ),
              ),

              const SizedBox(height: 12),

              // ── LISTA DE CLIENTES ──
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: clients.length,
                  itemBuilder: (ctx, i) => _ClientCard(client: clients[i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── WIDGETS AUXILIARES ──

class _StatCard extends StatelessWidget {
  final int value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClientModel client;

  const _ClientCard({required this.client});

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Hoy, ${d.hour}:${d.minute.toString().padLeft(2, "0")} ${d.hour >= 12 ? 'PM' : 'AM'}';
    }
    final yest = now.subtract(const Duration(days: 1));
    if (d.year == yest.year && d.month == yest.month && d.day == yest.day) {
      return 'Ayer, ${d.hour}:${d.minute.toString().padLeft(2, "0")} ${d.hour >= 12 ? 'PM' : 'AM'}';
    }
    return 'Hace ${now.difference(d).inDays} días';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppTheme.headerTeal, // Franja azul igual para todas las tarjetas
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Foto de perfil con el puntito verde si está en turno
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.headerTeal.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 22, color: AppTheme.headerTeal),
                      ),
                      if (client.isInTurn)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 14, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(client.lastVisit),
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (client.isInTurn)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.headerTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'En turno',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 16, color: AppTheme.headerTeal),
                  const SizedBox(width: 8),
                  Text(client.email, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone_outlined, size: 16, color: AppTheme.headerTeal),
                  const SizedBox(width: 8),
                  Text(client.phone, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total de visitas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.headerTeal)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.bgGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${client.totalVisits}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}