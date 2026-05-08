import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class EditarPerfilView extends StatefulWidget {
  const EditarPerfilView({super.key});

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  // Controladores para capturar el texto de los campos
  final _nameCtrl = TextEditingController();
  final _paternoCtrl = TextEditingController();
  final _maternoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargamos los datos actuales del usuario al iniciar
    final u = AppControllers.auth.user;
    if (u != null) {
      _nameCtrl.text = u.name.split(' ').first; // Ejemplo: toma el primer nombre
      _emailCtrl.text = u.email;
      _phoneCtrl.text = u.phone;
      _locationCtrl.text = u.location;
      // Los apellidos podrías separarlos si tu modelo lo permite
      _paternoCtrl.text = "Pérez";
      _maternoCtrl.text = "García";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA), // Fondo gris azulado claro
      body: Column(
        children: [
          // ── Header Azul ──
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
              top: MediaQuery.of(context).padding.top + 12,
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
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text('Volver', style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Editar Perfil',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Actualiza tu información personal',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Formulario ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Nombre"),
                  _buildTextField(_nameCtrl, Icons.person_outline, "Juan"),

                  _buildLabel("Apellido Paterno"),
                  _buildTextField(_paternoCtrl, Icons.person_outline, "Pérez"),

                  _buildLabel("Apellido Materno"),
                  _buildTextField(_maternoCtrl, Icons.person_outline, "García"),

                  _buildLabel("Email"),
                  _buildTextField(_emailCtrl, Icons.email_outlined, "usuario@email.com"),

                  _buildLabel("Teléfono"),
                  _buildTextField(_phoneCtrl, Icons.phone_outlined, "+1 234 567 8900"),

                  _buildLabel("Ubicación"),
                  _buildTextField(_locationCtrl, Icons.location_on_outlined, "Ciudad, País"),

                  const SizedBox(height: 24),

                  // Botón Guardar
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí iría la lógica para guardar los cambios
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

  // Widget auxiliar para las etiquetas (Labels)
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B3A50), // Un azul oscuro para los labels
        ),
      ),
    );
  }

  // Widget auxiliar para los Campos de Texto
  Widget _buildTextField(TextEditingController controller, IconData icon, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.blue.shade300, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.headerTeal, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}