import 'errors.dart';
import 'genres.dart';
import 'models.dart';

/// Parametros de GET /items, ja validados.
class ItemQuery {
  const ItemQuery({
    this.year,
    this.status,
    this.type,
    this.genre,
    this.q,
    this.page = 1,
    this.pageSize = 20,
  });

  /// Le e valida os parametros. Parametro vazio e tratado como ausente.
  factory ItemQuery.fromParams(Map<String, String> params) {
    String? value(String key) {
      final raw = params[key];
      if (raw == null || raw.trim().isEmpty) return null;
      return raw.trim();
    }

    final fields = <String, String>{};

    final year = value('year');
    if (year != null && !RegExp(r'^\d{4}$').hasMatch(year)) {
      fields['year'] = 'must be in the format YYYY';
    }

    final status = value('status');
    if (status != null && !itemStatuses.contains(status)) {
      fields['status'] = 'must be one of: ${itemStatuses.join(', ')}';
    }

    final type = value('type');
    if (type != null && !itemTypes.contains(type)) {
      fields['type'] = 'must be one of: ${itemTypes.join(', ')}';
    }

    final genre = value('genre');
    if (genre != null && !genres.contains(genre)) {
      fields['genre'] = 'must be one of the values from /genres';
    }

    var page = 1;
    final rawPage = value('page');
    if (rawPage != null) {
      final parsed = int.tryParse(rawPage);
      if (parsed == null || parsed < 1) {
        fields['page'] = 'must be an integer greater than or equal to 1';
      } else {
        page = parsed;
      }
    }

    var pageSize = 20;
    final rawPageSize = value('pageSize');
    if (rawPageSize != null) {
      final parsed = int.tryParse(rawPageSize);
      if (parsed == null || parsed < 1 || parsed > 100) {
        fields['pageSize'] = 'must be an integer from 1 to 100';
      } else {
        pageSize = parsed;
      }
    }

    if (fields.isNotEmpty) throw ApiException.validation(fields, message: 'Invalid query');

    return ItemQuery(
      year: year,
      status: status,
      type: type,
      genre: genre,
      q: value('q'),
      page: page,
      pageSize: pageSize,
    );
  }

  final String? year;
  final String? status;
  final String? type;
  final String? genre;
  final String? q;
  final int page;
  final int pageSize;
}

/// Uma pagina de resultado. `total` conta os itens depois dos filtros.
class ItemPage {
  const ItemPage({required this.items, required this.page, required this.pageSize, required this.total});

  final List<Item> items;
  final int page;
  final int pageSize;
  final int total;

  Map<String, Object?> toJson() => {
        'items': [for (final item in items) item.toJson()],
        'page': page,
        'pageSize': pageSize,
        'total': total,
      };
}

bool _matches(Item item, ItemQuery query) {
  if (query.status != null && item.status != query.status) return false;
  if (query.type != null && item.type != query.type) return false;
  if (query.genre != null && item.genre != query.genre) return false;

  // Itens want nao tem data de leitura: aparecem em qualquer ano.
  final year = query.year;
  if (year != null && item.status != 'want') {
    final date = item.readingDate;
    if (date == null || !date.startsWith('$year-')) return false;
  }

  final q = query.q;
  if (q != null) {
    final needle = q.toLowerCase();
    final inTitle = item.title.toLowerCase().contains(needle);
    final inAuthor = (item.author ?? '').toLowerCase().contains(needle);
    if (!inTitle && !inAuthor) return false;
  }
  return true;
}

/// Primeiro os itens com data de leitura, do mais recente para o mais antigo
/// (empate: o mais novo em addedAt). Depois os want, do adicionado mais
/// recentemente para o mais antigo.
int _compare(Item a, Item b) {
  final da = a.readingDate;
  final db = b.readingDate;
  if (da != null && db != null) {
    final byDate = db.compareTo(da);
    return byDate != 0 ? byDate : b.addedAt.compareTo(a.addedAt);
  }
  if (da != null) return -1;
  if (db != null) return 1;
  return b.addedAt.compareTo(a.addedAt);
}

ItemPage listItems(List<Item> all, ItemQuery query) {
  final filtered = all.where((item) => _matches(item, query)).toList()..sort(_compare);
  final start = (query.page - 1) * query.pageSize;
  final end = start + query.pageSize;
  final slice = start >= filtered.length
      ? <Item>[]
      : filtered.sublist(start, end > filtered.length ? filtered.length : end);
  return ItemPage(items: slice, page: query.page, pageSize: query.pageSize, total: filtered.length);
}
