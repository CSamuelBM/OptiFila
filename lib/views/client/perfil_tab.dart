import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../widgets/common_widgets.dart';

class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});
  @override State<PerfilTab> createState() => _State();
}
class _State extends State<PerfilTab> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final user = AppControllers.auth.user;
    return ListenableBuilder(listenable:AppControllers.auth, builder:(ctx,_){
      final u = AppControllers.auth.user;
      return CustomScrollView(slivers:[
        SliverToBoxAdapter(child:Container(
          color:AppTheme.headerTeal,
          padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+16,left:16,right:16,bottom:24),
          child:Column(children:[
            Container(width:72,height:72,decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(36)),
              child:const Icon(Icons.person_outline,size:36,color:Colors.white)),
            const SizedBox(height:10),
            Text(u?.name??'Usuario',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
            Text(u?.email??'',style:const TextStyle(fontSize:13,color:Colors.white70)),
          ]),
        )),
        SliverToBoxAdapter(child:Container(
          margin:const EdgeInsets.fromLTRB(16,16,16,0),
          decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
          child:Row(children:[
            _StatTile(value:u?.totalTurnos??0,  label:'Turnos',     icon:Icons.confirmation_number_outlined, color:AppTheme.accentOrange),
            _divider(),
            _StatTile(value:u?.activeTurnos??0, label:'Activo',     icon:Icons.circle,                      color:AppTheme.successGreen),
            _divider(),
            _StatTile(value:u?.favorites??0,    label:'Favoritos',  icon:Icons.favorite_border,             color:AppTheme.textSecondary),
          ]),
        )),
        SliverToBoxAdapter(child:sectionLabel('Información Personal')),
        SliverToBoxAdapter(child:Container(
          margin:const EdgeInsets.symmetric(horizontal:16),
          decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
          child:Column(children:[
            InfoRow(icon:Icons.person_outline,   label:'Nombre',    value:u?.name??'',     onEdit:(){}),
            Divider(height:1,color:AppTheme.borderColor),
            InfoRow(icon:Icons.email_outlined,   label:'Email',     value:u?.email??'',    onEdit:(){}),
            Divider(height:1,color:AppTheme.borderColor),
            InfoRow(icon:Icons.phone_outlined,   label:'Teléfono',  value:u?.phone.isNotEmpty==true?u!.phone:'+1 234 567 8900', onEdit:(){}),
            Divider(height:1,color:AppTheme.borderColor),
            InfoRow(icon:Icons.location_on_outlined,label:'Ubicación',value:u?.location.isNotEmpty==true?u!.location:'Ciudad, País', onEdit:(){}),
          ]),
        )),
        SliverToBoxAdapter(child:sectionLabel('Preferencias')),
        SliverToBoxAdapter(child:Container(
          margin:const EdgeInsets.symmetric(horizontal:16),
          decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
          child:Column(children:[
            Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
              Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.orangePale,borderRadius:BorderRadius.circular(8)),
                child:const Icon(Icons.notifications_outlined,size:18,color:AppTheme.accentOrange)),
              const SizedBox(width:12),
              Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                const Text('Notificaciones',style:TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
                const Text('Alertas de turnos',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
              ])),
              Switch(value:_notifications,onChanged:(v)=>setState(()=>_notifications=v),activeColor:AppTheme.accentOrange),
            ])),
            Divider(height:1,color:AppTheme.borderColor),
            _PrefRow(icon:Icons.favorite_border,  label:'Negocios favoritos',  subtitle:'5 favoritos',          onTap:(){}),
            Divider(height:1,color:AppTheme.borderColor),
            _PrefRow(icon:Icons.lock_outline,      label:'Cambiar contraseña',  subtitle:'Seguridad de cuenta',  onTap:(){}),
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
              padding:const EdgeInsets.symmetric(vertical:14),
            ),
          ),
        )),
        const SliverToBoxAdapter(child:SizedBox(height:16)),
      ]);
    });
  }

  Widget _divider() => Container(width:1,height:60,color:AppTheme.borderColor);
}

class _StatTile extends StatelessWidget {
  final int value; final String label; final IconData icon; final Color color;
  const _StatTile({required this.value,required this.label,required this.icon,required this.color});
  @override Widget build(BuildContext context) => Expanded(child:Padding(
    padding:const EdgeInsets.symmetric(vertical:16),
    child:Column(children:[
      Icon(icon,size:18,color:color),
      const SizedBox(height:4),
      Text('\$value',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
      Text(label,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
    ]),
  ));
}

class _PrefRow extends StatelessWidget {
  final IconData icon; final String label; final String subtitle; final VoidCallback onTap;
  const _PrefRow({required this.icon,required this.label,required this.subtitle,required this.onTap});
  @override Widget build(BuildContext context) => InkWell(
    onTap:onTap,
    child:Padding(padding:const EdgeInsets.symmetric(horizontal:16,vertical:14),child:Row(children:[
      Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
        child:Icon(icon,size:18,color:AppTheme.textSecondary)),
      const SizedBox(width:12),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(label,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
        Text(subtitle,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
      ])),
      const Icon(Icons.chevron_right,color:AppTheme.textLight,size:20),
    ])),
  );
}