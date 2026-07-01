import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import 'cola_espera_view.dart';

class InicioTab extends StatefulWidget {
  const InicioTab({super.key});

  @override
  State<InicioTab> createState() => _InicioTabState();
}

class _InicioTabState extends State<InicioTab> {
  @override
  void initState() {
    super.initState();

    // ── INICIALIZACIÓN SEGURA ──
    // addPostFrameCallback asegura que la petición se haga justo después
    // de que el widget termine de construirse por primera vez.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = AppControllers.business;

      ctrl.initRealTimeUpdates();
      ctrl.loadDashboardData(); // 👈 Forzamos la carga de datos frescos siempre
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.business;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final currentService = AppControllers.auth.service;

        return Container(
          color: const Color(0xFFD6EAF8),
          child: CustomScrollView(
            slivers: [
              // ── HEADER AZUL ──
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.headerTeal.withOpacity(0.9), AppTheme.headerTeal],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentService?.serviceName ?? 'Mi Negocio',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 2),
                          const Text('Dashboard de gestión',
                              style: TextStyle(fontSize: 14, color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _HeaderStat(
                                icon: Icons.group_outlined,
                                label: 'En espera',
                                value: '${ctrl.inQueueCount}'),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: _HeaderStat(
                                icon: Icons.access_time_outlined,
                                label: 'Tiempo prom.',
                                value: '8 min'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── ATENDIENDO AHORA CARD ──
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
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
                  child: Column(
                    children: [
                      const Text(
                        'Personas en atención',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppTheme.orangePale,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${ctrl.servingTickets.length}',
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.accentOrange),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Llamamos a la lógica de siguiente turno
                            ctrl.nextTicket();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentOrange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Siguiente Turno',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── COLA DE ESPERA HEADER ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cola de espera',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QueueManagementView(),
                            ),
                          );
                        },
                        child: const Text(
                          'Ver todos',
                          style: TextStyle(color: AppTheme.accentOrange, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── COLA DE ESPERA LISTA ──
              if (ctrl.isLoading && ctrl.waitingTickets.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) {
                      final t = ctrl.waitingTickets[i];
                      return Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(left: BorderSide(color: Colors.blue.shade600, width: 4)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppTheme.headerTeal.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${t.position}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.headerTeal,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: AppTheme.successGreen,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.client.fullName,
                                          style: const TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_outlined, size: 14, color: AppTheme.textSecondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${t.joinedAt.hour}:${t.joinedAt.minute.toString().padLeft(2, "0")}',
                                              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successGreen.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Esperando',
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.successGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: ctrl.waitingTickets.length,
                  ),
                ),

              // ── ESTADÍSTICAS DE HOY ──
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Text(
                    'Estadísticas de hoy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.bar_chart_rounded,
                          label: 'Atendidos',
                          value: '24', // Dato Mock
                          iconColor: AppTheme.accentOrange,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.trending_up_rounded,
                          label: 'Satisfacción',
                          value: '98%', // Dato Mock
                          iconColor: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
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

class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeaderStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _StatCard({required this.icon, required this.label, required this.value, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}