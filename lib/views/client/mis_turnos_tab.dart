import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../app_controllers.dart';
import '../../models/turn_model.dart';

class MisTurnosTab extends StatefulWidget {
  const MisTurnosTab({super.key});
  @override State<MisTurnosTab> createState() => _State();
}
class _State extends State<MisTurnosTab> {
  int _tabIdx = 0;
  static const _tabs = ['Todos','Activos','Completados','Cancelados'];

  @override
  Widget build(BuildContext context) {
    final ctrl = AppControllers.client;
    return ListenableBuilder(listenable:ctrl, builder:(ctx,_){
      final all       = ctrl.allTurns;
      final active    = ctrl.activeTurns;
      final completed = ctrl.completedTurns;
      final cancelled = ctrl.cancelledTurns;
      final lists     = [all, active, completed, cancelled];
      final counts    = [all.length, active.length, completed.length, cancelled.length];

      return Column(children:[
        Container(
          color:AppTheme.headerTeal,
          padding:EdgeInsets.only(top:MediaQuery.of(context).padding.top+12,left:16,right:16,bottom:20),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            const Text('Mis Turnos',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.white)),
            const Text('Historial y turnos activos',style:TextStyle(color:Colors.white70,fontSize:13)),
            const SizedBox(height:16),
            Row(children:[
              Expanded(child:_StatCard(label:'Activos',value:active.length,icon:Icons.circle,iconColor:AppTheme.successGreen,isSelected:true)),
              const SizedBox(width:10),
              Expanded(child:_StatCard(label:'Completados',value:completed.length,icon:Icons.check_circle_outline,iconColor:AppTheme.textSecondary,isSelected:false)),
            ]),
          ]),
        ),
        // Filter tabs
        Container(
          color:Colors.white,
          padding:const EdgeInsets.symmetric(vertical:10,horizontal:12),
          child:SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(
            children:List.generate(_tabs.length,(i){
              final sel=_tabIdx==i;
              return GestureDetector(
                onTap:()=>setState(()=>_tabIdx=i),
                child:Container(
                  margin:const EdgeInsets.only(right:8),
                  padding:const EdgeInsets.symmetric(horizontal:14,vertical:6),
                  decoration:BoxDecoration(
                    color:sel?AppTheme.accentOrange:Colors.white,
                    borderRadius:BorderRadius.circular(20),
                    border:Border.all(color:sel?AppTheme.accentOrange:AppTheme.borderColor),
                  ),
                  child:Text('\${_tabs[i]}\${i>0?" (\${counts[i]})":"  (\${counts[0]})"}',
                    style:TextStyle(fontSize:12,fontWeight:FontWeight.w500,color:sel?Colors.white:AppTheme.textPrimary)),
                ),
              );
            }),
          )),
        ),
        // List
        Expanded(child:ListView.builder(
          padding:const EdgeInsets.all(16),
          itemCount:lists[_tabIdx].length,
          itemBuilder:(ctx,i)=>_TurnCard(turn:lists[_tabIdx][i]),
        )),
      ]);
    });
  }
}

class _StatCard extends StatelessWidget {
  final String label; final int value; final IconData icon; final Color iconColor; final bool isSelected;
  const _StatCard({required this.label,required this.value,required this.icon,required this.iconColor,required this.isSelected});

  @override
  Widget build(BuildContext context) => Container(
    padding:const EdgeInsets.all(14),
    decoration:BoxDecoration(
      color:isSelected?Colors.white:Colors.white.withOpacity(0.85),
      borderRadius:BorderRadius.circular(12),
    ),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Row(children:[
        Icon(icon,size:12,color:iconColor),
        const SizedBox(width:4),
        Text(label,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
      ]),
      const SizedBox(height:4),
      Text('\$value',style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold,color:AppTheme.textPrimary)),
    ]),
  );
}

class _TurnCard extends StatelessWidget {
  final TurnModel turn;
  const _TurnCard({required this.turn});

  Color get _numColor {
    switch(turn.status){
      case TurnStatus.active:    return AppTheme.accentOrange;
      case TurnStatus.completed: return AppTheme.textSecondary;
      case TurnStatus.cancelled: return AppTheme.errorRed;
    }
  }
  Color get _borderColor {
    switch(turn.status){
      case TurnStatus.active:    return AppTheme.successGreen;
      case TurnStatus.completed: return AppTheme.borderColor;
      case TurnStatus.cancelled: return AppTheme.errorRed.withOpacity(0.4);
    }
  }

  String _formatDate(DateTime d) {
    final now=DateTime.now();
    if(d.year==now.year&&d.month==now.month&&d.day==now.day) return 'Hoy - \${_t(d)}';
    final yest=now.subtract(const Duration(days:1));
    if(d.year==yest.year&&d.month==yest.month&&d.day==yest.day) return 'Ayer - \${_t(d)}';
    return '\${d.day} Mar - \${_t(d)}';
  }
  String _t(DateTime d) {
    final h=d.hour; final m=d.minute.toString().padLeft(2,'0');
    final suffix=h>=12?'PM':'AM'; final h12=h>12?h-12:(h==0?12:h);
    return '\$h12:\$m \$suffix';
  }

  @override
  Widget build(BuildContext context) => Container(
    margin:const EdgeInsets.only(bottom:12),
    decoration:BoxDecoration(
      color:Colors.white,
      borderRadius:BorderRadius.circular(14),
      border:Border(left:BorderSide(color:_borderColor,width:3.5)),
    ),
    child:Padding(
      padding:const EdgeInsets.all(14),
      child:Row(children:[
        Container(
          width:46,height:46,
          decoration:BoxDecoration(color:_numColor.withOpacity(0.12),borderRadius:BorderRadius.circular(10)),
          child:Center(child:Text('\${turn.number}',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:_numColor))),
        ),
        const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
            Expanded(child:Text(turn.businessName,style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:AppTheme.textPrimary),overflow:TextOverflow.ellipsis)),
            if(turn.status==TurnStatus.active)
              Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
                decoration:BoxDecoration(color:const Color(0xFFE8F5E9),borderRadius:BorderRadius.circular(8)),
                child:const Text('Activo',style:TextStyle(fontSize:11,color:AppTheme.successGreen,fontWeight:FontWeight.w600)))
            else
              Icon(turn.status==TurnStatus.completed?Icons.check_circle_outline:Icons.cancel_outlined,
                size:20,color:turn.status==TurnStatus.completed?AppTheme.textSecondary:AppTheme.errorRed),
          ]),
          Text(turn.businessType,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          const SizedBox(height:4),
          Row(children:[
            const Icon(Icons.location_on_outlined,size:13,color:AppTheme.accentOrange),
            const SizedBox(width:3),
            Text(turn.address,style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
          ]),
          const SizedBox(height:4),
          Row(children:[
            const Icon(Icons.access_time_outlined,size:13,color:AppTheme.textSecondary),
            const SizedBox(width:3),
            Text(_formatDate(turn.dateTime),style:const TextStyle(fontSize:12,color:AppTheme.textSecondary)),
            if(turn.status==TurnStatus.active&&turn.waitMinutes!=null)...[
              const SizedBox(width:8),
              Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:2),
                decoration:BoxDecoration(color:AppTheme.orangePale,borderRadius:BorderRadius.circular(8),border:Border.all(color:AppTheme.accentOrange,width:0.5)),
                child:Text('Espera: \${turn.waitMinutes} min',style:const TextStyle(fontSize:11,color:AppTheme.accentOrange,fontWeight:FontWeight.w500))),
            ],
          ]),
        ])),
      ]),
    ),
  );
}