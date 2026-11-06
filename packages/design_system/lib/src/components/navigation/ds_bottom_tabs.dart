import 'package:flutter/material.dart';
import '../../common/ds.dart';

/// Barra de abas inferior: Biblioteca e Perfil. A aba ativa tem indicador em
/// `primaryContainer`, ícone e texto em `primary`.
class DsBottomTabs extends StatelessWidget {
  const DsBottomTabs({super.key, required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const List<(IconData, String)> _tabs = [
    (Icons.menu_book_outlined, 'Biblioteca'),
    (Icons.person_outline_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 72,
      padding: const EdgeInsets.fromLTRB(32, 5, 32, 7),
      decoration: BoxDecoration(color: c.surface, border: Border(top: BorderSide(color: c.border))),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: Semantics(
                  button: true,
                  selected: i == selectedIndex,
                  label: _tabs[i].$2,
                  child: ExcludeSemantics(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 64,
                          height: 30,
                          decoration: BoxDecoration(
                            color: i == selectedIndex ? c.primaryContainer : Colors.transparent,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Icon(_tabs[i].$1, size: 24, color: i == selectedIndex ? c.primary : c.onSurfaceMuted),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _tabs[i].$2,
                          style: (i == selectedIndex ? AppTypography.labelSegmentActive : AppTypography.labelSegment)
                              .copyWith(color: i == selectedIndex ? c.primary : c.onSurfaceMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
