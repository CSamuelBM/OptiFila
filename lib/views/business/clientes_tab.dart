import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class ClientesTab extends StatefulWidget {
  const ClientesTab({super.key});

  @override
  State<ClientesTab> createState() => _ClientesTabState();
}

class _ClientesTabState extends State<ClientesTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Usamos el controlador real
    final ctrl = AppControllers.business;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        // 1. Extraemos los clientes de la cola activa
        final allClients = ctrl.activeQueue.map((t) => t.client).toSet().toList();

        // 2. Filtramos localmente según lo que el usuario escriba en el TextField
        final filteredClients = _searchQuery.isEmpty
            ? allClients
            : allClients.where((c) {
          final fullName = '${c.fullName}'.toLowerCase();
          final query = _searchQuery.toLowerCase();
          return fullName.contains(query);
        }).toList();

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
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
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
                        Expanded(child: _StatCard(value: allClients.length, label: 'Total')),
                        const SizedBox(width: 12),
                        // Dato mock temporal, igual que en InicioTab
                        const Expanded(child: _StatCard(value: 24, label: 'Atendidos')),
                        const SizedBox(width: 12),
                        // Conectado al getter real del controller
                        Expanded(child: _StatCard(value: ctrl.inQueueCount, label: 'En Cola')),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 55),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${filteredClients.length} clientes encontrados',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: filteredClients.isEmpty
                    ? const Center(
                  child: Text(
                    'No hay clientes para mostrar.',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filteredClients.length,
                  itemBuilder: (ctx, i) => _ClientCard(client: filteredClients[i]),
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
  // Usamos dynamic en lugar de ClientModel para aceptar el ClientSummary sin problemas de importación
  final dynamic client;

  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    // Obtenemos directamente el fullName del ClientSummary
    final String fullName = client.fullName ?? 'Cliente Desconocido';

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
                        // Omitimos el correo aquí porque ClientSummary suele no traerlo
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
                  Text('En cola de espera', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
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