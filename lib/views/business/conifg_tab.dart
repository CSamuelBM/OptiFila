import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import 'editar_perfil_negocio_view.dart';
import 'tiempo_atencion_view.dart';
import 'capacidad_maxima_view.dart';
import '../auth/cambiar_contrasena_view.dart';

class ConfigTab extends StatefulWidget {
  const ConfigTab({super.key});
  @override State<ConfigTab> createState() => _S();
}
class _S extends State<ConfigTab> {
  bool _notif=true, _auto=false;

  @override
  Widget build(BuildContext context) => CustomScrollView(slivers:[
    SliverToBoxAdapter(child:Container(
      color:AppTheme.headerColor,
      padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+12,left:16,right:16,bottom:20),
      child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('Configuración',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
        Text('Ajustes de tu negocio',style:TextStyle(fontSize:13,color:Colors.white70)),
      ]),
    )),
    // Business card
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.all(16),
      padding:const EdgeInsets.all(16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Row(children:[
        Container(width:48,height:48,decoration:BoxDecoration(color:AppTheme.bgLight,borderRadius:BorderRadius.circular(10)),
            child:const Center(child:Icon(Icons.storefront_outlined,color:AppTheme.accentBlue,size:24))),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Mi Negocio',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
          const Text('Restaurante',style:TextStyle(fontSize:12,color:AppTheme.accentBlue)),
          const SizedBox(height:4),
          const Row(children:[Icon(Icons.location_on_outlined,size:12,color:AppTheme.accentBlue),SizedBox(width:3),
            Expanded(child:Text('Calle Principal 123, Ciudad',style:TextStyle(fontSize:11,color:AppTheme.textSecondary),overflow:TextOverflow.ellipsis))]),
          const Row(children:[Icon(Icons.access_time_outlined,size:12,color:AppTheme.textSecondary),SizedBox(width:3),
            Expanded(child:Text('Lun - Vie: 9:00 AM - 6:00 PM',style:TextStyle(fontSize:11,color:AppTheme.textSecondary),overflow:TextOverflow.ellipsis))]),
        ])),
        const Icon(Icons.chevron_right,color:AppTheme.textLight),
      ]),
    )),
    _sec('Notificaciones'),
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.symmetric(horizontal:16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
        Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgLight,borderRadius:BorderRadius.circular(8)),
            child:const Icon(Icons.notifications_outlined,size:18,color:AppTheme.accentBlue)),
        const SizedBox(width:12),
        const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('Activar notificaciones',style:TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
          Text('Recibe alertas de nuevos turnos',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
        ])),
        Switch(value:_notif,onChanged:(v)=>setState(()=>_notif=v),activeColor:AppTheme.accentBlue),
      ])),
    )),
    _sec('Gestión de turnos'),
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.symmetric(horizontal:16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Column(children:[
        _NavRow(icon:Icons.timer_outlined,label:'Tiempo de atención',subtitle:'Promedio: 8 minutos',
            onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const TiempoAtencionView()))),
        Divider(height:1,color:AppTheme.borderColor),
        Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
          Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
              child:const Icon(Icons.settings_outlined,size:18,color:AppTheme.textSecondary)),
          const SizedBox(width:12),
          const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('Auto-aceptar turnos',style:TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
            Text('Acepta automáticamente',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          ])),
          Switch(value:_auto,onChanged:(v)=>setState(()=>_auto=v),activeColor:AppTheme.accentBlue),
        ])),
        Divider(height:1,color:AppTheme.borderColor),
        _NavRow(icon:Icons.person_outline,label:'Capacidad máxima',subtitle:'50 turnos por día',
            onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CapacidadMaximaView()))),
      ]),
    )),
    _sec('Cuenta'),
    SliverToBoxAdapter(child:Container(
      margin:const EdgeInsets.symmetric(horizontal:16),
      decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
      child:Column(children:[
        _NavRow(icon:Icons.person_outline,label:'Editar perfil',subtitle:'',
            onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const EditarPerfilNegocioView()))),
        Divider(height:1,color:AppTheme.borderColor),
        _NavRow(icon:Icons.lock_outline,label:'Cambiar contraseña',subtitle:'',
            onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CambiarContrasenaView()))),
      ]),
    )),
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(16),
        child:OutlinedButton.icon(
          onPressed:(){ AppControllers.auth.logout(); Navigator.pushReplacementNamed(context,'/login'); },
          icon:const Icon(Icons.logout,color:AppTheme.errorRed,size:18),
          label:const Text('Cerrar Sesión',style:TextStyle(color:AppTheme.errorRed,fontWeight:FontWeight.w500)),
          style:OutlinedButton.styleFrom(
              side:const BorderSide(color:AppTheme.errorRed,width:1.2),
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
              padding:const EdgeInsets.symmetric(vertical:14)),
        ))),
    const SliverToBoxAdapter(child:SizedBox(height:24)),
  ]);

  SliverToBoxAdapter _sec(String t)=>SliverToBoxAdapter(child:Padding(
      padding:const EdgeInsets.fromLTRB(16,16,16,8),
      child:Text(t,style:const TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary))));
}

class _NavRow extends StatelessWidget {
  final IconData icon; final String label,subtitle; final VoidCallback onTap;
  const _NavRow({required this.icon,required this.label,required this.subtitle,required this.onTap});
  @override Widget build(BuildContext context)=>InkWell(onTap:onTap,
      child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
        Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
            child:Icon(icon,size:18,color:AppTheme.textSecondary)),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(label,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
          if(subtitle.isNotEmpty) Text(subtitle,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
        ])),
        const Icon(Icons.chevron_right,color:AppTheme.textLight,size:20),
      ])));
}