import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class EditarPerfilView extends StatefulWidget {
  const EditarPerfilView({super.key});

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  // Controladores generales
  final _emailCtrl = TextEditingController();

  // Controladores específicos para Cliente
  final _nameCtrl = TextEditingController();
  final _paternoCtrl = TextEditingController();
  final _maternoCtrl = TextEditingController();

  // Controlador específico para Servicio/Negocio
  final _serviceNameCtrl = TextEditingController();

  bool _isService = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final auth = AppControllers.auth;
    _isService = auth.isService;

    if (_isService) {
      // Caso: Usuario es un Negocio (UserModel)
      final s = auth.service;
      if (s != null) {
        _serviceNameCtrl.text = s.serviceName;
        _emailCtrl.text = s.email;
      }
    } else {
      // Caso: Usuario es un Cliente (ClientModel)
      final c = auth.client;
      if (c != null) {
        _nameCtrl.text = c.firstName;
        _paternoCtrl.text = c.lastName;
        _maternoCtrl.text = c.secondLastName;
        _emailCtrl.text = c.email;
      }
    }
  }

  @override
  void dispose() {
    // Es vital hacer dispose para evitar fugas de memoria
    _nameCtrl.dispose();
    _paternoCtrl.dispose();
    _maternoCtrl.dispose();
    _emailCtrl.dispose();
    _serviceNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: Column(
        children: [
          // ── Header Azul ──
          _buildHeader(context),

          // ── Formulario ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isService) ...[
                    // Campos para Negocio
                    _buildLabel("Nombre del Servicio/Negocio"),
                    _buildTextField(_serviceNameCtrl, Icons.storefront, "Ej. Restaurante Central"),
                  ] else ...[
                    // Campos para Cliente
                    _buildLabel("Nombre"),
                    _buildTextField(_nameCtrl, Icons.person_outline, "Nombre"),
                    _buildLabel("Apellido Paterno"),
                    _buildTextField(_paternoCtrl, Icons.person_outline, "Apellido"),
                    _buildLabel("Apellido Materno"),
                    _buildTextField(_maternoCtrl, Icons.person_outline, "Apellido"),
                  ],

                  _buildLabel("Email (Informativo)"),
                  _buildTextField(_emailCtrl, Icons.email_outlined, "email@ejemplo.com", enabled: false),

                  const SizedBox(height: 32),

                  // Botón Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí llamarías a la lógica de actualización del Repositorio
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.headerTeal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Guardar Cambios',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.headerTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16, right: 16, bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 20),
                SizedBox(width: 6),
                Text('Volver', style: TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Editar Perfil',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Mantén tus datos actualizados',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1B3A50)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool enabled = true}) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(fontSize: 15, color: enabled ? AppTheme.textPrimary : Colors.grey),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.headerTeal.withOpacity(0.5), size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}