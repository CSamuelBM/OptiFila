import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

// ── IMPORTACIONES DE TUS PANTALLAS ──
import 'tiempo_atencion_view.dart';
import 'capacidad_maxima_view.dart';
import 'editar_perfil_negocio_view.dart';
import '../auth/cambiar_contrasena_View.dart';

class ConfigTab extends StatefulWidget {
  const ConfigTab({super.key});
  @override
  State<ConfigTab> createState() => _State();
}

class _State extends State<ConfigTab> {
  bool _notifications = true;
  bool _autoAccept    = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD6EAF8), // Fondo azul claro
      child: CustomScrollView(
        slivers: [
          // ── ENCABEZADO (Igualado al diseño de Inicio/Clientes) ──
          SliverToBoxAdapter(
            child: Container(
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
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 24, // Mismo padding inferior que inicio_tab
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Configuración',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Ajustes de cuenta y negocio',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── TARJETA DEL NEGOCIO ──
          SliverToBoxAdapter(
            child: _ConfigCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.orangePale,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(Icons.storefront_outlined, color: AppTheme.accentOrange, size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Mi Negocio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                          const Text('Restaurante', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.location_on_outlined, size: 12, color: AppTheme.accentOrange),
                              SizedBox(width: 3),
                              Text('Calle Principal 123, Ciudad', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(Icons.access_time_outlined, size: 12, color: AppTheme.textSecondary),
                              SizedBox(width: 3),
                              Text('Lun - Vie: 9:00 AM - 6:00 PM', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textLight),
                  ],
                ),
              ),
            ),
          ),

          // ── NOTIFICACIONES ──
          SliverToBoxAdapter(child: _sectionLabel('Notificaciones')),
          SliverToBoxAdapter(
            child: _ConfigCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppTheme.orangePale, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.notifications_outlined, size: 18, color: AppTheme.accentOrange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Activar notificaciones', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                          Text('Recibe alertas de nuevos turnos', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notifications,
                      onChanged: (v) => setState(() => _notifications = v),
                      activeColor: AppTheme.accentOrange,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── GESTIÓN DE TURNOS ──
          SliverToBoxAdapter(child: _sectionLabel('Gestión de turnos')),
          SliverToBoxAdapter(
            child: _ConfigCard(
              child: Column(
                children: [
                  _ConfigRow(
                      icon: Icons.timer_outlined,
                      label: 'Tiempo de atención',
                      subtitle: 'Promedio: 8 minutos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TiempoAtencionView()),
                        );
                      },
                      hasChevron: true
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppTheme.bgGray, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.settings_outlined, size: 18, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Auto-aceptar turnos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                              Text('Acepta automáticamente', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _autoAccept,
                          onChanged: (v) => setState(() => _autoAccept = v),
                          activeColor: AppTheme.accentOrange,
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  _ConfigRow(
                      icon: Icons.person_outline,
                      label: 'Capacidad máxima',
                      subtitle: '50 turnos por día',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CapacidadMaximaView()),
                        );
                      },
                      hasChevron: true
                  ),
                ],
              ),
            ),
          ),

          // ── CUENTA ──
          SliverToBoxAdapter(child: _sectionLabel('Cuenta')),
          SliverToBoxAdapter(
            child: _ConfigCard(
              child: Column(
                children: [
                  _ConfigRow(
                      icon: Icons.person_outline,
                      label: 'Editar perfil',
                      subtitle: '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditarPerfilNegocioView()),
                        );
                      },
                      hasChevron: true
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  _ConfigRow(
                      icon: Icons.lock_outline,
                      label: 'Cambiar contraseña',
                      subtitle: '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CambiarContrasenaView()),
                        );
                      },
                      hasChevron: true
                  ),
                ],
              ),
            ),
          ),

          // ── CERRAR SESIÓN ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () {
                  AppControllers.auth.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout, color: AppTheme.errorRed, size: 18),
                label: const Text('Cerrar Sesión', style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.errorRed, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // Igualamos el tamaño de fuente al de otras pantallas (16px)
  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
    child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.headerTeal)),
  );
}

// ── WIDGETS AUXILIARES ──

class _ConfigCard extends StatelessWidget {
  final Widget child;
  const _ConfigCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                color: AppTheme.headerTeal,
                width: 4,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool hasChevron;

  const _ConfigRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.hasChevron
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.bgGray, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 18, color: AppTheme.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
                  if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            if (hasChevron) const Icon(Icons.chevron_right, color: AppTheme.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}