import 'package:flutter/material.dart';
import '../../app_theme.dart';

class TiempoAtencionView extends StatefulWidget {
  const TiempoAtencionView({super.key});
  @override State<TiempoAtencionView> createState() => _S();
}
class _S extends State<TiempoAtencionView> {
  double _min = 17; // Lo iniciamos en 17 para que coincida con tu diseño

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
                child:const Icon(Icons.timer_outlined,color:Colors.white,size:22)),
            const SizedBox(width:14),
            const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('Tiempo de Atención',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
              Text('Ajusta el tiempo promedio por cliente',style:TextStyle(fontSize:12,color:Colors.white70)),
            ])),
          ]),
        ]),
      ),
      Expanded(child:SingleChildScrollView(padding:const EdgeInsets.all(16),child:Column(children:[
        // Slider card
        Container(width:double.infinity,padding:const EdgeInsets.all(20),
            decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
            child:Column(children:[
              const Text('Tiempo promedio actual',style:TextStyle(fontSize:13,color:AppTheme.textSecondary)),
              const SizedBox(height:16),
              Container(width:100,height:100,decoration:const BoxDecoration(color:AppTheme.bgLight,shape:BoxShape.circle),
                  child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
                    // ── Corrección: Se quitó el \ de la interpolación ──
                    Text('${_min.round()}',style:const TextStyle(fontSize:36,fontWeight:FontWeight.bold,color:AppTheme.accentBlue)),
                    const Text('minutos',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                  ])),
              const SizedBox(height:16),
              SliderTheme(
                  data:SliderThemeData(activeTrackColor:AppTheme.accentBlue,thumbColor:AppTheme.accentBlue,
                      inactiveTrackColor:AppTheme.borderColor,overlayColor:AppTheme.accentBlue.withOpacity(0.2)),
                  child:Slider(value:_min,min:1,max:60,divisions:59,onChanged:(v)=>setState(()=>_min=v))),
              const Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                Text('1 min',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                Text('60 min',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
              ]),
            ])),
        const SizedBox(height:14),
        // Info card
        Container(width:double.infinity,padding:const EdgeInsets.all(16),
            decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
            child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[Icon(Icons.circle,size:8,color:AppTheme.accentBlue),SizedBox(width:8),
                Text('Información',style:TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:AppTheme.textPrimary))]),
              SizedBox(height:10),
              _Bul('Este tiempo se usa para calcular la espera estimada'),
              _Bul('Puedes ajustarlo según tu experiencia real'),
              _Bul('Un tiempo más preciso mejora la experiencia del cliente'),
            ])),
        const SizedBox(height:14),
        const Align(alignment:Alignment.centerLeft,
            child:Text('Presets comunes',style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:AppTheme.textPrimary))),
        const SizedBox(height:10),
        Row(children:[5,10,15,20].map((m)=>Expanded(child:Padding(
            padding:const EdgeInsets.only(right:8),
            child:GestureDetector(onTap:()=>setState(()=>_min=m.toDouble()),
                child:Container(
                  padding:const EdgeInsets.symmetric(vertical:10),
                  decoration:BoxDecoration(
                      color:_min.round()==m?AppTheme.accentBlue:Colors.white,
                      borderRadius:BorderRadius.circular(10),
                      border:Border.all(color:_min.round()==m?AppTheme.accentBlue:AppTheme.borderColor)),
                  // ── Corrección: Se quitó el \ de la interpolación ──
                  child:Text('${m}m',textAlign:TextAlign.center,
                      style:TextStyle(fontSize:14,fontWeight:FontWeight.w600,
                          color:_min.round()==m?Colors.white:AppTheme.textPrimary)),
                ))))).toList()),
        const SizedBox(height:14),
        Container(width:double.infinity,padding:const EdgeInsets.all(16),
            decoration:BoxDecoration(color:AppTheme.bgLight,borderRadius:BorderRadius.circular(14)),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              const Text('Vista previa de estimación',style:TextStyle(fontSize:13,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
              const SizedBox(height:12),
              Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:[3,5,10].map((p)=>Column(children:[
                // ── Corrección: Se quitó el \ de la interpolación ──
                Text('$p personas',style:const TextStyle(fontSize:11,color:AppTheme.textSecondary)),
                const SizedBox(height:4),
                // ── Corrección: Se quitó el \ de la interpolación ──
                Text('${(p*_min).round()}m',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
              ])).toList()),
            ])),
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