import 'package:flutter/material.dart';
import '../../app_theme.dart';

class ColaEsperaView extends StatefulWidget {
  const ColaEsperaView({super.key});

  @override
  State<ColaEsperaView> createState() => _ColaEsperaViewState();
}

class _ColaEsperaViewState extends State<ColaEsperaView> {
  // Estado para el filtro seleccionado
  String _filtroActivo = 'Todos';

  // Datos simulados (Mocks) basados en tu diseño
  final List<Map<String, dynamic>> _turnos = [
    {
      'numero': 38,
      'nombre': 'Carlos Martínez',
      'hora': '2:05 PM',
      'estado': 'Atendiendo',
      'tiempoEstimado': '5 min',
      'isAtendiendo': true,
    },
    {
      'numero': 39,
      'nombre': 'María González',
      'hora': '2:10 PM',
      'estado': 'Esperando',
      'tiempoEstimado': '10 min',
      'isAtendiendo': false,
    },
    {
      'numero': 40,
      'nombre': 'Juan Pérez',
      'hora': '2:15 PM',
      'estado': 'Esperando',
      'tiempoEstimado': '15 min',
      'isAtendiendo': false,
    },
    {
      'numero': 41,
      'nombre': 'Ana Torres',
      'hora': '2:20 PM',
      'estado': 'Esperando',
      'tiempoEstimado': '20 min',
      'isAtendiendo': false,
    },
    {
      'numero': 42,
      'nombre': 'Luis Rodríguez',
      'hora': '2:25 PM',
      'estado': 'Esperando',
      'tiempoEstimado': '25 min',
      'isAtendiendo': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ── AQUÍ ESTÁ LA MAGIA DEL FILTRO ──
    // Filtramos la lista original basándonos en el filtro activo.
    final turnosFiltrados = _filtroActivo == 'Todos'
        ? _turnos
        : _turnos.where((t) => t['estado'] == _filtroActivo).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD6EAF8), // Fondo azul claro general
      body: Column(
        children: [
          // ── ENCABEZADO ──
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.headerTeal.withOpacity(0.9), AppTheme.headerTeal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón Volver
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Volver', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cola de Espera',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gestión completa de turnos',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 24),

                // Tarjetas de Resumen
                Row(
                  children: [
                    Expanded(child: _SummaryCard(icon: Icons.access_time, label: 'Esperando', count: '7', iconColor: Colors.blue)),
                    const SizedBox(width: 8),
                    Expanded(child: _SummaryCard(icon: Icons.people_outline, label: 'Atendiendo', count: '1', iconColor: AppTheme.headerTeal)),
                    const SizedBox(width: 8),
                    Expanded(child: _SummaryCard(icon: Icons.check_circle_outline, label: 'Completados', count: '0', iconColor: Colors.grey.shade600)),
                  ],
                )
              ],
            ),
          ),

          // ── FILTROS (CHIPS) ──
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip(label: 'Todos (11)', isSelected: _filtroActivo == 'Todos', onTap: () => setState(() => _filtroActivo = 'Todos')),
                  _FilterChip(label: 'Esperando (7)', isSelected: _filtroActivo == 'Esperando', onTap: () => setState(() => _filtroActivo = 'Esperando')),
                  _FilterChip(label: 'Atendiendo (1)', isSelected: _filtroActivo == 'Atendiendo', onTap: () => setState(() => _filtroActivo = 'Atendiendo')),
                  _FilterChip(label: 'Completados ', isSelected: _filtroActivo == 'Completados', onTap: () => setState(() => _filtroActivo = 'Completados')),
                ],
              ),
            ),
          ),

          // ── LISTA DE TURNOS ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0, bottom: 24),
              // Usamos la lista ya filtrada
              itemCount: turnosFiltrados.length,
              itemBuilder: (context, index) {
                final turno = turnosFiltrados[index];
                return _TurnoCard(turno: turno);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── WIDGETS AUXILIARES ──

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color iconColor;

  const _SummaryCard({required this.icon, required this.label, required this.count, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.blue.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _TurnoCard extends StatelessWidget {
  final Map<String, dynamic> turno;

  const _TurnoCard({required this.turno});

  @override
  Widget build(BuildContext context) {
    final bool isAtendiendo = turno['isAtendiendo'];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.blue.shade600, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Fila Superior: Número, Nombre/Hora, Estado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.bgGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${turno['numero']}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.headerTeal),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            turno['nombre'],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time_outlined, size: 14, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                turno['hora'],
                                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: isAtendiendo ? Colors.blue.shade50 : AppTheme.bgGray,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isAtendiendo ? Colors.blue.shade200 : Colors.transparent)
                      ),
                      child: Text(
                        turno['estado'],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isAtendiendo ? Colors.blue.shade700 : AppTheme.textSecondary
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Fila Inferior: Tiempo estimado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tiempo estimado',
                      style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Text(
                        turno['tiempoEstimado'],
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}