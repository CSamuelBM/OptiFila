import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../core/di/injection_dart.dart';
import '../../models/category_model.dart';
import '../../repositories/category_repository.dart';

class RegisterBusinessView extends StatefulWidget {
  const RegisterBusinessView({super.key});

  @override
  State<RegisterBusinessView> createState() => _RegisterBusinessViewState();
}

class _RegisterBusinessViewState extends State<RegisterBusinessView> {
  // Controladores
  final _bName = TextEditingController(); // serviceName
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  // Estado
  bool _o1 = true, _o2 = true, _loading = false;

  // Gestión de categorías dinámicas para obtener el ID
  final _categoryRepo = getIt<CategoryRepository>();
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    for (final c in [_bName, _email, _pass, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await _categoryRepo.getCategories();
      setState(() => _categories = data);
    } catch (e) {
      debugPrint('Error cargando categorías: $e');
    }
  }

  // ── LÓGICA DE REGISTRO ──
  Future<void> _submit() async {
    if ([_bName, _email, _pass, _confirm].any((c) => c.text.trim().isEmpty) || _selectedCategory == null) {
      _snack('Completa todos los campos');
      return;
    }

    if (_pass.text != _confirm.text) {
      _snack('Las contraseñas no coinciden');
      return;
    }

    setState(() => _loading = true);

    // Llamada al método registerService del AuthController
    final ok = await AppControllers.auth.registerService(
      serviceName: _bName.text.trim(),
      email: _email.text.trim(),
      password: _pass.text,
      categoryId: _selectedCategory!.id, // Enviamos el ID real
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, '/business');
    } else {
      _snack(AppControllers.auth.error ?? 'Error al registrar el negocio');
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(m), backgroundColor: AppTheme.errorRed));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B649E),
      body: SafeArea(
          child: Column(
            children: [
              _header(context),
              Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFF4F7F9),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24))
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _f('Nombre del negocio', _bName, 'Ej. Restaurante Central'),

                            Text('Categoría', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue.shade800)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<CategoryModel>(
                              value: _selectedCategory,
                              hint: Text('Selecciona una categoría', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
                              items: _categories.map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.name)
                              )).toList(),
                              onChanged: (v) => setState(() => _selectedCategory = v),
                              decoration: _inputDeco(''),
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 16),

                            _f('Email de contacto', _email, 'negocio@email.com', type: TextInputType.emailAddress),
                            _pf('Contraseña', _pass, _o1, () => setState(() => _o1 = !_o1)),
                            _pf('Confirmar Contraseña', _confirm, _o2, () => setState(() => _o2 = !_o2)),

                            const SizedBox(height: 24),

                            SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF389ED0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0,
                                    ),
                                    onPressed: _loading ? null : _submit,
                                    child: _loading
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                        : const Text('Registrar Negocio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                                )
                            ),
                          ]
                      ),
                    ),
                  )
              ),
            ],
          )
      ),
    );
  }

  Widget _header(BuildContext context) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                        Text('Volver', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ]
                  )
              ),
            ),
            const SizedBox(height: 20),
            const Text('Registro de Negocio', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text('Publica tus servicios hoy', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ]
      )
  );

  InputDecoration _inputDeco(String hint) => InputDecoration(
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
      borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
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