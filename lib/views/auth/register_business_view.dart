import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class RegisterBusinessView extends StatefulWidget {
  const RegisterBusinessView({super.key});
  @override State<RegisterBusinessView> createState() => _S();
}
class _S extends State<RegisterBusinessView> {
  final _nombre    = TextEditingController();
  final _apPat     = TextEditingController();
  final _apMat     = TextEditingController();
  final _bName     = TextEditingController();
  final _ubicacion = TextEditingController();
  final _horario   = TextEditingController();
  final _email     = TextEditingController();
  final _pass      = TextEditingController();
  final _confirm   = TextEditingController();
  String? _cat;
  bool _o1=true, _o2=true, _loading=false;
  static const _cats = ['Restaurante','Belleza','Banco','Médico','Retail','Gimnasio','Otro'];

  @override void dispose() {
    for (final c in [_nombre,_apPat,_apMat,_bName,_ubicacion,_horario,_email,_pass,_confirm]) c.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if ([_nombre,_apPat,_apMat,_bName,_ubicacion,_email,_pass,_confirm].any((c)=>c.text.trim().isEmpty)||_cat==null) {
      _snack('Completa todos los campos'); return;
    }
    if (_pass.text != _confirm.text) { _snack('Las contraseñas no coinciden'); return; }
    setState(()=>_loading=true);
    final ok = await AppControllers.auth.registerBusiness(
      name:'\${_nombre.text.trim()} \${_apPat.text.trim()} \${_apMat.text.trim()}',
      email:_email.text.trim(),password:_pass.text,businessName:_bName.text.trim(),category:_cat!);
    if (!mounted) return;
    setState(()=>_loading=false);
    if (ok != null) Navigator.pushReplacementNamed(context, '/business');
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content:Text(m),backgroundColor:AppTheme.errorRed));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.headerColor,
    body: SafeArea(child: Column(children: [
      Padding(padding:const EdgeInsets.fromLTRB(16,12,16,20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        GestureDetector(onTap:()=>Navigator.pop(context),
          child:const Row(mainAxisSize:MainAxisSize.min,children:[
            Icon(Icons.arrow_back_ios,size:16,color:Colors.white),Text('Volver',style:TextStyle(color:Colors.white,fontSize:14))])),
        const SizedBox(height:16),
        const Center(child:Text('Registro de Negocio',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Colors.white))),
        const Center(child:Text('Completa tus datos',style:TextStyle(fontSize:13,color:Colors.white70))),
      ])),
      Expanded(child:Container(
        decoration:const BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
        child:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const SizedBox(height:4),
          _f('Nombre',            _nombre,    'Juan'),
          _f('Apellido Paterno',  _apPat,     'Pérez'),
          _f('Apellido Materno',  _apMat,     'García'),
          _f('Nombre del negocio',_bName,     'Mi Negocio'),
          _f('Ubicación',         _ubicacion, 'Av. Principal 123, Ciudad'),
          _f('Horario',           _horario,   'Lun-Vie 9:00-18:00'),
          const Text('Categoría',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
          const SizedBox(height:6),
          Container(
            width:double.infinity,
            padding:const EdgeInsets.symmetric(horizontal:14),
            decoration:BoxDecoration(color:const Color(0xFFF3F7FB),borderRadius:BorderRadius.circular(12)),
            child:DropdownButtonHideUnderline(child:DropdownButton<String>(
              value:_cat,
              hint:const Text('Selecciona una categoría',style:TextStyle(color:Color(0xFFBDC3CB),fontSize:14)),
              items:_cats.map((c)=>DropdownMenuItem(value:c,child:Text(c))).toList(),
              onChanged:(v)=>setState(()=>_cat=v),
            )),
          ),
          const SizedBox(height:14),
          _f('Email',_email,'tu@email.com',type:TextInputType.emailAddress),
          _pf('Contraseña',          _pass,   _o1,()=>setState(()=>_o1=!_o1)),
          _pf('Confirmar Contraseña',_confirm,_o2,()=>setState(()=>_o2=!_o2)),
          const SizedBox(height:24),
          SizedBox(width:double.infinity,child:ElevatedButton(
            onPressed:_loading?null:_submit,
            child:_loading?const SizedBox(width:20,height:20,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2))
              :const Text('Crear Cuenta'))),
          const SizedBox(height:16),
        ])),
      )),
    ])),
  );

  Widget _f(String label,TextEditingController c,String hint,{TextInputType type=TextInputType.text})=>
    Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
      const SizedBox(height:6),TextField(controller:c,keyboardType:type,decoration:InputDecoration(hintText:hint)),const SizedBox(height:14)]);

  Widget _pf(String label,TextEditingController c,bool obs,VoidCallback toggle)=>
    Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
      const SizedBox(height:6),
      TextField(controller:c,obscureText:obs,decoration:InputDecoration(hintText:'••••••••',
        suffixIcon:IconButton(icon:Icon(obs?Icons.visibility_off_outlined:Icons.visibility_outlined,size:20,color:AppTheme.textLight),onPressed:toggle))),
      const SizedBox(height:14)]);
}