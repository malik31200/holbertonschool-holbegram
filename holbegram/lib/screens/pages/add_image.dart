import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../home.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> selectImageFromGallery() async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    Uint8List imageBytes = await file.readAsBytes();

    if (!mounted) return;

    setState(() {
      _image = imageBytes;
    });
  }

  Future<void> selectImageFromCamera() async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) return;

    Uint8List imageBytes = await file.readAsBytes();

    if (!mounted) return;

    setState(() {
      _image = imageBytes;
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  selectImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  selectImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _postImage() async {
    final messenger = ScaffoldMessenger.of(context);
    final user = Provider.of<UserProvider>(context, listen: false).getUser;

    if (_image == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please choose an image')),
      );
      return;
    }

    if (user == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('User not loaded, try again')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await PostStorage().uploadPost(
      _captionController.text,
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (res == 'Ok') {
      messenger.showSnackBar(const SnackBar(content: Text('Posted')));
      _captionController.clear();
      setState(() {
        _image = null;
      });
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
    } else {
      messenger.showSnackBar(SnackBar(content: Text(res)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _postImage,
            child: const Text(
              'Post',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 32,
                color: Color.fromARGB(218, 226, 37, 24),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Add Image',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const Text(
              'Choose an image from your gallery or take a one.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _captionController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _showImageSourceSheet,
              child: _image != null
                  ? Image.memory(
                      _image!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/add-picture.webp',
                      width: 250,
                      height: 250,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
