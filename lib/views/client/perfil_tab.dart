import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../widgets/common_widgets.dart'; // Ajusta esta ruta a donde guardaste PrimaryButton, whiteCard, etc.
import 'favoritos_view.dart';
import '../auth/cambiar_contrasena_view.dart';
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
        final auth = AppControllers.auth;
        final isService = auth.isService;

        final String displayName = isService
            ? (auth.service?.serviceName ?? 'Negocio')
            : '${auth.client?.firstName ?? 'Usuario'} ${auth.client?.lastName ?? ''}';

        final String displayEmail = isService
            ? (auth.service?.email ?? '')
            : (auth.client?.email ?? '');

        return Container(
          color: const Color(0xFFD6EAF8),
          child: CustomScrollView(
            slivers: [
              // ── Header + Stats ──
              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
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
                            left: 16, right: 16, bottom: 56,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                    isService ? Icons.storefront : Icons.person_outline,
                                    size: 40, color: Colors.white
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(displayName,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text(displayEmail,
                                  style: const TextStyle(fontSize: 14, color: Colors.white70)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 45),
                      ],
                    ),
                    Positioned(
                      bottom: 0, left: 16, right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _Stat(value: 0, label: 'Turnos', icon: Icons.confirmation_number_outlined, color: AppTheme.headerTeal),
                          _Stat(value: 0, label: 'Activo', icon: Icons.circle, color: AppTheme.successGreen),
                          _Stat(value: 0, label: 'Favoritos', icon: Icons.favorite_border, color: AppTheme.headerTeal),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Información Personal ──
              SliverToBoxAdapter(child: sectionLabel('Información Personal')),
              SliverToBoxAdapter(
                child: whiteCard(
                  child: Column(
                    children: [
                      _InfoRow(
                          icon: isService ? Icons.business : Icons.person_outline,
                          label: isService ? 'Nombre del Negocio' : 'Nombre completo',
                          value: displayName),
                      const Divider(height: 1),
                      _InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: displayEmail),
                      if (!isService) ...[
                        const Divider(height: 1),
                        const _InfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Teléfono',
                            value: 'No especificado'),
                      ],
                      // Botón de edición al final de la lista de info
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarPerfilView())),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text("Editar Información"),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // ── Preferencias ──
              SliverToBoxAdapter(child: sectionLabel('Preferencias')),
              SliverToBoxAdapter(
                child: whiteCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _notif,
                        onChanged: (v) => setState(() => _notif = v),
                        title: const Text('Notificaciones', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        subtitle: const Text('Alertas de turnos', style: TextStyle(fontSize: 12)),
                        secondary: Icon(Icons.notifications_outlined, color: AppTheme.headerTeal),
                        activeColor: AppTheme.headerTeal,
                      ),
                      const Divider(height: 1),
                      _PrefRow(
                        icon: Icons.favorite_border,
                        label: 'Favoritos',
                        subtitle: 'Ver mis negocios guardados',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritosView())),
                      ),
                      const Divider(height: 1),
                      _PrefRow(
                        icon: Icons.lock_outline,
                        label: 'Cambiar contraseña',
                        subtitle: 'Seguridad de cuenta',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CambiarContrasenaView())),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Cerrar Sesión ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      auth.logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    icon: const Icon(Icons.logout, color: AppTheme.errorRed),
                    label: const Text('Cerrar Sesión', style: TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppTheme.errorRed),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

// ── WIDGETS AUXILIARES INTERNOS ──

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
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
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
    // Implementación interna basada en tu InfoRow global
    return InfoRow(icon: icon, label: label, value: value);
  }
}

class _PrefRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;
  const _PrefRow({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.headerTeal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: AppTheme.headerTeal),
      ),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textLight),
    );
  }
}