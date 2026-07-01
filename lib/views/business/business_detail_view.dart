import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart'; // <--- Importa tu AppControllers para usar la instancia del ClientController
import '../../models/service/service_model.dart';
import '../client/client_shell.dart';

class BusinessDetailView extends StatelessWidget {
  final ServiceModel service;

  const BusinessDetailView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero header ──
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      // Gradient bg
                      Container(
                        height: 220,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE8A020), Color(0xFF1B3A50)],
                          ),
                        ),
                      ),
                      // Back button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textPrimary),
                          ),
                        ),
                      ),
                      // Category + rating chips
                      Positioned(
                        bottom: 50,
                        left: 16,
                        child: Row(children: [
                          _Chip(label: service.category.displayName), // <--- Categoría dinámica
                          const SizedBox(width: 8),
                          const _Chip(
                            label: '⭐ 4.5 (124)', // Placeholder
                            icon: null,
                          ),
                        ]),
                      ),
                      // Name
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Text(
                          service.serviceName, // <--- Nombre dinámico
                          style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Wait time card ──
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderColor, width: 0.5),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Tiempo de espera estimado',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        const Text('15 min', // Placeholder
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Row(children: const [
                          Icon(Icons.group_outlined, size: 14, color: AppTheme.textSecondary),
                          SizedBox(width: 4),
                          Text('3 personas en espera', // Placeholder
                              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                        ]),
                      ]),
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: AppTheme.bgGray, borderRadius: BorderRadius.circular(22)),
                        child: const Icon(Icons.access_time_outlined, size: 22, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Acerca de ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Acerca de',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    const SizedBox(height: 8),
                    const Text(
                      'Información general sobre el servicio prestado en esta sucursal.', // Placeholder
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      icon: Icons.email_outlined, // <--- Cambiado a correo
                      iconColor: AppTheme.accentOrange,
                      title: 'Correo',
                      subtitle: service.email, // <--- Dinámico
                      extra: 'Contacto oficial',
                      extraColor: AppTheme.accentOrange,
                    ),
                    const SizedBox(height: 10),
                    const _InfoCard(
                      icon: Icons.access_time_outlined,
                      iconColor: AppTheme.accentOrange,
                      title: 'Horario',
                      subtitle: 'Lun - Sab: 8:00 AM - 8:00 PM', // Placeholder
                      extra: 'Abierto ahora',
                      extraColor: AppTheme.successGreen,
                      extraDot: true,
                    ),
                    const SizedBox(height: 100), // space for button
                  ]),
                ),
              ),
            ],
          ),

          // ── Bottom button ──
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
              ),
              child: ElevatedButton(
                onPressed: () async {
                  final client = AppControllers.auth.client;

                  if (client == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesión no válida'),
                        backgroundColor: AppTheme.errorRed,
                      ),
                    );
                    return;
                  }

                  final ctrl = AppControllers.client;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  final success = await ctrl.joinQueue(
                    service.serviceId,
                    client.id,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  if (success && context.mounted) {
                    await ctrl.loadInitialData(client.id);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ClientShell(initialIndex: 1),
                      ),
                          (route) => false,
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error al reservar el turno. Inténtalo de nuevo.',
                        ),
                        backgroundColor: AppTheme.errorRed,
                      ),
                    );
                  }
                },
                child: const Text('Reservar Turno'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _Chip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
  );
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String extra;
  final Color extraColor;
  final bool extraDot;

  const _InfoCard({
    required this.icon, required this.iconColor, required this.title,
    required this.subtitle, required this.extra, required this.extraColor,
    this.extraDot = false,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.borderColor, width: 0.5),
    ),
    child: Row(children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: AppTheme.bgGray, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: iconColor),
      ),
      const SizedBox(width: 12),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 2),
        Row(children: [
          if (extraDot) Container(
            width: 8, height: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(color: extraColor, shape: BoxShape.circle),
          ),
          Text(extra, style: TextStyle(fontSize: 12, color: extraColor)),
        ]),
      ]),
    ]),
  );
}