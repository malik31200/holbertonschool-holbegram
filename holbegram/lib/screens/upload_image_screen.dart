import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../methods/auth_methods.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  final AuthMethode _authMethode = AuthMethode();
  Uint8List? _image;
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),

            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),

            Image.asset('assets/images/logo.png', height: 100),

            Text(
              'Hello, ${widget.username} Welcome to Holberton.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(
              'Choose an image from your gallery or take a new one.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            _image != null
                ? CircleAvatar(
                    radius: 80,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/icon.png'),
                  ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: selectImageFromGallery,
                  icon: Icon(Icons.image_outlined, color: Colors.red, size: 40),
                ),

                IconButton(
                  onPressed: selectImageFromCamera,
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        String res = await _authMethode.signUpUser(
                          email: widget.email,
                          username: widget.username,
                          password: widget.password,
                          file: _image,
                        );

                        if (!mounted) return;

                        if (res == 'success') {
                          messenger.showSnackBar(
                            SnackBar(content: Text('success')),
                          );
                        }
                      } catch (e) {
                        if (!mounted) return;

                        messenger.showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 24),
              ),
              child: Text(_isLoading ? 'Loading...' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
