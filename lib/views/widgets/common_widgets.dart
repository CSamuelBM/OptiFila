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
    SizedBox(
      width: 60,
      height: 40,
      child: Image.asset(
        'assets/img/logo.png',
        fit: BoxFit.contain,
      ),
    ),
    const SizedBox(width:8),
    Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      Text('OptiFila', style:TextStyle(color:AppTheme.headerTeal, fontWeight:FontWeight.bold, fontSize:size*0.6)),
      Text('Tu turno, sin filas.', style:TextStyle(color:AppTheme.accentOrange, fontSize:size*0.3)),
    ]),
  ]),
);

// ── WIDGETS AUXILIARES ──

class _Stat extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const _Stat({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// Usamos InfoRow que ya tienes definido en tu archivo de componentes
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // Reutilizamos tu componente global InfoRow
    return InfoRow(icon: icon, label: label, value: value);
  }
}

// Corrección de _PrefRow
class _PrefRow extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final VoidCallback onTap;

  const _PrefRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.headerTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppTheme.headerTeal),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }
}