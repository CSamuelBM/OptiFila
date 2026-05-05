import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../widgets/common_widgets.dart';

class RegisterClientView extends StatefulWidget {
  const RegisterClientView({super.key});
  @override State<RegisterClientView> createState() => _State();
}
class _State extends State<RegisterClientView> {
  final _firstName      = TextEditingController();
  final _lastName       = TextEditingController();
  final _secondLastName = TextEditingController();
  final _email          = TextEditingController();
  final _password       = TextEditingController();
  bool _obscure=true; bool _loading=false;

  Future<void> _submit() async {
    if (_firstName.text.isEmpty ||
        _lastName.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos obligatorios'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final ok = await AppControllers.auth.registerClient(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      secondLastName: _secondLastName.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, '/client');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppControllers.auth.error ?? 'Error al registrar'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor:AppTheme.headerTeal,
    body:SafeArea(child:Column(children:[
      Padding(padding:const EdgeInsets.fromLTRB(16,16,16,0),child:Align(alignment:Alignment.centerLeft,
        child:GestureDetector(onTap:()=>Navigator.pop(context),
          child:const Row(mainAxisSize:MainAxisSize.min,children:[
            Icon(Icons.arrow_back_ios,size:16,color:Colors.white),Text('Volver',style:TextStyle(color:Colors.white,fontSize:14))])))),
      const SizedBox(height:16),
      const Text('Registro de Cliente',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Colors.white)),
      const Text('Completa tus datos',style:TextStyle(fontSize:13,color:Colors.white70)),
      const SizedBox(height:20),
      Expanded(child:Container(
        padding:const EdgeInsets.all(24),
        decoration:const BoxDecoration(color:Colors.white,borderRadius:BorderRadius.vertical(top:Radius.circular(20))),
        child:SingleChildScrollView(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const SizedBox(height:8),
          _label('Nombre'),
          TextField(
            controller: _firstName,
            decoration: const InputDecoration(hintText: 'Juan'),
          ),

          const SizedBox(height: 14),

          _label('Apellido paterno'),
          TextField(
            controller: _lastName,
            decoration: const InputDecoration(hintText: 'Pérez'),
          ),

          const SizedBox(height: 14),

          _label('Apellido materno (opcional)'),
          TextField(
            controller: _secondLastName,
            decoration: const InputDecoration(hintText: 'López'),
          ),

          const SizedBox(height: 14),

          _label('Email'),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'tu@email.com'),
          ),

          const SizedBox(height: 14),

          _label('Contraseña'),
          TextField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              hintText: '••••••••',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppTheme.textLight,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          PrimaryButton(label:'Crear Cuenta',onPressed:_submit,isLoading:_loading),
          const SizedBox(height:16),
        ])),
      )),
    ])),
  );
  Widget _label(String t)=>Padding(padding:const EdgeInsets.only(bottom:8),child:Text(t,style:const TextStyle(fontWeight:FontWeight.w500,color:AppTheme.textPrimary,fontSize:14)));
  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _secondLastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

}