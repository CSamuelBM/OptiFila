import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class RegisterClientView extends StatefulWidget {
  const RegisterClientView({super.key});
  @override
  State<RegisterClientView> createState() => _S();
}

class _S extends State<RegisterClientView> {
  final _nombre = TextEditingController();
  final _apPat = TextEditingController();
  final _apMat = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _o1 = true, _o2 = true, _loading = false;

  // ── COLORES EXTRAÍDOS DEL DISEÑO ──
  final Color _darkBlue = const Color(0xFF1A5A88); // Azul oscuro para textos y header
  final Color _lightBlue = const Color(0xFF38A1C5); // Azul claro para botones e iconos

  @override
  void dispose() {
    for (final c in [_nombre, _apPat, _apMat, _email, _pass, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if ([_nombre, _apPat, _apMat, _email, _pass, _confirm]
        .any((c) => c.text.trim().isEmpty)) {
      _snack('Completa todos los campos');
      return;
    }
    if (_pass.text != _confirm.text) {
      _snack('Las contraseñas no coinciden');
      return;
    }
    setState(() => _loading = true);
    final ok = await AppControllers.auth.registerClient(
        name: '${_nombre.text.trim()} ${_apPat.text.trim()} ${_apMat.text.trim()}',
        email: _email.text.trim(),
        password: _pass.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) Navigator.pushReplacementNamed(context, '/client');
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: AppTheme.errorRed));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _darkBlue, // Fondo azul oscuro superior
    body: SafeArea(
      child: Column(
        children: [
          _header(context, 'Registro de Cliente', 'Completa tus datos'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC), // Fondo gris muy claro casi blanco
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _f('Nombre', _nombre, 'Juan'),
                    _f('Apellido Paterno', _apPat, 'Pérez'),
                    _f('Apellido Materno', _apMat, 'García'),
                    _f('Email', _email, 'tu@email.com', type: TextInputType.emailAddress),
                    _pf('Contraseña', _pass, _o1, () => setState(() => _o1 = !_o1)),
                    _pf('Confirmar Contraseña', _confirm, _o2, () => setState(() => _o2 = !_o2)),
                    const SizedBox(height: 16),

                    // ── BOTÓN DE CREAR CUENTA ──
                    SizedBox(
                      width: double.infinity,
                      height: 52, // Altura prominente como en el diseño
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _lightBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                            : const Text(
                          'Crear Cuenta',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _f(String label, TextEditingController c, String hint, {TextInputType type = TextInputType.text}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _darkBlue)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: TextField(
                controller: c,
                keyboardType: type,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _lightBlue, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _pf(String label, TextEditingController c, bool obs, VoidCallback toggle) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _darkBlue)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: TextField(
                controller: c,
                obscureText: obs,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, letterSpacing: 2),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _lightBlue, width: 1.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obs ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 22,
                      color: _lightBlue,
                    ),
                    onPressed: toggle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

// ── ENCABEZADO ──
Widget _header(BuildContext context, String title, String sub) => Padding(
  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text('Volver',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 4),
      Text(sub, style: const TextStyle(fontSize: 14, color: Colors.white70)),
    ],
  ),
);
