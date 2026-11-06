import 'errors.dart';
import 'genres.dart';
import 'models.dart';

const _dateMessage = 'must be a date in the format YYYY-MM-DD';

/// Texto lido do JSON: nulo se vier vazio; `invalid` se nao for texto.
class _Text {
  const _Text(this.value, {this.invalid = false});

  final String? value;
  final bool invalid;
}

_Text _text(Object? raw) {
  if (raw == null) return const _Text(null);
  if (raw is String) {
    final trimmed = raw.trim();
    return _Text(trimmed.isEmpty ? null : trimmed);
  }
  return const _Text(null, invalid: true);
}

/// True se [value] e uma data de calendario valida no formato YYYY-MM-DD.
bool isValidDate(String value) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) return false;
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final date = DateTime.utc(year, month, day);
  return date.year == year && date.month == month && date.day == day;
}

class _DateField {
  const _DateField(this.value, {this.invalid = false});

  final String? value;
  final bool invalid;
}

_DateField _date(Object? raw) {
  final text = _text(raw);
  if (text.invalid) return const _DateField(null, invalid: true);
  final value = text.value;
  if (value == null) return const _DateField(null);
  return isValidDate(value) ? _DateField(value) : const _DateField(null, invalid: true);
}

int? _positiveInt(Object? raw, Map<String, String> fields, String name) {
  if (raw == null) return null;
  if (raw is int) {
    if (raw > 0) return raw;
    fields[name] = 'must be greater than zero';
    return null;
  }
  fields[name] = 'must be an integer';
  return null;
}

/// Valida e normaliza o corpo de POST /items e PUT /items/:id.
///
/// - Campos que nao valem para o status ou para o tipo sao descartados (viram null).
/// - Faltar o que e obrigatorio, ou mandar valor invalido para um campo que vale, da 422.
/// - `id` e `addedAt` vem do servidor; se vierem no corpo, sao ignorados.
Item parseItem(Map<String, dynamic> body, {required String id, required String addedAt}) {
  final fields = <String, String>{};

  final rawType = body['type'];
  final String? type = (rawType is String && itemTypes.contains(rawType)) ? rawType : null;
  if (type == null) fields['type'] = 'must be one of: ${itemTypes.join(', ')}';

  final title = _text(body['title']);
  if (title.invalid) {
    fields['title'] = 'must be a string';
  } else if (title.value == null) {
    fields['title'] = 'must not be empty';
  }

  final genreText = _text(body['genre']);
  String? genre;
  if (genreText.invalid || (genreText.value != null && !genres.contains(genreText.value))) {
    fields['genre'] = 'must be one of the values from /genres';
  } else {
    genre = genreText.value;
  }

  final rawStatus = body['status'];
  final String? status = (rawStatus is String && itemStatuses.contains(rawStatus)) ? rawStatus : null;
  if (status == null) fields['status'] = 'must be one of: ${itemStatuses.join(', ')}';

  String? startedAt;
  String? finishedAt;
  int? rating;
  if (status != null) {
    final started = _date(body['startedAt']);
    final finished = _date(body['finishedAt']);
    if (status == 'in_progress') {
      if (started.invalid) {
        fields['startedAt'] = _dateMessage;
      } else if (started.value == null) {
        fields['startedAt'] = 'is required when status is in_progress';
      } else {
        startedAt = started.value;
      }
    } else if (status == 'done') {
      if (finished.invalid) {
        fields['finishedAt'] = _dateMessage;
      } else if (finished.value == null) {
        fields['finishedAt'] = 'is required when status is done';
      } else {
        finishedAt = finished.value;
      }
      if (started.invalid) {
        fields['startedAt'] = _dateMessage;
      } else {
        startedAt = started.value;
      }
      final s = startedAt;
      final f = finishedAt;
      if (s != null && f != null && s.compareTo(f) > 0) {
        fields['startedAt'] = 'must not be after finishedAt';
      }
      final rawRating = body['rating'];
      if (rawRating != null) {
        if (rawRating is int && rawRating >= 1 && rawRating <= 10) {
          rating = rawRating;
        } else {
          fields['rating'] = 'must be an integer from 1 to 10';
        }
      }
    }
    // status want: datas e nota sao descartadas.
  }

  int? pages;
  String? author;
  int? seasons;
  int? durationMinutes;
  if (type == 'book') {
    pages = _positiveInt(body['pages'], fields, 'pages');
    final authorText = _text(body['author']);
    if (authorText.invalid) {
      fields['author'] = 'must be a string';
    } else {
      author = authorText.value;
    }
  } else if (type == 'series') {
    seasons = _positiveInt(body['seasons'], fields, 'seasons');
  } else if (type == 'movie') {
    durationMinutes = _positiveInt(body['durationMinutes'], fields, 'durationMinutes');
  }

  final noteText = _text(body['note']);
  String? note;
  if (noteText.invalid) {
    fields['note'] = 'must be a string';
  } else {
    note = noteText.value;
  }

  if (fields.isNotEmpty) throw ApiException.validation(fields);

  return Item(
    id: id,
    type: type!,
    title: title.value!,
    genre: genre,
    status: status!,
    startedAt: startedAt,
    finishedAt: finishedAt,
    rating: rating,
    note: note,
    pages: pages,
    author: author,
    seasons: seasons,
    durationMinutes: durationMinutes,
    addedAt: addedAt,
  );
}

/// Nome e avatar ja normalizados, vindos do corpo de PUT /me.
class ProfileInput {
  const ProfileInput({required this.name, required this.avatarUrl});

  final String name;
  final String? avatarUrl;
}

/// Valida o corpo de PUT /me.
ProfileInput parseProfile(Map<String, dynamic> body) {
  final fields = <String, String>{};
  final name = _text(body['name']);
  if (name.invalid) {
    fields['name'] = 'must be a string';
  } else if (name.value == null) {
    fields['name'] = 'must not be empty';
  }
  final avatar = _text(body['avatarUrl']);
  if (avatar.invalid) fields['avatarUrl'] = 'must be a string or null';
  if (fields.isNotEmpty) throw ApiException.validation(fields, message: 'Invalid profile');
  return ProfileInput(name: name.value!, avatarUrl: avatar.value);
}
