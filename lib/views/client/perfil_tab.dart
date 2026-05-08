import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import 'favoritos_view.dart';
import '../auth/cambiar_contrasena_view.dart';
// Asegúrate de que la ruta coincida con donde guardaste el archivo
import 'editar_perfil_view.dart';

class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});
  @override
  State<PerfilTab> createState() => _S();
}

class _S extends State<PerfilTab> {
  bool _notif = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppControllers.auth,
      builder: (ctx, _) {
        final u = AppControllers.auth.user;

        // Contenedor con el fondo azul clarito para separar los recuadros
        return Container(
          color: const Color(0xFFD6EAF8),
          child: CustomScrollView(
            slivers: [
              // ── Header + Stats Flotante ──
              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Fondo Azul del Header
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.headerTeal.withOpacity(0.9), AppTheme.headerTeal],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                          ),
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20,
                            left: 16,
                            right: 16,
                            bottom: 56,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_outline, size: 40, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                u?.name ?? 'Juan Pérez García',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                u?.email ?? 'usuario@email.com',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        // Espacio transparente que ahora mostrará el color de fondo 0xFFF4F7FA
                        const SizedBox(height: 45),
                      ],
                    ),

                    // Tarjetas de Estadísticas Individuales
                    Positioned(
                      bottom: 0,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Stat(
                              value: u?.totalTurnos ?? 24,
                              label: 'Turnos',
                              icon: Icons.confirmation_number_outlined,
                              color: AppTheme.headerTeal),
                          _Stat(
                              value: u?.activeTurnos ?? 1,
                              label: 'Activo',
                              icon: Icons.circle,
                              color: AppTheme.successGreen),
                          _Stat(
                              value: u?.favorites ?? 5,
                              label: 'Favoritos',
                              icon: Icons.favorite_border,
                              color: AppTheme.headerTeal),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Información Personal ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Información Personal',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),

                      // Botón con fondo sólido que dirige a la nueva pantalla
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditarPerfilView()),
                          );
                        },
                        icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.white),
                        label: const Text('Editar Información', style: TextStyle(fontSize: 12, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.headerTeal,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Nombre completo',
                          value: u?.name ?? 'Juan Pérez García'),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: u?.email ?? 'usuario@email.com'),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Teléfono',
                          value: u?.phone.isNotEmpty == true ? u!.phone : '+1 234 567 8900'),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Ubicación',
                          value: u?.location.isNotEmpty == true ? u!.location : 'Ciudad, País'),
                    ],
                  ),
                ),
              ),

              // ── Preferencias ──
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text('Preferencias',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: AppTheme.headerTeal.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Icon(Icons.notifications_outlined,
                                  size: 18, color: AppTheme.headerTeal),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Notificaciones',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textPrimary)),
                                  SizedBox(height: 2),
                                  Text('Alertas de turnos',
                                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                            Switch(
                                value: _notif,
                                onChanged: (v) => setState(() => _notif = v),
                                activeColor: AppTheme.headerTeal),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _PrefRow(
                        icon: Icons.favorite_border,
                        label: 'Negocios favoritos',
                        subtitle: '${u?.favorites ?? 5} favoritos',
                        onTap: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const FavoritosView())),
                      ),
                      Divider(height: 1, color: AppTheme.borderColor),
                      _PrefRow(
                        icon: Icons.lock_outline,
                        label: 'Cambiar contraseña',
                        subtitle: 'Seguridad de cuenta',
                        onTap: () => Navigator.push(
                            context, MaterialPageRoute(builder: (_) => const CambiarContrasenaView())),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Cerrar Sesión ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 32),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      AppControllers.auth.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: const Icon(Icons.logout, color: AppTheme.errorRed, size: 20),
                    label: const Text('Cerrar Sesión',
                        style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white, // Fondo blanco para que destaque
                      side: const BorderSide(color: AppTheme.errorRed, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
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

// Widget actualizado de las tarjetas individuales
class _Stat extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const _Stat({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary
              ),
            ),
            const SizedBox(height: 2),
            Text(
                label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary
                )
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
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

class _PrefRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;

  const _PrefRow(
      {required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppTheme.headerTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 18, color: AppTheme.headerTeal),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}