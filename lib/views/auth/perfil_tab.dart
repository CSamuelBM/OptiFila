import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../client/favoritos_view.dart';
import 'cambiar_contrasena_view.dart';

class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});
  @override State<PerfilTab> createState() => _S();
}
class _S extends State<PerfilTab> {
  bool _notif = true;

  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable:AppControllers.auth, builder:(ctx,_){
    final u = AppControllers.auth.user;
    return CustomScrollView(slivers:[
      SliverToBoxAdapter(child:Container(
        color:AppTheme.headerColor,
        padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+12,left:16,right:16,bottom:24),
        child:Column(children:[
          Container(width:72,height:72,decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(36)),
            child:const Icon(Icons.person_outline,size:36,color:Colors.white)),
          const SizedBox(height:10),
          Text(u?.name??'Usuario',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
          Text(u?.email??'',style:const TextStyle(fontSize:13,color:Colors.white70)),
        ]),
      )),
      // Stats
      SliverToBoxAdapter(child:Container(
        margin:const EdgeInsets.fromLTRB(16,16,16,0),
        decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
        child:Row(children:[
          _Stat(value:u?.totalTurnos??0,  label:'Turnos',   icon:Icons.confirmation_number_outlined,color:AppTheme.accentBlue),
          Container(width:1,height:60,color:AppTheme.borderColor),
          _Stat(value:u?.activeTurnos??0, label:'Activo',   icon:Icons.circle,                     color:AppTheme.successGreen),
          Container(width:1,height:60,color:AppTheme.borderColor),
          _Stat(value:u?.favorites??0,    label:'Favoritos', icon:Icons.favorite_border,            color:AppTheme.textSecondary),
        ]),
      )),
      // Info personal
      SliverToBoxAdapter(child:Padding(
        padding:const EdgeInsets.fromLTRB(16,16,16,8),
        child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
          const Text('Información Personal',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
          OutlinedButton.icon(
            onPressed:(){},
            icon:const Icon(Icons.edit_outlined,size:14),
            label:const Text('Editar Información',style:TextStyle(fontSize:12)),
            style:OutlinedButton.styleFrom(
              foregroundColor:AppTheme.accentBlue,
              side:const BorderSide(color:AppTheme.accentBlue),
              padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8))),
          ),
        ]),
      )),
      SliverToBoxAdapter(child:Container(
        margin:const EdgeInsets.symmetric(horizontal:16),
        decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
        child:Column(children:[
          _InfoRow(icon:Icons.person_outline,      label:'Nombre completo', value:u?.name??'Juan Pérez García'),
          Divider(height:1,color:AppTheme.borderColor),
          _InfoRow(icon:Icons.email_outlined,      label:'Email',           value:u?.email??'usuario@email.com'),
          Divider(height:1,color:AppTheme.borderColor),
          _InfoRow(icon:Icons.phone_outlined,      label:'Teléfono',        value:u?.phone.isNotEmpty==true?u!.phone:'+1 234 567 8900'),
          Divider(height:1,color:AppTheme.borderColor),
          _InfoRow(icon:Icons.location_on_outlined,label:'Ubicación',       value:u?.location.isNotEmpty==true?u!.location:'Ciudad, País'),
        ]),
      )),
      // Preferencias
      const SliverToBoxAdapter(child:Padding(
        padding:EdgeInsets.fromLTRB(16,16,16,8),
        child:Text('Preferencias',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
      )),
      SliverToBoxAdapter(child:Container(
        margin:const EdgeInsets.symmetric(horizontal:16),
        decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
        child:Column(children:[
          Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),child:Row(children:[
            Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgLight,borderRadius:BorderRadius.circular(8)),
              child:const Icon(Icons.notifications_outlined,size:18,color:AppTheme.accentBlue)),
            const SizedBox(width:12),
            const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Notificaciones',style:TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
              Text('Alertas de turnos',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
            ])),
            Switch(value:_notif,onChanged:(v)=>setState(()=>_notif=v),activeColor:AppTheme.accentBlue),
          ])),
          Divider(height:1,color:AppTheme.borderColor),
          _PrefRow(icon:Icons.favorite_border,label:'Negocios favoritos',subtitle:'\${u?.favorites??5} favoritos',
            onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const FavoritosView()))),
          Divider(height:1,color:AppTheme.borderColor),
          _PrefRow(icon:Icons.lock_outline,label:'Cambiar contraseña',subtitle:'Seguridad de cuenta',
            onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CambiarContrasenaView()))),
        ]),
      )),
      SliverToBoxAdapter(child:Padding(
        padding:const EdgeInsets.all(16),
        child:OutlinedButton.icon(
          onPressed:(){ AppControllers.auth.logout(); Navigator.pushReplacementNamed(context,'/login'); },
          icon:const Icon(Icons.logout,color:AppTheme.errorRed,size:18),
          label:const Text('Cerrar Sesión',style:TextStyle(color:AppTheme.errorRed,fontWeight:FontWeight.w500)),
          style:OutlinedButton.styleFrom(
            side:const BorderSide(color:AppTheme.errorRed,width:1.2),
            shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
            padding:const EdgeInsets.symmetric(vertical:14)),
        ),
      )),
      const SliverToBoxAdapter(child:SizedBox(height:16)),
    ]);
  });
}

extension on Object? {
  String? get name => null;

  int? get totalTurnos => null;

  String? get email => null;

  get phone => null;

  get location => null;

  int? get activeTurnos => null;

  int? get favorites => null;
}

class _Stat extends StatelessWidget {
  final int value; final String label; final IconData icon; final Color color;
  const _Stat({required this.value,required this.label,required this.icon,required this.color});
  @override Widget build(BuildContext context)=>Expanded(child:Padding(
    padding:const EdgeInsets.symmetric(vertical:16),
    child:Column(children:[
      Icon(icon,size:18,color:color),const SizedBox(height:4),
      Text('\$value',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
      Text(label,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
    ])));
}
class _InfoRow extends StatelessWidget {
  final IconData icon; final String label, value;
  const _InfoRow({required this.icon,required this.label,required this.value});
  @override Widget build(BuildContext context)=>Padding(
    padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),
    child:Row(children:[
      Icon(icon,size:18,color:AppTheme.textSecondary),const SizedBox(width:14),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(label,style:const TextStyle(fontSize:11,color:AppTheme.textLight)),
        const SizedBox(height:2),
        Text(value,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary),overflow:TextOverflow.ellipsis),
      ])),
    ]));
}
class _PrefRow extends StatelessWidget {
  final IconData icon; final String label,subtitle; final VoidCallback onTap;
  const _PrefRow({required this.icon,required this.label,required this.subtitle,required this.onTap});
  @override Widget build(BuildContext context)=>InkWell(onTap:onTap,
    child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),child:Row(children:[
      Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
        child:Icon(icon,size:18,color:AppTheme.textSecondary)),
      const SizedBox(width:12),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(label,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
        Text(subtitle,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
      ])),
      const Icon(Icons.chevron_right,color:AppTheme.textLight,size:20),
    ])));
}