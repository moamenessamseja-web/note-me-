/// A note category (Work / Ideas / Personal / Learning ...).
class Category {
  final String id;
  final String name;
  final String color;
  final String icon;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  Category copyWith({String? name, String? color, String? icon}) => Category(
        id: id,
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon ?? this.icon,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'icon': icon,
      };

  factory Category.fromJson(Map<String, dynamic> j) => Category(
        id: j['id'] as String,
        name: (j['name'] as String?) ?? '',
        color: (j['color'] as String?) ?? 'blue-600',
        icon: (j['icon'] as String?) ?? 'tag',
      );
}
