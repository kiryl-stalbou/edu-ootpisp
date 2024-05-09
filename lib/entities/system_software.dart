import 'package:lab2/entities/_software.dart';

abstract base class SystemSoftware extends Software {
  const SystemSoftware({
    required super.name,
    required super.icon,
    required super.cornerRadius,
    required super.dimension,
    required super.iconColor,
    required super.color,
  });
}
