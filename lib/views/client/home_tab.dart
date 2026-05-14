import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/category_model.dart';
import '../../models/client_model.dart';
import '../../models/service/service_model.dart';
import '../business/business_detail_view.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();

    // ── INICIALIZACIÓN SEGURA (FORZA LA RECARGA SIEMPRE) ──
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = AppControllers.client;
      final clientId = AppControllers.auth.client?.id;

      // Al quitar la condición (ctrl.categories.isEmpty), nos aseguramos
      // de que siempre pida los datos más recientes para el cliente actual.
      ctrl.loadInitialData(clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;
    final ClientModel? client = AppControllers.auth.client;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (ctx, _) {
        final List<ServiceModel> services = ctrl.filteredServices;

        // Agregamos null para representar "Todos"
        final List<CategoryModel?> displayCategories = [null, ...ctrl.categories];

        return Container(
          color: const Color(0xFFD6EAF8),
          child: Column(
            children: [
              // ── Stack Header ──
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
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
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                        ),
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 16,
                          left: 16, right: 16, bottom: 32,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('¡Hola, ${client?.firstName ?? 'Usuario'}!',
                                              style: const TextStyle(
                                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                                          const SizedBox(width: 6),
                                          const Text('👋', style: TextStyle(fontSize: 20)),
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
                                hintText: 'Buscar servicios...',
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
                      const SizedBox(height: 20),
                    ],
                  ),

                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: displayCategories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final category = displayCategories[i];
                          final isTodos = category == null;

                          final isSelected = isTodos
                              ? ctrl.selectedCategory == null
                              : ctrl.selectedCategory?.id == category.id;

                          const Color activeColor = Color(0xFF2A8CBA);

                          return GestureDetector(
                            onTap: () => ctrl.setCategory(category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? activeColor : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8, offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: isSelected ? activeColor : Colors.grey.shade200,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  isTodos ? 'Todos' : category.displayName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : AppTheme.textSecondary,
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

              // ── Lista de Servicios ──
              Expanded(
                child: ctrl.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Servicios cerca de ti',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        Icon(Icons.location_on_outlined, size: 20, color: AppTheme.textSecondary),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...services.map((s) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => BusinessDetailView(service: s))
                        );
                      },
                      child: _ServiceCard(service: s),
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

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  const _ServiceCard({required this.service});

  Color get _catColor {
    switch (service.category.name.toLowerCase()) {
      case 'restaurantes':
      case 'restaurant':
        return Colors.teal.shade400;
      case 'belleza':
        return Colors.blue.shade400;
      case 'bancos':
      case 'banco':
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
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: _catColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(color: _catColor, shape: BoxShape.circle),
                  ),
                ),
              ),
              Positioned(
                top: 0, right: 0,
                child: Container(
                  width: 12, height: 12,
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
                    Expanded(
                      child: Text(service.serviceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: const [
                        Icon(Icons.star, size: 16, color: Color(0xFFFFB400)),
                        SizedBox(width: 4),
                        Text('4.5', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(service.category.displayName, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(service.email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.group_outlined, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('? en fila', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.headerTeal.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('~-- min',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.headerTeal),
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