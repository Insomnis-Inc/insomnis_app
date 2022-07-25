import 'dart:io';

import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/groupController.dart';
import 'package:brokerstreet/toast.dart';
import 'package:brokerstreet/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class GroupCreate extends StatefulWidget {
  const GroupCreate({Key? key}) : super(key: key);

  @override
  _GroupCreateState createState() => _GroupCreateState();
}

class _GroupCreateState extends State<GroupCreate> {
  TextEditingController _nameController = TextEditingController();
  File? attached;
  final ImagePicker _picker = ImagePicker();
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
    setState(() {
      images.add("Add Image");
    });
  }

  _submit() {
    String _name = _nameController.text;
    if (_name.length < 3) {
      return;
    }
    for (var row in images) {
      if (row.runtimeType == ImageUploadModel) {
        attached = row.imageFile;
      }
    }

    try {
      groupCreate(name: _name, profilePic: attached).then((res) {
        if (res) {
          showSuccessToast("Group created", context);
          return;
        } else {
          showToast("Connection error", context);
          return;
        }
      });

      Navigator.pop(context);
    } catch (e) {
      print('More $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double v16 = width / 20;
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      appBar: AppBar(
        backgroundColor: svGetScaffoldColor(),
        iconTheme: IconThemeData(color: context.iconColor),
        title: Text('Create Group', style: boldTextStyle(size: 20)),
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: ListView(
          padding: EdgeInsets.only(left: v16, right: v16, top: v16),
          children: [
            Container(
              margin: EdgeInsets.only(top: v16),
              child: TextField(
                autofocus: false,
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: "Group name",
                  hintStyle: TextStyle(color: APP_GREY),
                  focusColor: APP_PRIMARY,
                  prefixIcon: Icon(Icons.people),
                  border: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                  errorBorder: outlineInputBorder,
                  disabledBorder: outlineInputBorder,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: v16,
                left: 0,
              ),
              child: buildGridView(),
            ),
            GestureDetector(
              onTap: () => _submit(),
              child: Container(
                margin: EdgeInsets.only(top: v16 * 2, right: v16 * 2.4),
                child: normalButton(
                  v16: v16,
                  title: "Create Group",
                  bgColor: APP_ACCENT,
                  // callback: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            color: svGetScaffoldColor(),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile!,
                  width: 200,
                  height: 200,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 32,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            color: context.cardColor,
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: APP_ACCENT,
                  ),
                  onPressed: () {
                    _onAddImageClick(index);
                  },
                ),
                Text('Group Image', style: boldTextStyle(color: APP_ACCENT)),
              ],
            ),
          ).onTap(() => _onAddImageClick(index));
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    final XFile? imageX = await _picker.pickImage(source: ImageSource.gallery);
    File? image = File(imageX!.path);

    getFileImage(index, image);
  }

  void getFileImage(int index, File imageFile) async {
    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = imageFile;
      imageUpload.imageUrl = '';
      images.replaceRange(index, index + 1, [imageUpload]);
    });
  }
}

class ImageUploadModel {
  bool? isUploaded;
  bool? uploading;
  File? imageFile;
  String? imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
