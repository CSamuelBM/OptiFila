import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class RegisterClientView extends StatefulWidget {
  const RegisterClientView({super.key});
  @override
  State<RegisterClientView> createState() => _RegisterClientViewState();
}

class _RegisterClientViewState extends State<RegisterClientView> {
  final _nombre = TextEditingController();
  final _apPat = TextEditingController();
  final _apMat = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _o1 = true, _o2 = true, _loading = false;

  // Colores consistentes con tu AuthController y diseño
  final Color _darkBlue = const Color(0xFF1A5A88);
  final Color _lightBlue = const Color(0xFF38A1C5);

  @override
  void dispose() {
    for (final c in [_nombre, _apPat, _apMat, _email, _pass, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    // 1. Validación de campos vacíos
    if ([_nombre, _apPat, _apMat, _email, _pass, _confirm].any((c) => c.text.trim().isEmpty)) {
      _snack('Completa todos los campos');
      return;
    }

    // 2. Validación de coincidencia de contraseña
    if (_pass.text != _confirm.text) {
      _snack('Las contraseñas no coinciden');
      return;
    }

    setState(() => _loading = true);

    // 3. Llamada al AuthController (usando los nombres de parámetros correctos)
    final ok = await AppControllers.auth.registerClient(
      firstName: _nombre.text.trim(),
      lastName: _apPat.text.trim(),
      secondLastName: _apMat.text.trim(),
      email: _email.text.trim(),
      password: _pass.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, '/client');
    } else {
      // Si el controlador tiene un error guardado, lo mostramos
      _snack(AppControllers.auth.error ?? 'Error al registrar cliente');
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: AppTheme.errorRed));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _darkBlue,
    body: SafeArea(
      child: Column(
        children: [
          _header(context, 'Registro de Cliente', 'Completa tus datos'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
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

                    SizedBox(
                      width: double.infinity,
                      height: 52,
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
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text(
                          'Crear Cuenta',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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

  // Widget para campos de texto
  Widget _f(String label, TextEditingController c, String hint, {TextInputType type = TextInputType.text}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _darkBlue)),
            const SizedBox(height: 8),
            TextField(
              controller: c,
              keyboardType: type,
              decoration: _inputStyle(hint),
            ),
          ],
        ),
      );

  // Widget para campos de contraseña
  Widget _pf(String label, TextEditingController c, bool obs, VoidCallback toggle) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _darkBlue)),
            const SizedBox(height: 8),
            TextField(
              controller: c,
              obscureText: obs,
              decoration: _inputStyle('••••••••').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(obs ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 22, color: _lightBlue),
                  onPressed: toggle,
                ),
              ),
            ),
          ],
        ),
      );

  InputDecoration _inputStyle(String hint) => InputDecoration(
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
  );

  Widget _header(BuildContext context, String title, String sub) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    child: Column(
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
                Text('Volver', style: TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(sub, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      ],
    ),
  );
}