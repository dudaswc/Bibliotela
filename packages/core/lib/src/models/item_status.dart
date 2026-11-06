/// Where an item is in the person's life. The string values match the API
/// contract (`in_progress` has an underscore there).
enum ItemStatus {
  want('want'),
  inProgress('in_progress'),
  done('done');

  const ItemStatus(this.json);

  /// The value sent to and received from the API.
  final String json;

  static ItemStatus fromJson(String value) => ItemStatus.values.firstWhere(
    (status) => status.json == value.toLowerCase(),
    orElse: () => throw FormatException('Unknown item status: $value'),
  );

  String toJson() => json;
}
