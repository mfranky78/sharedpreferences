import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: DatenBank()));
}

class DatenBank extends StatefulWidget {
  const DatenBank({Key? key}) : super(key: key);

  @override
  State<DatenBank> createState() => _DatenBankState();
}

class _DatenBankState extends State<DatenBank> {
  String storeData = '';
  String keyText = 'KeyText';
  final picker = ImagePicker();
  String? imagePath;

  void createData() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    await store.setString(keyText, 'Value1');
  }

  void updateData() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    await store.setString(keyText, 'Value1');
  }

  void readData() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    setState(() {
      storeData = store.getString(keyText) ?? 'Unbekannt';
    });
    debugPrint(storeData);
  }

  void removeData() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.remove(keyText);
  }

  Future<void> selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<void> selectImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('imagePath');
    setState(() {
      imagePath = path;
    });
  }

  TextEditingController textController = TextEditingController();
  String savedText = '';

  @override
  void initState() {
    super.initState();
    loadSavedText();
  }

  Future<void> loadSavedText() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedText = prefs.getString('savedText') ?? '';
    });
  }

  Future<void> saveText() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('savedText', textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DatenBank_ SharedPreferences')),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Aufgabe 1 und 2'),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: createData,
                child: const Text("speichern"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: readData, child: const Text('Abfrage')),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: removeData, child: const Text('Löschen')),
            ],
          ),
        ),
        const SizedBox(height: 30),
      const Text('Aufgabe 3'),
        Container(
          color: Colors.grey,
          child: Text(
            storeData,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Text eingeben',
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveText();
                    },
                    child: const Text('Speichern'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      loadSavedText();
                      textController.text = savedText;
                    },
                    child: const Text('Laden und Einfügen'),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Text('Zusatzaufgabe'),
              if (imagePath != null)
                Image.file(
                  File(imagePath!),
                  width: 150,
                  height: 150,
                ),
              Row(
                children: [
                  SizedBox(width: 130,
                    child: ElevatedButton(
                      onPressed: selectImageCamera,
                      child: const Text('Bild machen'),
                    ),
                  ),
                  SizedBox(width: 130,
                    child: ElevatedButton(
                      onPressed: selectImage,
                      child: const Text('Bild auswählen'),
                    ),
                  ),
                  SizedBox(width: 100,
                    child: ElevatedButton(
                      onPressed: loadImage,
                      child: const Text('Bild laden'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ])),
    );
  }
}
