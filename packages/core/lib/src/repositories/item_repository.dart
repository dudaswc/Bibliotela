import '../models/item.dart';
import '../models/item_filter.dart';
import '../models/page.dart';
import '../models/summary.dart';
import '../result/result.dart';

/// Items of the signed-in user.
abstract interface class ItemRepository {
  Future<Result<Page<Item>>> list(ItemFilter filter);

  Future<Result<Item>> getById(String id);

  /// `item.id` and `item.addedAt` are ignored; the repository assigns them.
  Future<Result<Item>> create(Item item);

  /// Replaces the whole item. The original `addedAt` is kept.
  Future<Result<Item>> update(Item item);

  Future<Result<void>> delete(String id);

  /// What the person finished in [year].
  Future<Result<Summary>> summary(int year);

  /// Emits the full current list after every successful mutation, so a screen
  /// can react to a change made elsewhere.
  Stream<List<Item>> watch();
}
