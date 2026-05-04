import 'package:flutter/material.dart';
import '../../app_theme.dart';

// Orange filled button
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  const PrimaryButton({super.key, required this.label, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
        ? const SizedBox(width:20,height:20,child:CircularProgressIndicator(color:Colors.white,strokeWidth:2))
        : Text(label),
    ),
  );
}

// Outlined section row (info row with icon + text + optional edit icon)
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;
  const InfoRow({super.key, required this.icon, required this.label, required this.value, this.onEdit});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal:16, vertical:12),
    child: Row(
      children: [
        Icon(icon, size:20, color: AppTheme.textSecondary),
        const SizedBox(width:14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize:11, color: AppTheme.textLight)),
            const SizedBox(height:2),
            Text(value,  style: const TextStyle(fontSize:14, fontWeight:FontWeight.w500, color: AppTheme.textPrimary)),
          ],
        )),
        if (onEdit != null) GestureDetector(
          onTap: onEdit,
          child: const Icon(Icons.edit_outlined, size:18, color: AppTheme.textLight),
        ),
      ],
    ),
  );
}

// White card wrapper
Widget whiteCard({required Widget child, EdgeInsets? padding, BorderRadius? radius}) =>
  Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal:16, vertical:4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: radius ?? BorderRadius.circular(14),
      border: Border.all(color: AppTheme.borderColor, width:0.5),
    ),
    child: padding != null ? Padding(padding: padding, child: child) : child,
  );

// Bottom nav label+icon item
BottomNavigationBarItem navItem(IconData icon, String label) =>
  BottomNavigationBarItem(icon: Icon(icon), label: label);

// Section label
Widget sectionLabel(String text) => Padding(
  padding: const EdgeInsets.fromLTRB(16,18,16,8),
  child: Text(text, style: const TextStyle(fontSize:15, fontWeight:FontWeight.bold, color: AppTheme.textPrimary)),
);

// OptiFila logo widget
Widget optifilaLogo({double size=32}) => Container(
  padding: const EdgeInsets.symmetric(horizontal:14, vertical:10),
  decoration: BoxDecoration(color:Colors.white, borderRadius:BorderRadius.circular(10)),
  child: Row(mainAxisSize:MainAxisSize.min, children:[
    Container(
      width:size+4, height:size+4,
      decoration: BoxDecoration(color:AppTheme.accentOrange, borderRadius:BorderRadius.circular(8)),
      child: Icon(Icons.calendar_month_rounded, color:Colors.white, size:size*0.7),
    ),
    const SizedBox(width:8),
    Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Text('OptiFila', style:TextStyle(color:AppTheme.headerTeal, fontWeight:FontWeight.bold, fontSize:size*0.6)),
      Text('Tu turno, sin filas.', style:TextStyle(color:AppTheme.accentOrange, fontSize:size*0.3)),
    ]),
  ]),
);