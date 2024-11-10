import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:http/http.dart' as http;
import 'Buys&sell.dart';
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
      setState(() {
        imageFileList.addAll(selectedImages);
      });
    }
  }

  Future<void> uploadImagesAndNavigate() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://9ce8-2409-40c1-34-e074-8848-d73-18ec-dabe.ngrok-free.app/upload-image');
    final request = http.MultipartRequest('POST', url);

    for (var imageFile in imageFileList) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseString);

        if (decodedResponse is Map<String, dynamic> && decodedResponse['data'] is List) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageDetailsPage(
                responseDataList: List<Map<String, dynamic>>.from(decodedResponse['data']),
              ),
            ),
          );
        } else {
          print("Unexpected response format");
        }
      } else {
        print("Failed to upload images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred while uploading images: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFFFD6),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Upcycle Magic',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        elevation: 4,
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
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imageFileList[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10), // Centered bottom padding
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "Upload Image",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , color: Colors.white),
                      ),
                      onPressed: () async {
                        await selectImages();
                        if (imageFileList.isNotEmpty) {
                          await uploadImagesAndNavigate();
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                      ),
                      child: const Text(
                        "Buy & Sell",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RevenuePage(),
                          ),
                        );
                      },
                    ),

                  ],
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
          child: Text(
            'Name: ${user?.name ?? 'User'}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
        backgroundColor: Colors.green[700],
        child: user?.pictureUrl == null
            ? const Text(
          'S',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
            : null,
      ),
    );
  }
}
