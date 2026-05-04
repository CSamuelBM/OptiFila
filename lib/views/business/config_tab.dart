import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class ConfigTab extends StatefulWidget {
  const ConfigTab({super.key});
  @override State<ConfigTab> createState() => _State();
}
class _State extends State<ConfigTab> {
  bool _notifications = true;
  bool _autoAccept    = false;

  @override
  Widget build(BuildContext context) => CustomScrollView(slivers:[
    SliverToBoxAdapter(child:Container(
      color:AppTheme.headerTeal,
      height:MediaQuery.of(context).padding.top+50,
      padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top),
      child:const Center(child:Text('Configuración',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white))),
    )),
    // Business info card
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.all(16),
      padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Row(children:[
        Container(width:48,height:48,decoration:BoxDecoration(color:AppTheme.orangePale,borderRadius:BorderRadius.circular(10)),
          child:const Center(child:Icon(Icons.storefront_outlined,color:AppTheme.accentOrange,size:24))),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Mi Negocio',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
          const Text('Restaurante',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          const SizedBox(height:4),
          const Row(children:[Icon(Icons.location_on_outlined,size:12,color:AppTheme.accentOrange),SizedBox(width:3),
            Text('Calle Principal 123, Ciudad',style:TextStyle(fontSize:11,color:AppTheme.textSecondary))]),
          const Row(children:[Icon(Icons.access_time_outlined,size:12,color:AppTheme.textSecondary),SizedBox(width:3),
            Text('Lun - Vie: 9:00 AM - 6:00 PM',style:TextStyle(fontSize:11,color:AppTheme.textSecondary))]),
        ])),
        const Icon(Icons.chevron_right,color:AppTheme.textLight),
      ]),
    )),
    // Notifications
    SliverToBoxAdapter(child:_sectionLabel('Notificaciones')),
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.symmetric(horizontal:16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
        Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.orangePale,borderRadius:BorderRadius.circular(8)),
          child:const Icon(Icons.notifications_outlined,size:18,color:AppTheme.accentOrange)),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Activar notificaciones',style:TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
          const Text('Recibe alertas de nuevos turnos',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
        ])),
        Switch(value:_notifications,onChanged:(v)=>setState(()=>_notifications=v),activeColor:AppTheme.accentOrange),
      ])),
    )),
    // Turn management
    SliverToBoxAdapter(child:_sectionLabel('Gestión de turnos')),
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.symmetric(horizontal:16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Column(children:[
        _ConfigRow(icon:Icons.timer_outlined,  label:'Tiempo de atención',   subtitle:'Promedio: 8 minutos',onTap:(){},hasChevron:true),
        Divider(height:1,color:AppTheme.borderColor),
        Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
          Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
            child:const Icon(Icons.settings_outlined,size:18,color:AppTheme.textSecondary)),
          const SizedBox(width:12),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Text('Auto-aceptar turnos',style:TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
            const Text('Acepta automáticamente',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          ])),
          Switch(value:_autoAccept,onChanged:(v)=>setState(()=>_autoAccept=v),activeColor:AppTheme.accentOrange),
        ])),
        Divider(height:1,color:AppTheme.borderColor),
        _ConfigRow(icon:Icons.person_outline, label:'Capacidad máxima',      subtitle:'50 turnos por día',onTap:(){},hasChevron:true),
      ]),
    )),
    // Account
    SliverToBoxAdapter(child:_sectionLabel('Cuenta')),
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.symmetric(horizontal:16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Column(children:[
        _ConfigRow(icon:Icons.person_outline,  label:'Editar perfil',        subtitle:'',onTap:(){},hasChevron:true),
        Divider(height:1,color:AppTheme.borderColor),
        _ConfigRow(icon:Icons.lock_outline,    label:'Cambiar contraseña',   subtitle:'',onTap:(){},hasChevron:true),
      ]),
    )),
    // Logout
    SliverToBoxAdapter(child:Padding(
      padding:const EdgeInsets.all(16),
      child:OutlinedButton.icon(
        onPressed:(){ AppControllers.auth.logout(); Navigator.pushReplacementNamed(context,'/login'); },
        icon:const Icon(Icons.logout,color:AppTheme.errorRed,size:18),
        label:const Text('Cerrar Sesión',style:TextStyle(color:AppTheme.errorRed,fontWeight:FontWeight.w500)),
        style:OutlinedButton.styleFrom(
          side:const BorderSide(color:AppTheme.errorRed,width:1.2),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
          padding:const EdgeInsets.symmetric(vertical:14),
        ),
      ),
    )),
    const SliverToBoxAdapter(child:SizedBox(height:24)),
  ]);

  Widget _sectionLabel(String t) => Padding(
    padding:const EdgeInsets.fromLTRB(16,16,16,8),
    child:Text(t,style:const TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)));
}

class _ConfigRow extends StatelessWidget {
  final IconData icon; final String label; final String subtitle; final VoidCallback onTap; final bool hasChevron;
  const _ConfigRow({required this.icon,required this.label,required this.subtitle,required this.onTap,required this.hasChevron});
  @override Widget build(BuildContext context) => InkWell(
    onTap:onTap,
    child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
      Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
        child:Icon(icon,size:18,color:AppTheme.textSecondary)),
      const SizedBox(width:12),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(label,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
        if(subtitle.isNotEmpty) Text(subtitle,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
      ])),
      if(hasChevron) const Icon(Icons.chevron_right,color:AppTheme.textLight,size:20),
    ])),
  );
}