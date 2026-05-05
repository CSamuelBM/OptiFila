import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/business_model.dart';
import '../business/business_detail_view.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override State<HomeTab> createState() => _State();
}
class _State extends State<HomeTab> {
  static const _categories = ['Todos','Restaurantes','Belleza','Bancos'];

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;
    return ListenableBuilder(listenable:ctrl, builder:(ctx,_) {
      final businesses = ctrl.filteredBusinesses;
      return Column(children:[
        // ── Header ──
        Container(
          color:AppTheme.headerTeal,
          padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+12,left:16,right:16,bottom:16),
          child:Row(children:[
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[
                const Text('Hola, Usuario',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
                const SizedBox(width:6),
                const Text('👋',style:TextStyle(fontSize:18)),
              ]),
              const Text('¿A dónde quieres ir hoy?',style:TextStyle(color:Colors.white70,fontSize:13)),
            ])),
            GestureDetector(
              onTap:(){ AppControllers.auth.logout(); Navigator.pushReplacementNamed(context,'/login'); },
              child:Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(20)),
                  child:const Icon(Icons.logout,color:Colors.white,size:18)),
            ),
          ]),
        ),
        // ── Search ──
        Container(
          color:AppTheme.headerTeal,
          padding:const EdgeInsets.fromLTRB(16,0,16,12),
          child:TextField(
            onChanged:ctrl.setSearch,
            decoration:InputDecoration(
              hintText:'Buscar negocios...',
              prefixIcon:const Icon(Icons.search,color:AppTheme.textLight),
              filled:true,fillColor:Colors.white,
              border:OutlineInputBorder(borderRadius:BorderRadius.circular(30),borderSide:BorderSide.none),
              enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(30),borderSide:BorderSide.none),
              contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:12),
            ),
          ),
        ),
        // ── Categories ──
        Container(
          color:Colors.white,
          padding:const EdgeInsets.symmetric(vertical:10,horizontal:12),
          child:SizedBox(
            height:36,
            child:ListView.separated(
              scrollDirection:Axis.horizontal,
              itemCount:_categories.length,
              separatorBuilder:(_,__)=>const SizedBox(width:8),
              itemBuilder:(ctx,i){
                final sel = ctrl.selectedCategory == _categories[i];
                return GestureDetector(
                  onTap:()=>ctrl.setCategory(_categories[i]),
                  child:Container(
                    padding:const EdgeInsets.symmetric(horizontal:18,vertical:6),
                    decoration:BoxDecoration(
                      color:sel?AppTheme.accentOrange:Colors.white,
                      borderRadius:BorderRadius.circular(20),
                      border:Border.all(color:sel?AppTheme.accentOrange:AppTheme.borderColor),
                    ),
                    child:Text(_categories[i],style:TextStyle(fontSize:13,fontWeight:FontWeight.w500,color:sel?Colors.white:AppTheme.textPrimary)),
                  ),
                );
              },
            ),
          ),
        ),
        // ── List ──
        Expanded(child:ListView(padding:const EdgeInsets.all(16),children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
            const Text('Negocios cerca de ti',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
            const Icon(Icons.location_on_outlined,size:18,color:AppTheme.textSecondary),
          ]),
          const SizedBox(height:12),
          ...businesses.map((b) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BusinessDetailView(business: b),
            )),
            child: _BusinessCard(business: b),
          )),
        ])),
      ]);
    });
  }
}

class _BusinessCard extends StatelessWidget {
  final BusinessModel business;
  const _BusinessCard({required this.business});

  Color get _catColor {
    switch(business.category){
      case 'Restaurante': return AppTheme.accentOrange;
      case 'Belleza':     return const Color(0xFF1B3A50);
      case 'Banco':       return Colors.grey;
      default:            return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin:const EdgeInsets.only(bottom:12),
    padding:const EdgeInsets.all(14),
    decoration:BoxDecoration(
      color:Colors.white,
      borderRadius:BorderRadius.circular(14),
      border:Border.all(color:business.isOpen?AppTheme.accentOrange:AppTheme.borderColor,width:business.isOpen?1.5:0.5),
    ),
    child:Row(children:[
      // Logo placeholder
      Stack(children:[
        Container(width:50,height:50,decoration:BoxDecoration(color:_catColor.withOpacity(0.15),borderRadius:BorderRadius.circular(12)),
            child:Center(child:Container(width:24,height:24,decoration:BoxDecoration(color:_catColor,shape:BoxShape.circle)))),
        if(business.isOpen) Positioned(top:0,right:0,child:Container(width:10,height:10,decoration:BoxDecoration(color:AppTheme.successGreen,shape:BoxShape.circle,border:Border.all(color:Colors.white,width:1.5)))),
      ]),
      const SizedBox(width:14),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
          Text(business.name,style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
          Row(children:[
            const Icon(Icons.star,size:14,color:Color(0xFFFFB400)),
            const SizedBox(width:2),
            Text(business.rating.toString(),style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
          ]),
        ]),
        Text(business.category,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
        const SizedBox(height:6),
        Row(children:[
          const Icon(Icons.location_on_outlined,size:13,color:AppTheme.accentOrange),
          const SizedBox(width:3),
          Text(business.address,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
        ]),
        const SizedBox(height:6),
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
          Row(children:[
            const Icon(Icons.group_outlined,size:13,color:AppTheme.textSecondary),
            const SizedBox(width:3),
            Text('\${business.queueCount} en fila',style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          ]),
          Container(
            padding:const EdgeInsets.symmetric(horizontal:10,vertical:3),
            decoration:BoxDecoration(
              color:AppTheme.orangePale,
              borderRadius:BorderRadius.circular(20),
              border:Border.all(color:AppTheme.accentOrange,width:0.8),
            ),
            child:Text('~\${business.waitMinutes} min',style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:AppTheme.accentOrange)),
          ),
        ]),
      ])),
    ]),
  );
}