import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/category_model.dart';
import '../../repositories/category_repository.dart';
import '../widgets/common_widgets.dart';

class RegisterBusinessView extends StatefulWidget {
  const RegisterBusinessView({super.key});
  @override
  State<RegisterBusinessView> createState() => _S();
}

class _S extends State<RegisterBusinessView> {
  final _nombre = TextEditingController();
  final _apPat = TextEditingController();
  final _apMat = TextEditingController();
  final _bName = TextEditingController();
  final _ubicacion = TextEditingController();
  final _horario = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  String? _cat;
  bool _o1 = true, _o2 = true, _loading = false;

  static const _cats = ['Restaurante', 'Belleza', 'Banco', 'Médico', 'Retail', 'Gimnasio', 'Otro'];

  @override
  void dispose() {
    for (final c in [_nombre, _apPat, _apMat, _bName, _ubicacion, _horario, _email, _pass, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if ([_nombre, _apPat, _apMat, _bName, _ubicacion, _email, _pass, _confirm].any((c) => c.text.trim().isEmpty) || _cat == null) {
      _snack('Completa todos los campos');
      return;
    }
    if (_pass.text != _confirm.text) {
      _snack('Las contraseñas no coinciden');
      return;
    }
    setState(() => _loading = true);
    final ok = await AppControllers.auth.registerBusiness(
        name: '${_nombre.text.trim()} ${_apPat.text.trim()} ${_apMat.text.trim()}',
        email: _email.text.trim(),
        password: _pass.text,
        businessName: _bName.text.trim(),
        category: _cat!
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) Navigator.pushReplacementNamed(context, '/business');
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: AppTheme.errorRed));

  // ── ESTILO UNIFICADO PARA LOS INPUTS ──
  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      filled: true,
      fillColor: Colors.white, // Fondo blanco para los campos
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _category.getCategories();
      setState(() => _categories = data);
    } catch (e) {
      // mostrar error
    }
  }


  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF1B649E), // Azul del encabezado
    body: SafeArea(
        child: Column(
          children: [
            // ── ENCABEZADO ──
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_back, size: 20, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Volver', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))
                              ]
                          )
                      ),
                      const SizedBox(height: 20),
                      const Center(child: Text('Registro de Negocio', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white))),
                      const SizedBox(height: 4),
                      const Center(child: Text('Completa tus datos', style: TextStyle(fontSize: 14, color: Colors.white70))),
                    ]
                )
            ),

            // ── FORMULARIO ──
            Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFF4F7F9), // Fondo gris-azulado muy claro
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _f('Nombre', _nombre, 'Juan'),
                          _f('Apellido Paterno', _apPat, 'Pérez'),
                          _f('Apellido Materno', _apMat, 'García'),
                          _f('Nombre del negocio', _bName, 'Mi Negocio'),
                          _f('Ubicación', _ubicacion, 'Av. Principal 123, Ciudad'),
                          _f('Horario', _horario, 'Lun-Vie 9:00-18:00'),

                          // Dropdown Categoría
                          Text('Categoría', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue.shade800)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _cat,
                            hint: Text('Selecciona una categoría', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                            items: _cats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (v) => setState(() => _cat = v),
                            decoration: _inputDeco(''),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),

                          _f('Email', _email, 'tu@email.com', type: TextInputType.emailAddress),
                          _pf('Contraseña', _pass, _o1, () => setState(() => _o1 = !_o1)),
                          _pf('Confirmar Contraseña', _confirm, _o2, () => setState(() => _o2 = !_o2)),

                          const SizedBox(height: 16),

                          // Botón Crear Cuenta
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF389ED0), // Color cyan/azul del botón
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  onPressed: _loading ? null : _submit,
                                  child: _loading
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text('Crear Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                              )
                          ),
                          const SizedBox(height: 24),
                        ]
                    ),
                  ),
                )
            ),
          ],
        )
    ),
  );

  Widget _f(String label, TextEditingController c, String hint, {TextInputType type = TextInputType.text}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue.shade800)),
        const SizedBox(height: 8),
        TextField(controller: c, keyboardType: type, decoration: _inputDeco(hint)),
        const SizedBox(height: 16)
      ]);

  Widget _pf(String label, TextEditingController c, bool obs, VoidCallback toggle) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue.shade800)),
        const SizedBox(height: 8),
        TextField(
            controller: c,
            obscureText: obs,
            decoration: _inputDeco('••••••••').copyWith(
                suffixIcon: IconButton(
                    icon: Icon(obs ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.blue.shade400),
                    onPressed: toggle
                )
            )
        ),
        const SizedBox(height: 16)
      ]);
}