import 'package:flutter/material.dart';
import '../../app_theme.dart';

class FavoritosView extends StatefulWidget {
  const FavoritosView({super.key});
  @override
  State<FavoritosView> createState() => _FavoritosViewState();
}

class _Fav {
  final String name, category, address;
  final double distKm, rating;
  final int waitMin;
  _Fav(this.name, this.category, this.address, this.distKm, this.rating, this.waitMin);
}

class _FavoritosViewState extends State<FavoritosView> {
  final _favs = [
    _Fav('Cafetería Central', 'Restaurante', 'Av. Principal 123', 0.5, 4.8, 10),
    _Fav('Salón Belleza Total', 'Salón de belleza', 'Calle Bella 456', 1.2, 4.9, 25),
    _Fav('Clínica Salud', 'Médico', 'Calle Médica 101', 2.1, 4.7, 30),
    _Fav('Restaurante El Buen Sabor', 'Restaurante', 'Plaza Central 55', 1.5, 4.6, 20),
    _Fav('Gimnasio FitLife', 'Gimnasio', 'Av. Deportiva 88', 0.9, 4.8, 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Fondo gris azulado claro
      backgroundColor: const Color(0xFFF4F7FA),
      body: Column(
        children: [
          // ── HEADER ──
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // Usamos el color de tu header original
              color: AppTheme.headerColor,
            ),
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
                    // 4. Ícono del corazón en círculo perfecto
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Favoritos',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        // Corrección de la interpolación de texto
                        Text(
                          '${_favs.length} negocios guardados',
                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── LISTA DE FAVORITOS ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favs.length,
              itemBuilder: (ctx, i) {
                final f = _favs[i];
                return Container(
                  // Separación entre tarjetas aumentada
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    // 2. Sombra en las tarjetas
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  // Usamos ClipRRect para que el borde izquierdo redondeado se pinte correctamente
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: AppTheme.headerColor, width: 4),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  f.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.headerColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // 3. Botón de Eliminar ('X') con fondo circular rojo clarito
                              GestureDetector(
                                onTap: () => setState(() => _favs.removeAt(i)),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorRed.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppTheme.errorRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Badge de la categoría
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5AB6B2), // Color teal clarito para destacar la categoría
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              f.category,
                              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.black87),
                              const SizedBox(width: 4),
                              Text('${f.distKm} km', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              const SizedBox(width: 16),
                              const Icon(Icons.access_time_outlined, size: 16, color: Colors.black87),
                              const SizedBox(width: 4),
                              Text('${f.waitMin} min', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              const SizedBox(width: 16),
                              const Icon(Icons.star, size: 16, color: Color(0xFFFFB400)),
                              const SizedBox(width: 4),
                              Text('${f.rating}', style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  f.address,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}