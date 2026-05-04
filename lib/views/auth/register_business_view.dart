import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../widgets/common_widgets.dart';

class RegisterBusinessView extends StatefulWidget {
  const RegisterBusinessView({super.key});
  @override State<RegisterBusinessView> createState() => _State();
}
class _State extends State<RegisterBusinessView> {
  final _name     = TextEditingController();
  final _email    = TextEditingController();
  final _password = TextEditingController();
  final _bName    = TextEditingController();
  bool _obscure   = true;
  bool _loading   = false;
  String? _category;

  static const _categories = ['Restaurante','Belleza','Banco','Médico','Retail','Otro'];

  Future<void> _submit() async {
    if (_name.text.isEmpty||_email.text.isEmpty||_password.text.isEmpty||_bName.text.isEmpty||_category==null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Completa todos los campos'),backgroundColor:AppTheme.errorRed));
      return;
    }
    setState(()=>_loading=true);
    final ok = await AppControllers.auth.registerBusiness(
      name:_name.text.trim(), email:_email.text.trim(),
      password:_password.text, businessName:_bName.text.trim(), category:_category!);
    if (!mounted) return;
    setState(()=>_loading=false);
    if (ok) Navigator.pushReplacementNamed(context,'/business');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.headerTeal,
    body: SafeArea(child:Column(children:[
      Padding(
        padding:const EdgeInsets.fromLTRB(16,16,16,0),
        child:Align(
          alignment:Alignment.centerLeft,
          child:GestureDetector(
            onTap:()=>Navigator.pop(context),
            child:const Row(mainAxisSize:MainAxisSize.min,children:[
              Icon(Icons.arrow_back_ios,size:16,color:Colors.white),
              Text('Volver',style:TextStyle(color:Colors.white,fontSize:14)),
            ]),
          ),
        ),
      ),
      const SizedBox(height:16),
      const Text('Registro de Negocio',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Colors.white)),
      const Text('Completa tus datos',style:TextStyle(fontSize:13,color:Colors.white70)),
      const SizedBox(height:20),
      Expanded(child:Container(
        padding:const EdgeInsets.all(24),
        decoration:const BoxDecoration(color:Colors.white,borderRadius:BorderRadius.vertical(top:Radius.circular(20))),
        child:SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const SizedBox(height:8),
          _label('Nombre completo'), TextField(controller:_name, decoration:const InputDecoration(hintText:'Juan Pérez')),
          const SizedBox(height:14),
          _label('Email'), TextField(controller:_email, keyboardType:TextInputType.emailAddress, decoration:const InputDecoration(hintText:'tu@email.com')),
          const SizedBox(height:14),
          _label('Contraseña'),
          TextField(controller:_password, obscureText:_obscure, decoration:InputDecoration(
            hintText:'••••••••',
            suffixIcon:IconButton(icon:Icon(_obscure?Icons.visibility_off_outlined:Icons.visibility_outlined,size:20,color:AppTheme.textLight),
              onPressed:()=>setState(()=>_obscure=!_obscure)),
          )),
          const SizedBox(height:14),
          _label('Nombre del negocio'), TextField(controller:_bName, decoration:const InputDecoration(hintText:'Mi Negocio')),
          const SizedBox(height:14),
          _label('Categoría'),
          Container(
            width:double.infinity,
            padding:const EdgeInsets.symmetric(horizontal:14),
            decoration:BoxDecoration(color:const Color(0xFFF3F4F6),borderRadius:BorderRadius.circular(12)),
            child:DropdownButtonHideUnderline(child:DropdownButton<String>(
              value:_category,
              hint:const Text('Selecciona una categoría',style:TextStyle(color:Color(0xFFBDC3CB),fontSize:14)),
              items:_categories.map((c)=>DropdownMenuItem(value:c,child:Text(c))).toList(),
              onChanged:(v)=>setState(()=>_category=v),
            )),
          ),
          const SizedBox(height:28),
          PrimaryButton(label:'Crear Cuenta', onPressed:_submit, isLoading:_loading),
          const SizedBox(height:16),
        ])),
      )),
    ])),
  );

  Widget _label(String t) => Padding(padding:const EdgeInsets.only(bottom:8),
    child:Text(t,style:const TextStyle(fontWeight:FontWeight.w500,color:AppTheme.textPrimary,fontSize:14)));
}