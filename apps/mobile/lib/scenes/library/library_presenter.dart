import 'package:bibliotela_core/bibliotela_core.dart';
import 'package:bibliotela_design_system/bibliotela_design_system.dart';

/// How the domain items look on the screen: the data layer knows `Item`, the
/// design system knows `MediaType`; this is the bridge.
MediaType mediaTypeOf(ItemType type) => switch (type) {
  ItemType.book => MediaType.book,
  ItemType.series => MediaType.series,
  ItemType.movie => MediaType.movie,
};

MediaStatus mediaStatusOf(ItemStatus status) => switch (status) {
  ItemStatus.want => MediaStatus.want,
  ItemStatus.inProgress => MediaStatus.inProgress,
  ItemStatus.done => MediaStatus.done,
};

/// `181` becomes `3 h 01 min`, and `45` becomes `45 min`.
String formatDuration(int minutes) {
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (hours == 0) return '$rest min';
  return '$hours h ${rest.toString().padLeft(2, '0')} min';
}

/// Second line of an item: genre and the detail of its type.
/// `Ficção científica · Frank Herbert`, `Suspense · 2 temporadas`,
/// `Drama · 3 h 01 min`.
String subtitleOf(Item item) {
  final detail = switch (item.type) {
    ItemType.book => item.author,
    ItemType.series =>
      item.seasons == null
          ? null
          : '${item.seasons} ${item.seasons == 1 ? 'temporada' : 'temporadas'}',
    ItemType.movie =>
      item.durationMinutes == null ? null : formatDuration(item.durationMinutes!),
  };
  return [item.genre ?? 'Sem gênero', if (detail != null) detail].join(' · ');
}

/// The short date on the right of a finished item (`06 set`).
String? dateLabelOf(Item item) =>
    item.status == ItemStatus.done && item.finishedAt != null
    ? formatShortDay(item.finishedAt!)
    : null;
