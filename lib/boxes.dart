import 'package:hive/hive.dart';

import 'models/books.dart';

class Boxes {
  static Box<Books> getBooks() => Hive.box<Books>('books');
}
