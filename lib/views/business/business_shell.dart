import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'inicio_tab.dart';
import 'clientes_tab.dart';
import 'config_tab.dart';

class BusinessShell extends StatefulWidget {
  const BusinessShell({super.key});
  @override State<BusinessShell> createState() => _State();
}
class _State extends State<BusinessShell> {
  int _idx = 0;
  static const _tabs = [InicioTab(), ClientesTab(), ConfigTab()];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor:AppTheme.bgGray,
    body:IndexedStack(index:_idx,children:_tabs),
    bottomNavigationBar:BottomNavigationBar(
      currentIndex:_idx,
      onTap:(i)=>setState(()=>_idx=i),
      selectedItemColor:AppTheme.accentOrange,
      unselectedItemColor:AppTheme.textSecondary,
      backgroundColor:Colors.white,
      elevation:12,
      items:const [
        BottomNavigationBarItem(icon:Icon(Icons.bar_chart_rounded),      label:'Inicio'),
        BottomNavigationBarItem(icon:Icon(Icons.group_outlined),          label:'Clientes'),
        BottomNavigationBarItem(icon:Icon(Icons.settings_outlined),       label:'Config'),
      ],
    ),
  );
}