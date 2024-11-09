// upload_image_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:auth0_flutter/auth0_flutter.dart';

import 'image_detail.dart';


class UploadImagePage extends StatefulWidget {
  final UserProfile? user;
  final Future<void> Function() logoutAction;

  const UploadImagePage({super.key, required this.user, required this.logoutAction});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  bool isLoading = false;

  Future<void> selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
      setState(() {});
    }
  }

  Future<void> uploadImagesAndNavigate() async {
    setState(() {
      isLoading = true;
    });

    // Simulate upload to MongoDB
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImageDetailsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFFFD6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Upload Images'),
        backgroundColor: const Color(0xFF33244D),
        actions: [
          if (widget.user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ProfileIcon(
                logoutAction: widget.logoutAction,
                user: widget.user,
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: imageFileList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList[index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MaterialButton(
                  color: const Color.fromARGB(211, 46, 168, 77),
                  textColor: Colors.white,
                  child: const Text("Upload Images"),
                  onPressed: () async {
                    await selectImages();
                    if (imageFileList.isNotEmpty) {
                      await uploadImagesAndNavigate();
                    }
                  },
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final Future<void> Function() logoutAction;
  final UserProfile? user;

  const ProfileIcon({required this.logoutAction, required this.user, Key? key}) : super(key: key);

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Offset(overlay.size.width - 80, 80) & const Size(100, 100),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'username',
          child: Text('Name: ${user?.name ?? 'User'}'),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
    ).then((value) async {
      if (value == 'logout') {
        await logoutAction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPopupMenu(context),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(user?.pictureUrl.toString() ?? ''),
        backgroundColor: Colors.grey,
        child: user?.pictureUrl == null ? const Text('S', style: TextStyle(color: Colors.white)) : null,
      ),
    );
  }
}
