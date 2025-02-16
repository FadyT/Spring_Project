
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: Column(
        children: [
          Expanded(
            child: _images.isEmpty
                ? const Center(child: Text("No images selected"))
                : ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(_images[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _pickImages,
              child: const Text("Pick Image"),
            ),
          ),
        ],
      ),
    );
  }
}
