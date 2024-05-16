base class Software {
  const Software({
    required this.name,
    required this.cornerRadius,
    required this.dimension,
    required this.iconColor,
    required this.color,
    required this.icon,
  });

  final int icon;
  final int color;
  final String name;
  final int iconColor;
  final double dimension;
  final double cornerRadius;

  factory Software.fromJson(Map<String, Object?> json) => Software(
        name: json['name'] as String,
        cornerRadius: json['cornerRadius'] as double,
        dimension: json['dimension'] as double,
        iconColor: json['iconColor'] as int,
        color: json['color'] as int,
        icon: json['icon'] as int,
      );

  factory Software.fromObjects(List<Object?> objects) => Software(
        icon: objects[0] as int,
        name: objects[1] as String,
        color: objects[2] as int,
        iconColor: objects[3] as int,
        dimension: objects[4] as double,
        cornerRadius: objects[5] as double,
      );

  Map<String, Object?> toJson() => {
        'icon': icon,
        'name': name,
        'color': color,
        'iconColor': iconColor,
        'dimension': dimension,
        'cornerRadius': cornerRadius,
      };

  List<Object> toObjects() => [
        icon,
        name,
        color,
        iconColor,
        dimension,
        cornerRadius,
      ];
}
