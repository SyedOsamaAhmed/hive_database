import 'package:hive/hive.dart';
part 'books.g.dart';

@HiveType(typeId: 0)
class Books extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int id;

  Books(this.name, this.id);
}
