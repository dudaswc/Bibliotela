/// Kind of an item. The string values match the API contract.
enum ItemType {
  book,
  series,
  movie;

  static ItemType fromJson(String value) => ItemType.values.firstWhere(
    (type) => type.name == value.toLowerCase(),
    orElse: () => throw FormatException('Unknown item type: $value'),
  );

  String toJson() => name;
}
