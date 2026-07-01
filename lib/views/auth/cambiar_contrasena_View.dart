import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CambiarContrasenaView extends StatefulWidget {
  const CambiarContrasenaView({super.key});
  @override
  State<CambiarContrasenaView> createState() => _CambiarContrasenaViewState();
}

class _CambiarContrasenaViewState extends State<CambiarContrasenaView> {
  final _actual = TextEditingController();
  final _nueva = TextEditingController();
  final _confirm = TextEditingController();
  bool _o1 = true, _o2 = true, _o3 = true, _loading = false;

  @override
  void dispose() {
    _actual.dispose();
    _nueva.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_actual.text.isEmpty || _nueva.text.isEmpty || _confirm.text.isEmpty) {
      _snack('Completa todos los campos');
      return;
    }
    if (_nueva.text != _confirm.text) {
      _snack('Las contraseñas no coinciden');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada'), backgroundColor: AppTheme.successGreen));
    Navigator.pop(context);
  }

  void _snack(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m), backgroundColor: AppTheme.errorRed));

  @override
  Widget build(BuildContext context) => Scaffold(
    // Fondo gris muy clarito para que los textfields blancos resalten
    backgroundColor: const Color(0xFFF4F7FA),
    body: Column(
      children: [
        // ── HEADER ──
        Container(
          width: double.infinity,
          color: AppTheme.headerColor,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Volver', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Ícono circular
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_outline, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cambiar Contraseña',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Actualiza tu contraseña de acceso',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── FORMULARIO ──
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _pf('Contraseña Actual', _actual, _o1, () => setState(() => _o1 = !_o1), 'Ingresa tu contraseña actual'),
                const SizedBox(height: 4),
                _pf('Nueva Contraseña', _nueva, _o2, () => setState(() => _o2 = !_o2), 'Ingresa tu nueva contraseña'),
                const SizedBox(height: 4),
                _pf('Confirmar Nueva Contraseña', _confirm, _o3, () => setState(() => _o3 = !_o3), 'Confirma tu nueva contraseña'),
                const SizedBox(height: 8),

                // Recuadro de requisitos azul claro
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'La contraseña debe contener:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF427A9B)),
                      ),
                      SizedBox(height: 10),
                      _Req('Al menos 8 caracteres'),
                      _Req('Una letra mayúscula'),
                      _Req('Una letra minúscula'),
                      _Req('Un número'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Botón con sombra
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentBlue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue, // Color teal/azul claro del botón
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text(
                      'Actualizar Contraseña',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  // Generador de TextFields estilizados
  Widget _pf(String label, TextEditingController c, bool obs, VoidCallback toggle, String hint) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.headerColor),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: c,
            obscureText: obs,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accentBlue, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obs ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 22,
                  color: AppTheme.accentBlue,
                ),
                onPressed: toggle,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
}

// Viñetas personalizadas para los requisitos
class _Req extends StatelessWidget {
  final String text;
  const _Req(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        const Text(
          '• ',
          style: TextStyle(color: Color(0xFF639CBA), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Color(0xFF639CBA)),
        ),
      ],
    ),
  );
}