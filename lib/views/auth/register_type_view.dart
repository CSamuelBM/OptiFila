import 'package:flutter/material.dart';
import '../../app_theme.dart';

class RegisterTypeView extends StatelessWidget {
  const RegisterTypeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.headerColor,
    body: SafeArea(child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Image.asset('assets/img/logo.png', height: 60, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.calendar_month_rounded, size: 60, color: AppTheme.accentBlue)),
          ),
          const SizedBox(height: 20),
          const Text('Crear Cuenta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
      ),
      Expanded(child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(children: [
          _TypeCard(icon: Icons.person_outline_rounded, title: 'Soy Cliente',
            subtitle: 'Reserva turnos y evita las filas en tus negocios favoritos',
            onTap: () => Navigator.pushNamed(context, '/register-client')),
          const SizedBox(height: 14),
          _TypeCard(icon: Icons.storefront_outlined, title: 'Soy Negocio',
            subtitle: 'Gestiona turnos, reduce filas y mejora la experiencia de tus clientes',
            onTap: () => Navigator.pushNamed(context, '/register-business')),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('¿Ya tienes cuenta? ', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            GestureDetector(
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Inicia sesión', style: TextStyle(color: AppTheme.accentBlue, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ]),
        ]),
      )),
    ])),
  );
}

class _TypeCard extends StatelessWidget {
  final IconData icon; final String title, subtitle; final VoidCallback onTap;
  const _TypeCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.accentBlue, width: 1.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppTheme.bgLight, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 22, color: AppTheme.accentBlue)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4)),
        ])),
      ]),
    ),
  );
}