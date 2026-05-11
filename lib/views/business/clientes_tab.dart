import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/client_model.dart';

class ClientesTab extends StatelessWidget {
  const ClientesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos el controlador real que pasaste
    final ctrl = AppControllers.business;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final clients = ctrl.filteredClients;

        return Container(
          color: const Color(0xFFD6EAF8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    color: AppTheme.headerTeal,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: 16,
                      right: 16,
                      bottom: 64,
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: -35,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(child: _StatCard(value: ctrl.totalClients, label: 'Total')),
                        const SizedBox(width: 12),
                        // Nota: Estos campos deben existir en tu controller o ser calculados
                        Expanded(child: _StatCard(value: ctrl.attendedToday, label: 'Atendidos')),
                        const SizedBox(width: 12),
                        Expanded(child: _StatCard(value: ctrl.inQueue, label: 'En Cola')),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 55),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${clients.length} clientes registrados',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                ),
              ),

              const SizedBox(height: 12),

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
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.headerTeal)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.blueGrey)),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClientModel client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    // Adaptamos los nombres a tu ClientModel real
    final String fullName = '${client.firstName} ${client.lastName} ${client.secondLastName}'.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppTheme.headerTeal, width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                        ),
                        Text(
                          client.email,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cliente verificado', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}