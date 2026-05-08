import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CambiarContrasenaView extends StatefulWidget {
  const CambiarContrasenaView({super.key});
  @override State<CambiarContrasenaView> createState() => _S();
}
class _S extends State<CambiarContrasenaView> {
  final _actual  = TextEditingController();
  final _nueva   = TextEditingController();
  final _confirm = TextEditingController();
  bool _o1=true,_o2=true,_o3=true,_loading=false;

  @override void dispose() {_actual.dispose();_nueva.dispose();_confirm.dispose();super.dispose();}

  Future<void> _submit() async {
    if (_actual.text.isEmpty||_nueva.text.isEmpty||_confirm.text.isEmpty){_snack('Completa todos los campos');return;}
    if (_nueva.text!=_confirm.text){_snack('Las contraseñas no coinciden');return;}
    setState(()=>_loading=true);
    await Future.delayed(const Duration(milliseconds:700));
    if (!mounted) return;
    setState(()=>_loading=false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Contraseña actualizada'),backgroundColor:AppTheme.successGreen));
    Navigator.pop(context);
  }

  void _snack(String m)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(m),backgroundColor:AppTheme.errorRed));

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgGray,
    body: SafeArea(child: Column(children: [
      Container(
        color: AppTheme.headerColor,
        padding: const EdgeInsets.fromLTRB(16,16,16,24),
        child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          GestureDetector(onTap:()=>Navigator.pop(context),
            child:const Row(mainAxisSize:MainAxisSize.min,children:[
              Icon(Icons.arrow_back_ios,size:16,color:Colors.white),Text('Volver',style:TextStyle(color:Colors.white,fontSize:14))])),
          const SizedBox(height:16),
          Row(children:[
            Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(10)),
              child:const Icon(Icons.lock_outline,color:Colors.white,size:22)),
            const SizedBox(width:14),
            const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Cambiar Contraseña',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
              Text('Actualiza tu contraseña de acceso',style:TextStyle(fontSize:12,color:Colors.white70)),
            ])),
          ]),
        ]),
      ),
      Expanded(child:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        _pf('Contraseña Actual',          _actual, _o1,()=>setState(()=>_o1=!_o1),'Ingresa tu contraseña actual'),
        _pf('Nueva Contraseña',           _nueva,  _o2,()=>setState(()=>_o2=!_o2),'Ingresa tu nueva contraseña'),
        _pf('Confirmar Nueva Contraseña', _confirm,_o3,()=>setState(()=>_o3=!_o3),'Confirma tu nueva contraseña'),
        const SizedBox(height:4),
        Container(
          width:double.infinity,
          padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(color:AppTheme.bgLight,borderRadius:BorderRadius.circular(12)),
          child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('La contraseña debe contener:',style:TextStyle(fontSize:13,fontWeight:FontWeight.w500,color:AppTheme.textPrimary)),
            SizedBox(height:8),
            _Req('Al menos 8 caracteres'),
            _Req('Una letra mayúscula'),
            _Req('Una letra minúscula'),
            _Req('Un número'),
          ]),
        ),
        const SizedBox(height:24),
        SizedBox(width:double.infinity,child:ElevatedButton(
          onPressed:_loading?null:_submit,
          child:_loading?const SizedBox(width:20,height:20,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2))
            :const Text('Actualizar Contraseña'))),
        const SizedBox(height:16),
      ]))),
    ])),
  );

  Widget _pf(String label,TextEditingController c,bool obs,VoidCallback toggle,String hint)=>
    Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
      const SizedBox(height:6),
      TextField(controller:c,obscureText:obs,decoration:InputDecoration(hintText:hint,
        suffixIcon:IconButton(icon:Icon(obs?Icons.visibility_off_outlined:Icons.visibility_outlined,size:20,color:AppTheme.textLight),onPressed:toggle))),
      const SizedBox(height:14),
    ]);
}

class _Req extends StatelessWidget {
  final String text; const _Req(this.text);
  @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:4),
    child:Row(children:[const Text('• ',style:TextStyle(color:AppTheme.accentBlue,fontWeight:FontWeight.bold)),
      Text(text,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary))]));
}