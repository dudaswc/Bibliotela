import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';
import 'package:bibliotela/scenes/library/library_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

Item _item(String title) => SampleData.items().firstWhere((i) => i.title == title);

void main() {
  test('formatDuration', () {
    expect(formatDuration(181), '3 h 01 min');
    expect(formatDuration(132), '2 h 12 min');
    expect(formatDuration(60), '1 h 00 min');
    expect(formatDuration(45), '45 min');
  });

  test('subtitleOf: genre and the detail of each type', () {
    expect(subtitleOf(_item('Duna')), 'Ficção científica · Frank Herbert');
    expect(subtitleOf(_item('Severance')), 'Suspense · 2 temporadas');
    expect(subtitleOf(_item('Chernobyl')), 'Drama · 1 temporada');
    expect(subtitleOf(_item('Oppenheimer')), 'Drama · 3 h 01 min');
  });

  test('subtitleOf: no genre and no detail', () {
    expect(subtitleOf(_item('O Pequeno Príncipe')), 'Sem gênero');
    expect(subtitleOf(_item('Sociedade da Neve')), 'Sem gênero');
    expect(subtitleOf(_item('Succession')), 'Drama');
  });

  test('dateLabelOf only for finished items', () {
    expect(dateLabelOf(_item('Duna')), '06 set');
    expect(dateLabelOf(_item('Titanic')), isNull);
    expect(dateLabelOf(_item('The Bear')), isNull);
  });

  test('maps the domain types and statuses to the design system ones', () {
    expect(ItemType.values.map(mediaTypeOf).toList(), [MediaType.book, MediaType.series, MediaType.movie]);
    expect(
      ItemStatus.values.map(mediaStatusOf).toList(),
      [MediaStatus.want, MediaStatus.inProgress, MediaStatus.done],
    );
  });
}
