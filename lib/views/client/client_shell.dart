import 'package:flutter/material.dart';

import '../../app_theme.dart';

import 'home_tab.dart';
import 'mis_turnos_tab.dart';
import 'perfil_tab.dart';

class ClientShell extends StatefulWidget {
  final int initialIndex;

  const ClientShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<ClientShell> createState() => _State();
}

class _State extends State<ClientShell> {
  late int _idx;

  static const _tabs = [
    HomeTab(),
    MyTicketsTab(),
    PerfilTab(),
  ];

  @override
  void initState() {
    super.initState();
    _idx = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgGray,
    body: IndexedStack(
      index: _idx,
      children: _tabs,
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _idx,
      onTap: (i) => setState(() => _idx = i),
      selectedItemColor: AppTheme.accentOrange,
      unselectedItemColor: AppTheme.textSecondary,
      backgroundColor: Colors.white,
      elevation: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          label: 'Explorar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number_outlined),
          label: 'Mis Turnos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    ),
  );
}