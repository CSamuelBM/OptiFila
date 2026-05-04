import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';

class InicioTab extends StatelessWidget {
  const InicioTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.business;
    return ListenableBuilder(listenable:ctrl, builder:(ctx,_){
      return CustomScrollView(slivers:[
        SliverToBoxAdapter(child:Container(
          color:AppTheme.headerTeal,
          padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+12,left:16,right:16,bottom:20),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
              const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text('Mi Negocio',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
                Text('Dashboard de gestión',style:TextStyle(fontSize:13,color:Colors.white70)),
              ]),
              GestureDetector(
                onTap:(){ AppControllers.auth.logout(); Navigator.pushReplacementNamed(context,'/login'); },
                child:Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white24,borderRadius:BorderRadius.circular(20)),
                  child:const Icon(Icons.logout,color:Colors.white,size:18)),
              ),
            ]),
            const SizedBox(height:16),
            Row(children:[
              Expanded(child:_HeaderStat(icon:Icons.group_outlined,label:'En espera',value:'\${ctrl.inQueue}')),
              const SizedBox(width:12),
              Expanded(child:_HeaderStat(icon:Icons.access_time_outlined,label:'Tiempo prom.',value:'\${ctrl.avgMinutes}min')),
            ]),
          ]),
        )),
        // Atendiendo ahora card
        SliverToBoxAdapter(child:Container(
          margin:const EdgeInsets.all(16),
          padding:const EdgeInsets.all(20),
          decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16),boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.05),blurRadius:8)]),
          child:Column(children:[
            const Text('Atendiendo ahora',style:TextStyle(fontSize:13,color:AppTheme.textSecondary)),
            const SizedBox(height:12),
            Container(width:80,height:80,decoration:BoxDecoration(color:AppTheme.orangePale,borderRadius:BorderRadius.circular(40)),
              child:Center(child:Text('\${ctrl.currentTurn}',style:const TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:AppTheme.accentOrange)))),
            const SizedBox(height:16),
            SizedBox(width:double.infinity,child:ElevatedButton(
              onPressed:ctrl.nextTurn,
              child:const Text('Siguiente Turno'),
            )),
          ]),
        )),
        // Queue
        SliverToBoxAdapter(child:Padding(
          padding:const EdgeInsets.fromLTRB(16,0,16,8),
          child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
            const Text('Cola de espera',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
            TextButton(onPressed:(){},child:const Text('Ver todos',style:TextStyle(color:AppTheme.accentOrange,fontSize:13))),
          ]),
        )),
        SliverList(delegate:SliverChildBuilderDelegate(
          (ctx,i){
            final t=ctrl.queue[i];
            return Container(
              margin:const EdgeInsets.fromLTRB(16,0,16,10),
              padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),
              decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12),
                border:Border(left:const BorderSide(color:AppTheme.successGreen,width:3))),
              child:Row(children:[
                Stack(children:[
                  Container(width:40,height:40,decoration:BoxDecoration(color:const Color(0xFF2D4A5A),borderRadius:BorderRadius.circular(8)),
                    child:Center(child:Text('\${t.number}',style:const TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:Colors.white)))),
                  Positioned(top:0,right:0,child:Container(width:8,height:8,decoration:BoxDecoration(color:AppTheme.successGreen,shape:BoxShape.circle,border:Border.all(color:Colors.white,width:1)))),
                ]),
                const SizedBox(width:12),
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text('Turno #\${t.number}',style:const TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:AppTheme.textPrimary)),
                  Row(children:[
                    const Icon(Icons.access_time_outlined,size:12,color:AppTheme.textSecondary),
                    const SizedBox(width:3),
                    Text('\${t.dateTime.hour}:\${t.dateTime.minute.toString().padLeft(2,"0")} PM',style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                  ]),
                ])),
                Container(
                  padding:const EdgeInsets.symmetric(horizontal:12,vertical:5),
                  decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(20)),
                  child:const Text('Esperando',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
                ),
              ]),
            );
          },
          childCount:ctrl.queue.length,
        )),
        // Stats
        SliverToBoxAdapter(child:Padding(
          padding:const EdgeInsets.fromLTRB(16,8,16,8),
          child:const Text('Estadísticas de hoy',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
        )),
        SliverToBoxAdapter(child:Padding(
          padding:const EdgeInsets.fromLTRB(16,0,16,24),
          child:Row(children:[
            Expanded(child:_StatCard(icon:Icons.bar_chart_rounded,label:'Atendidos',value:'\${ctrl.attendedToday}',iconColor:AppTheme.accentOrange)),
            const SizedBox(width:12),
            Expanded(child:_StatCard(icon:Icons.trending_up_rounded,label:'Satisfacción',value:'\${(ctrl.satisfaction*100).toInt()}%',iconColor:AppTheme.successGreen)),
          ]),
        )),
      ]);
    });
  }
}

class _HeaderStat extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _HeaderStat({required this.icon,required this.label,required this.value});
  @override Widget build(BuildContext context) => Container(
    padding:const EdgeInsets.all(14),
    decoration:BoxDecoration(color:Colors.white.withOpacity(0.15),borderRadius:BorderRadius.circular(12)),
    child:Row(children:[
      Icon(icon,size:18,color:Colors.white70),
      const SizedBox(width:8),
      Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(label,style:const TextStyle(fontSize:11,color:Colors.white70)),
        Text(value, style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white)),
      ]),
    ]),
  );
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color iconColor;
  const _StatCard({required this.icon,required this.label,required this.value,required this.iconColor});
  @override Widget build(BuildContext context) => Container(
    padding:const EdgeInsets.all(16),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14),border:Border.all(color:AppTheme.borderColor,width:0.5)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(children:[Icon(icon,size:16,color:iconColor),const SizedBox(width:6),Text(label,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary))]),
      const SizedBox(height:6),
      Text(value,style:const TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
    ]),
  );
}