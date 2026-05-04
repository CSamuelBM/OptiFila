import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/client_model.dart';

class ClientesTab extends StatelessWidget {
  const ClientesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.business;
    return ListenableBuilder(listenable:ctrl, builder:(ctx,_){
      final clients = ctrl.filteredClients;
      return Column(children:[
        Container(
          color:AppTheme.headerTeal,
          padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+12,left:16,right:16,bottom:16),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Text('Clientes',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
            const Text('Gestiona tu base de clientes',style:TextStyle(fontSize:13,color:Colors.white70)),
            const SizedBox(height:12),
            TextField(
              onChanged:ctrl.searchClients,
              decoration:InputDecoration(
                hintText:'Buscar clientes...',
                prefixIcon:const Icon(Icons.search,color:AppTheme.textLight),
                filled:true,fillColor:Colors.white,
                border:OutlineInputBorder(borderRadius:BorderRadius.circular(30),borderSide:BorderSide.none),
                enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(30),borderSide:BorderSide.none),
                contentPadding:const EdgeInsets.symmetric(horizontal:16,vertical:10),
              ),
            ),
          ]),
        ),
        // Stats bar
        Container(
          color:Colors.white,
          padding:const EdgeInsets.symmetric(vertical:12,horizontal:16),
          child:Row(children:[
            Expanded(child:_MiniStat(value:ctrl.totalClients,label:'Total')),
            Expanded(child:_MiniStat(value:ctrl.todayClients,label:'Hoy')),
            Expanded(child:_MiniStat(value:ctrl.weekClients,label:'Esta semana')),
          ]),
        ),
        const SizedBox(height:8),
        Padding(padding:const EdgeInsets.fromLTRB(16,0,16,8),
          child:Text('\${clients.length} clientes',style:const TextStyle(fontSize:14,fontWeight:FontWeight.w600,color:AppTheme.textPrimary))),
        Expanded(child:ListView.builder(
          padding:const EdgeInsets.fromLTRB(16,0,16,16),
          itemCount:clients.length,
          itemBuilder:(ctx,i)=>_ClientCard(client:clients[i]),
        )),
      ]);
    });
  }
}

class _MiniStat extends StatelessWidget {
  final int value; final String label;
  const _MiniStat({required this.value,required this.label});
  @override Widget build(BuildContext context) => Column(children:[
    Text('\$value',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
    Text(label,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
  ]);
}

class _ClientCard extends StatelessWidget {
  final ClientModel client;
  const _ClientCard({required this.client});

  String _formatDate(DateTime d) {
    final now=DateTime.now();
    if(d.year==now.year&&d.month==now.month&&d.day==now.day) return 'Hoy, \${d.hour}:\${d.minute.toString().padLeft(2,"0")} AM';
    final yest=now.subtract(const Duration(days:1));
    if(d.year==yest.year&&d.month==yest.month&&d.day==yest.day) return 'Ayer, \${d.hour}:\${d.minute.toString().padLeft(2,"0")} PM';
    return 'Hace \${now.difference(d).inDays} días';
  }

  @override
  Widget build(BuildContext context) => Container(
    margin:const EdgeInsets.only(bottom:12),
    padding:const EdgeInsets.all(14),
    decoration:BoxDecoration(
      color:Colors.white,
      borderRadius:BorderRadius.circular(14),
      border:Border(left:BorderSide(color:client.isInTurn?AppTheme.accentOrange:AppTheme.borderColor,width:client.isInTurn?3:0.5)),
    ),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(children:[
        Container(width:40,height:40,decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(20)),
          child:const Icon(Icons.person_outline,size:20,color:AppTheme.textSecondary)),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(client.name,style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
          Row(children:[
            const Icon(Icons.access_time_outlined,size:12,color:AppTheme.textSecondary),
            const SizedBox(width:3),
            Text(_formatDate(client.lastVisit),style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          ]),
        ])),
        if(client.isInTurn) Container(
          padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
          decoration:BoxDecoration(color:AppTheme.orangePale,borderRadius:BorderRadius.circular(8),border:Border.all(color:AppTheme.accentOrange)),
          child:const Text('En turno',style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:AppTheme.accentOrange)),
        ),
      ]),
      const SizedBox(height:10),
      Row(children:[
        const Icon(Icons.email_outlined,size:13,color:AppTheme.accentOrange),
        const SizedBox(width:6),
        Text(client.email,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
      ]),
      const SizedBox(height:4),
      Row(children:[
        const Icon(Icons.phone_outlined,size:13,color:AppTheme.textSecondary),
        const SizedBox(width:6),
        Text(client.phone,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
      ]),
      const SizedBox(height:10),
      Divider(height:1,color:AppTheme.borderColor),
      const SizedBox(height:8),
      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
        const Text('Total de visitas',style:TextStyle(fontSize:12,color:AppTheme.textSecondary)),
        Container(
          width:32,height:32,
          decoration:BoxDecoration(color:AppTheme.bgGray,borderRadius:BorderRadius.circular(8)),
          child:Center(child:Text('\${client.totalVisits}',style:const TextStyle(fontSize:13,fontWeight:FontWeight.bold,color:AppTheme.textPrimary))),
        ),
      ]),
    ]),
  );
}