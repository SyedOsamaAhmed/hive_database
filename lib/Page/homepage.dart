import 'package:flutter/material.dart';

import 'package:hive_example/boxes.dart';
import 'package:hive_example/models/books.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController name, id;
  final box = Boxes.getBooks();
  @override
  void initState() {
    name = TextEditingController();
    id = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void delete(Books book) async {
    await book.delete();
  }

  Future<void> _editDialog(Books book) {
    name.text = book.name;
    id.text = book.id.toString();
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Enter Book Name'),
                controller: name,
              ),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  book.name = name.text;
                  book.id = int.parse(id.text);
                  await box.put(book.id, Books(name.text, int.parse(id.text)));
                  name.clear();
                  id.clear();
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: const Text('Edit')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel')),
          ],
        );
      },
    );
  }

  void update(Books book) async {
    _editDialog(book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive DB'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(hintText: 'Enter Book Name'),
                controller: name,
                // onChanged: (value) {
                //   name.text = value;
                // },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // onChanged: (value) {
                //   id.text = value;
                //   logs.log(id.text);
                // },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Enter Book ID'),
                controller: id,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Books book = Books(name.text, int.parse(id.text));

                    box.add(book);
                    book.save();
                    id.clear();
                    name.clear();
                  },
                  child: const Text('Add'),
                ),
                const SizedBox(
                  width: 12,
                  height: 12,
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            ValueListenableBuilder(
              valueListenable: Boxes.getBooks().listenable(),
              builder: (context, box, child) {
                var data = box.values.toList().cast<Books>();
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index].name),
                        contentPadding: const EdgeInsets.all(16.0),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                onTap: () => delete(data[index]),
                                child: const Icon(Icons.delete)),
                            InkWell(
                                onTap: () => update(data[index]),
                                child: const Icon(Icons.edit)),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
