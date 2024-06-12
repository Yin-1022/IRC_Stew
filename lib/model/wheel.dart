import 'dart:ui';
import 'package:hive_flutter/hive_flutter.dart';
part 'wheel.g.dart';

@HiveType(typeId: 1)
class Wheel
{
  @HiveField(0)
  int id;
  @HiveField(1)
  String content;
  @HiveField(2)
  Color color;

  @HiveField(3)
  Wheel
  (
      {
        required this.id,
        required this.content,
        required this.color,
      }
  );
}