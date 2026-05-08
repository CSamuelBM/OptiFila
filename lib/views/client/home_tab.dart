import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/business_model.dart';
import '../business/business_detail_view.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _State();
}

class _State extends State<HomeTab> {
  static const _categories = ['Todos', 'Restaurantes', 'Belleza', 'Bancos'];

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;
    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final businesses = ctrl.filteredBusinesses;

        // ── Se añadió el Container con el color de fondo solicitado ──
        return Container(
          color: const Color(0xFFD6EAF8),
          child: Column(
            children: [
              // ── Stack para superponer los botones al Header ──
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Fondo: Header Azul + Espacio transparente inferior
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.headerTeal.withOpacity(0.9), AppTheme.headerTeal],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          // Esquinas redondeadas en la parte inferior
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                        ),
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 16,
                          left: 16,
                          right: 16,
                          bottom: 32, // Espacio suficiente debajo del buscador
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Text('Hola, Usuario',
                                              style: TextStyle(
                                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                          SizedBox(width: 6),
                                          Text('👋', style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      const Text('¿A dónde quieres ir hoy?',
                                          style: TextStyle(color: Colors.white70, fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: ctrl.setSearch,
                              decoration: InputDecoration(
                                hintText: 'Buscar negocios...',
                                prefixIcon: const Icon(Icons.search, color: AppTheme.textLight),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Espacio transparente que equivale a la mitad de la altura de los botones
                      const SizedBox(height: 20),
                    ],
                  ),

                  // Frente: Filtros flotantes (mitad azul, mitad blanco)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 40, // Altura total de los botones
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final sel = ctrl.selectedCategory == _categories[i];

                          // Color azul más claro para el estado seleccionado
                          const Color activeColor = Color(0xFF2A8CBA);

                          return GestureDetector(
                            onTap: () => ctrl.setCategory(_categories[i]),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: sel ? activeColor : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                // Sombra sutil para destacar el efecto de "flotado"
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: sel ? activeColor : Colors.grey.shade200,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _categories[i],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: sel ? Colors.white : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // ── List ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Negocios cerca de ti',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        Icon(Icons.location_on_outlined, size: 20, color: AppTheme.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...businesses.map((b) => GestureDetector(
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => BusinessDetailView(business: b))),
                      child: _BusinessCard(business: b),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BusinessCard extends StatelessWidget {
  final BusinessModel business;
  const _BusinessCard({required this.business});

  Color get _catColor {
    switch (business.category) {
      case 'Restaurante':
        return Colors.teal.shade400;
      case 'Belleza':
        return Colors.blue.shade400;
      case 'Banco':
        return Colors.cyan.shade600;
      default:
        return Colors.indigo.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _catColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: _catColor, shape: BoxShape.circle),
                  ),
                ),
              ),
              if (business.isOpen)
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(business.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Color(0xFFFFB400)),
                        const SizedBox(width: 4),
                        Text(business.rating.toString(),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(business.category,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(business.address,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.group_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${business.queueCount} en fila',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.headerTeal.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '~${business.waitMinutes} min',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.headerTeal),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}