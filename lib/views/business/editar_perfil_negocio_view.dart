import 'package:flutter/material.dart';
import '../../app_theme.dart';

class EditarPerfilNegocioView extends StatefulWidget {
  const EditarPerfilNegocioView({super.key});
  @override State<EditarPerfilNegocioView> createState() => _S();
}
class _S extends State<EditarPerfilNegocioView> {
  final _bName  = TextEditingController(text:'Mi Negocio');
  final _dir    = TextEditingController(text:'Calle Principal 123, Ciudad');
  final _hora   = TextEditingController(text:'Lun - Vie: 9:00 AM - 6:00 PM');
  final _tel    = TextEditingController(text:'+1 234 567 890');
  final _email  = TextEditingController(text:'negocio@email.com');
  final _desc   = TextEditingController(text:'Descripción de tu negocio');
  String _cat   = 'Restaurante';
  bool _loading = false;
  static const _cats = ['Restaurante','Belleza','Banco','Médico','Retail','Gimnasio','Otro'];

  @override void dispose(){for(final c in [_bName,_dir,_hora,_tel,_email,_desc]) c.dispose();super.dispose();}

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgGray,
    body: SafeArea(child: Column(children:[
      Container(
        color:AppTheme.headerColor,
        padding:const EdgeInsets.fromLTRB(16,12,16,24),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          GestureDetector(onTap:()=>Navigator.pop(context),
            child:const Row(mainAxisSize:MainAxisSize.min,children:[
              Icon(Icons.arrow_back_ios,size:16,color:Colors.white),Text('Volver',style:TextStyle(color:Colors.white,fontSize:14))])),
          const SizedBox(height:16),
          Row(children:[
            Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(10)),
              child:const Icon(Icons.storefront_outlined,color:Colors.white,size:22)),
            const SizedBox(width:14),
            const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Editar Perfil',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
              Text('Actualiza la información de tu negocio',style:TextStyle(fontSize:12,color:Colors.white70)),
            ])),
          ]),
        ]),
      ),
      Expanded(child:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        _if('Nombre del Negocio',_bName,Icons.storefront_outlined),
        const Text('Categoría',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
        const SizedBox(height:6),
        Container(
          width:double.infinity,padding:const EdgeInsets.symmetric(horizontal:14),
          decoration:BoxDecoration(color:const Color(0xFFF3F7FB),borderRadius:BorderRadius.circular(12)),
          child:DropdownButtonHideUnderline(child:DropdownButton<String>(
            value:_cat,
            items:_cats.map((c)=>DropdownMenuItem(value:c,child:Text(c))).toList(),
            onChanged:(v)=>setState(()=>_cat=v!)))),
        const SizedBox(height:14),
        _if('Dirección',           _dir, Icons.location_on_outlined),
        _if('Horario de Atención', _hora,Icons.access_time_outlined),
        _if('Teléfono',            _tel, Icons.phone_outlined,type:TextInputType.phone),
        _if('Email',               _email,Icons.email_outlined,type:TextInputType.emailAddress),
        const Text('Descripción',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
        const SizedBox(height:6),
        TextField(controller:_desc,maxLines:3,decoration:const InputDecoration(hintText:'Descripción de tu negocio')),
        const SizedBox(height:24),
        SizedBox(width:double.infinity,child:ElevatedButton(
          onPressed:_loading?null:_save,
          child:_loading?const SizedBox(width:20,height:20,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2))
            :const Text('Guardar Cambios'))),
        const SizedBox(height:16),
      ]))),
    ])),
  );

  Widget _if(String label,TextEditingController c,IconData icon,{TextInputType type=TextInputType.text})=>
    Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
      const SizedBox(height:6),
      TextField(controller:c,keyboardType:type,decoration:InputDecoration(prefixIcon:Icon(icon,size:18,color:AppTheme.textSecondary))),
      const SizedBox(height:14)]);

  Future<void> _save() async {
    setState(()=>_loading=true);
    await Future.delayed(const Duration(milliseconds:700));
    if (!mounted) return;
    setState(()=>_loading=false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Perfil actualizado'),backgroundColor:AppTheme.successGreen));
    Navigator.pop(context);
  }
}