import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CapacidadMaximaView extends StatefulWidget {
  const CapacidadMaximaView({super.key});
  @override State<CapacidadMaximaView> createState() => _S();
}

class _S extends State<CapacidadMaximaView> {
  int _cap = 50;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor:AppTheme.bgGray,
    body:SafeArea(child:Column(children:[
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
                child:const Icon(Icons.group_outlined,color:Colors.white,size:22)),
            const SizedBox(width:14),
            const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Capacidad Máxima',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
              Text('Ajusta los turnos por día',style:TextStyle(fontSize:12,color:Colors.white70)),
            ])),
          ]),
        ]),
      ),
      Expanded(child:SingleChildScrollView(padding:const EdgeInsets.all(16),child:Column(children:[
        Container(width:double.infinity,padding:const EdgeInsets.all(24),
            decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
            child:Column(children:[
              const Text('Capacidad actual',style:TextStyle(fontSize:13,color:AppTheme.textSecondary)),
              const SizedBox(height:16),
              Container(width:100,height:100,decoration:const BoxDecoration(color:AppTheme.bgLight,shape:BoxShape.circle),
                  child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
                    Text('$_cap',style:const TextStyle(fontSize:36,fontWeight:FontWeight.bold,color:AppTheme.accentBlue)),
                    const Text('turnos/día',style:TextStyle(fontSize:11,color:AppTheme.textSecondary)),
                  ])),
              const SizedBox(height:20),
              // ── Se reemplazaron los botones por el Slider ──
              SliderTheme(
                  data:SliderThemeData(
                      activeTrackColor:AppTheme.accentBlue,
                      thumbColor:AppTheme.accentBlue,
                      inactiveTrackColor:AppTheme.borderColor,
                      overlayColor:AppTheme.accentBlue.withOpacity(0.2)
                  ),
                  child:Slider(
                      value:_cap.toDouble(),
                      min:10,
                      max:200,
                      divisions:190, // Permite mover la barra de 1 en 1
                      onChanged:(v)=>setState(()=>_cap=v.round())
                  )
              ),
              const Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                Text('10',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                Text('200',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
              ]),
            ])),
        const SizedBox(height:14),
        Container(width:double.infinity,padding:const EdgeInsets.all(16),
            decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
            child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[Icon(Icons.circle,size:8,color:AppTheme.accentBlue),SizedBox(width:8),
                Text('Información',style:TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:AppTheme.textPrimary))]),
              SizedBox(height:10),
              _Bul('La capacidad determina cuántos turnos puedes atender por día'),
              _Bul('Puedes ajustarla entre 10 y 200 turnos diarios'),
              _Bul('Los clientes no podrán reservar una vez alcanzado el límite'),
            ])),
        const SizedBox(height:14),
        const Align(alignment:Alignment.centerLeft,
            child:Text('Presets rápidos',style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:AppTheme.textPrimary))),
        const SizedBox(height:10),
        Row(children:[25,50,100,150].map((v)=>Expanded(child:Padding(
            padding:const EdgeInsets.only(right:8),
            child:GestureDetector(onTap:()=>setState(()=>_cap=v),
                child:Container(
                  padding:const EdgeInsets.symmetric(vertical:10),
                  decoration:BoxDecoration(
                      color:_cap==v?AppTheme.accentBlue:Colors.white,
                      borderRadius:BorderRadius.circular(10),
                      border:Border.all(color:_cap==v?AppTheme.accentBlue:AppTheme.borderColor)),
                  child:Text('$v',textAlign:TextAlign.center,
                      style:TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:_cap==v?Colors.white:AppTheme.textPrimary)),
                ))))).toList()),
        const SizedBox(height:24),
        SizedBox(
            width:double.infinity,
            child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed:()=>Navigator.pop(context),
                child:const Text('Guardar Configuración', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
            )
        ),
        const SizedBox(height:16),
      ]))),
    ])),
  );
}

class _Bul extends StatelessWidget {
  final String text; const _Bul(this.text);
  @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.only(bottom:4,left:16),
      child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('• ',style:TextStyle(color:AppTheme.accentBlue)),
        Expanded(child:Text(text,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)))]));
}