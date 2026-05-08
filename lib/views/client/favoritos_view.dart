import 'package:flutter/material.dart';
import '../../app_theme.dart';

class FavoritosView extends StatefulWidget {
  const FavoritosView({super.key});
  @override State<FavoritosView> createState() => _S();
}

class _Fav { final String name,category,address; final double distKm,rating; final int waitMin;
  _Fav(this.name,this.category,this.address,this.distKm,this.rating,this.waitMin); }

class _S extends State<FavoritosView> {
  final _favs = [
    _Fav('Cafetería Central',        'Restaurante',     'Av. Principal 123',  0.5,4.8,10),
    _Fav('Salón Belleza Total',      'Salón de belleza','Calle Bella 456',    1.2,4.9,25),
    _Fav('Clínica Salud',            'Médico',          'Calle Médica 101',   2.1,4.7,30),
    _Fav('Restaurante El Buen Sabor','Restaurante',     'Plaza Central 55',   1.5,4.6,20),
    _Fav('Gimnasio FitLife',         'Gimnasio',        'Av. Deportiva 88',   0.9,4.8,5),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgGray,
    body: SafeArea(child: Column(children:[
      Container(
        color:AppTheme.headerColor,
        padding:const EdgeInsets.fromLTRB(16,12,16,20),
        child:Column(children:[
          Align(alignment:Alignment.centerLeft,child:GestureDetector(onTap:()=>Navigator.pop(context),
            child:const Row(mainAxisSize:MainAxisSize.min,children:[
              Icon(Icons.arrow_back_ios,size:16,color:Colors.white),Text('Volver',style:TextStyle(color:Colors.white,fontSize:14))]))),
          const SizedBox(height:14),
          Row(children:[
            Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(10)),
              child:const Icon(Icons.favorite_border,color:Colors.white,size:22)),
            const SizedBox(width:14),
            Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              const Text('Favoritos',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
              Text('\${_favs.length} negocios guardados',style:const TextStyle(fontSize:13,color:Colors.white70)),
            ]),
          ]),
        ]),
      ),
      Expanded(child:ListView.builder(
        padding:const EdgeInsets.all(16),
        itemCount:_favs.length,
        itemBuilder:(ctx,i){
          final f=_favs[i];
          return Container(
            margin:const EdgeInsets.only(bottom:12),
            decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),
              border:Border(left:BorderSide(color:AppTheme.accentBlue,width:3))),
            child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                Expanded(child:Text(f.name,style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:AppTheme.accentBlue),overflow:TextOverflow.ellipsis)),
                GestureDetector(onTap:()=>setState(()=>_favs.removeAt(i)),
                  child:const Icon(Icons.close,size:18,color:AppTheme.errorRed)),
              ]),
              const SizedBox(height:6),
              Container(
                padding:const EdgeInsets.symmetric(horizontal:10,vertical:3),
                decoration:BoxDecoration(color:AppTheme.headerColor,borderRadius:BorderRadius.circular(20)),
                child:Text(f.category,style:const TextStyle(fontSize:11,color:Colors.white))),
              const SizedBox(height:8),
              Row(children:[
                const Icon(Icons.location_on_outlined,size:13,color:AppTheme.textSecondary),const SizedBox(width:3),
                Text('\${f.distKm} km',style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                const SizedBox(width:12),
                const Icon(Icons.access_time_outlined,size:13,color:AppTheme.textSecondary),const SizedBox(width:3),
                Text('\${f.waitMin} min',style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                const SizedBox(width:12),
                const Icon(Icons.star,size:13,color:Color(0xFFFFB400)),const SizedBox(width:3),
                Text('\${f.rating}',style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
              ]),
              const SizedBox(height:4),
              Row(children:[
                const Icon(Icons.location_on_outlined,size:13,color:AppTheme.accentBlue),const SizedBox(width:3),
                Expanded(child:Text(f.address,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary),overflow:TextOverflow.ellipsis)),
              ]),
            ])),
          );
        },
      )),
    ])),
  );
}