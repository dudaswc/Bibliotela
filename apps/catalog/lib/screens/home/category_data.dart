import 'package:flutter/material.dart';

enum CatalogCategory { actions, navigation, inputs, selectors, content, feedback, labels, tokens }

class CategoryData {
  const CategoryData({required this.id, required this.title, required this.subtitle, required this.icon});

  final CatalogCategory id;
  final String title;
  final String subtitle;
  final IconData icon;
}

/// As mesmas categorias (e a mesma ordem) das páginas do arquivo do Figma.
const List<CategoryData> catalogCategories = [
  CategoryData(id: CatalogCategory.actions, title: 'Ações', subtitle: 'Botões, botão de ícone e FAB', icon: Icons.touch_app_outlined),
  CategoryData(id: CatalogCategory.navigation, title: 'Navegação', subtitle: 'Barra superior, abas e seletor de ano', icon: Icons.explore_outlined),
  CategoryData(id: CatalogCategory.inputs, title: 'Campos e filtros', subtitle: 'Texto, senha, busca, lista, data e observação', icon: Icons.edit_note_rounded),
  CategoryData(id: CatalogCategory.selectors, title: 'Seletores e controles', subtitle: 'Filtro de status, chips, nota em estrelas e status', icon: Icons.tune_rounded),
  CategoryData(id: CatalogCategory.content, title: 'Cards e conteúdo', subtitle: 'Itens da lista, resumo, gêneros, capa e avatar', icon: Icons.view_agenda_outlined),
  CategoryData(id: CatalogCategory.feedback, title: 'Feedback e carregamento', subtitle: 'Carregando de tela, vazio, erro, esqueletos e diálogo', icon: Icons.hourglass_empty_rounded),
  CategoryData(id: CatalogCategory.labels, title: 'Rótulos e texto', subtitle: 'Títulos de seção, rótulos de campo, mensagens e legendas', icon: Icons.label_outline_rounded),
  CategoryData(id: CatalogCategory.tokens, title: 'Tokens', subtitle: 'Cores nos temas claro e escuro, tipografia, espaçamento e raios', icon: Icons.palette_outlined),
];
