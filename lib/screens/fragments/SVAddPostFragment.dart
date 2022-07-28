// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:brokerstreet/screens/SVDashboardScreen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brokerstreet/custom_colors.dart';
import 'package:brokerstreet/http/controllers/postController.dart';
import 'package:brokerstreet/toast.dart';
import 'package:brokerstreet/utils/SVConstants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:brokerstreet/main.dart';
import 'package:brokerstreet/screens/addPost/components/SVPostOptionsComponent.dart';
import 'package:brokerstreet/screens/addPost/components/SVPostTextComponent.dart';
import 'package:brokerstreet/utils/SVColors.dart';
import 'package:brokerstreet/utils/SVCommon.dart';

import '../../http/controllers/eventController.dart';
import '../../http/controllers/groupController.dart';
import '../../http/models/Extra.dart';

class SVAddPostFragment extends StatefulWidget {
  final bool isExtra;
  final Extra? extra;
  final bool isGroup;
  final String? groupId;
  const SVAddPostFragment(
      {Key? key,
      this.isEvent = false,
      this.isGroup = false,
      this.groupId,
      this.extra,
      this.isExtra = false})
      : super(key: key);
  final bool isEvent;

  @override
  State<SVAddPostFragment> createState() => _SVAddPostFragmentState();
}

class _SVAddPostFragmentState extends State<SVAddPostFragment> {
  String image = '';
  late TextEditingController _textEditingController;
  File? attached;
  final ImagePicker _picker = ImagePicker();
  List<dynamic> images = [];

  String eventType = 'Clubs';

  late final List<String> items;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    items = getEvents();
    afterBuildCreated(() {
      setStatusBarColor(context.cardColor);
    });
    setState(() {
      images.add("Add Image");
    });
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode ? appBackgroundColorDark : SVAppLayoutBackground);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: AppBar(
        // leading: InkWell(
        //   onTap: () => SVDashboardScreen().launch(context),
        //   child: Icon(
        //     Icons.arrow_back,
        //     color: REAL_BLACK,
        //   ),
        // ),
        iconTheme: IconThemeData(color: context.iconColor),
        backgroundColor: context.cardColor,
        title: Text(
            widget.isEvent
                ? 'New Event'
                : widget.isGroup
                    ? 'Group Post'
                    : widget.isExtra
                        ? widget.extra!.name!
                        : 'New Post',
            style: boldTextStyle(size: 20)),
        elevation: 0,
        centerTitle: false,
        actions: [
          AppButton(
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
            text: 'Post',
            textStyle: secondaryTextStyle(color: Colors.white, size: 17),
            onTap: () async {
              // svShowShareBottomSheet(context);
              String type = 'text';
              for (var row in images) {
                if (row.runtimeType == ImageUploadModel) {
                  attached = row.imageFile;
                  type = 'image';
                }
              }
              if (attached == null) {
                type = 'text';
              } else {
                String extension = attached!.path.split('.').last;
                print(extension);
                if (extension == 'png' ||
                    extension == 'jpg' ||
                    extension == 'gif') {
                  type = 'image';
                }
                if (extension == 'mp4') {
                  type = 'video';
                }
              }

              // showToast("", context)
              print('test233 start');

              try {
                if (widget.isEvent) {
                  print("event call");
                  eventCreate(
                          type: type,
                          eventType: eventType,
                          text: _textEditingController.text,
                          attached: attached)
                      .then((res) {
                    if (res) {
                      showSuccessToast("Event created", context);
                      return;
                    } else {
                      showToast("Connection error", context);
                      return;
                    }
                  });
                } else if (widget.isGroup) {
                  //

                  groupPostCreate(
                          type: type,
                          groupId: widget.groupId!,
                          text: _textEditingController.text,
                          attached: attached)
                      .then((res) {
                    if (res) {
                      showSuccessToast("Group Post created", context);
                      return;
                    } else {
                      showToast("Connection error", context);
                      return;
                    }
                  });
                } else {
                  postCreate(
                          type: type,
                          text: _textEditingController.text,
                          attached: attached)
                      .then((res) {
                    if (res) {
                      showSuccessToast("Post created", context);
                      return;
                    } else {
                      showToast("Connection error", context);
                      return;
                    }
                  });
                }
                print('test233 done');
                Navigator.pop(context);
              } catch (e) {
                print('More $e');
              }
            },
            elevation: 0,
            color: SVAppColorPrimary,
            // width: ,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ).paddingOnly(right: 8, top: 8, bottom: 8),
        ],
      ),
      body: SizedBox(
        height: context.height(),
        child: Stack(
          children: [
            ListView(
              children: [
                SVPostTextComponent(_textEditingController),
                if (widget.isEvent)
                  Container(
                    padding: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          'Select Event type',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: eventType,
                        onChanged: (value) {
                          setState(() {
                            eventType = value as String;
                          });
                        },
                        // buttonHeight: 40,
                        // buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: attached != null
                      ? Text("media uploaded", style: boldTextStyle())
                      : Offstage(),
                ),
              ],
            ),
            Positioned(
              child: Container(
                width: context.width(),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: svGetScaffoldColor(),
                  borderRadius: radiusOnly(
                      topRight: SVAppContainerRadius,
                      topLeft: SVAppContainerRadius),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              // Capture a photo
                              final XFile? photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              setState(() {
                                attached =
                                    photo != null ? File(photo.path) : null;
                              });
                            },
                            child: Container(
                              // height: 62,
                              // width: 52,
                              // color: context.cardColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: CircleAvatar(
                                radius: 24,
                                // backgroundColor: ,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 24,
                                  color: REAL_WHITE,
                                ),
                              ),
                              // child: ,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final XFile? photo = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                attached =
                                    photo != null ? File(photo.path) : null;
                              });
                            },
                            child: Container(
                              // height: 62,
                              // width: 52,
                              // color: context.cardColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: CircleAvatar(
                                radius: 24,
                                // backgroundColor: ,
                                child: Icon(
                                  EvaIcons.imageOutline,
                                  size: 24,
                                  color: REAL_WHITE,
                                ),
                              ),
                              // child: ,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final XFile? video = await _picker.pickVideo(
                                  source: ImageSource.gallery);
                              setState(() {
                                attached =
                                    video != null ? File(video.path) : null;
                              });
                            },
                            child: Container(
                              // height: 62,
                              // width: 52,
                              // color: context.cardColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: CircleAvatar(
                                radius: 24,
                                // backgroundColor: ,
                                child: Icon(
                                  EvaIcons.videoOutline,
                                  size: 24,
                                  color: REAL_WHITE,
                                ),
                              ),
                              // child: ,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: 0,
            ).visible(true),
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
                  width: 300,
                  height: 300,
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
                Text('Add Image', style: boldTextStyle(color: APP_ACCENT)),
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
